Return-Path: <linux-kernel-owner+w=401wt.eu-S1760831AbYCZRX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760831AbYCZRX4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 13:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763954AbYCZRTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 13:19:53 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:31501 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763952AbYCZRTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 13:19:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XSeFUrznR1rM50AvT54N/Bg4B3tbjLgCDekWzXwaqduEmNnwVwOfPijmChAlFxDBp8NB3m17bIX6vFFt/zHnqj+88RCBIjq1+8vFvKch/0qoKC8DjVFK7ZdJUOLWYWTzzPE/gN9/ZDGFMnl1HS+bgXCDdlgr64SSPDKrnyA4xFw=
Message-ID: <8bd0f97a0803261019o3d4b176eg9817124963b9bc4e@mail.gmail.com>
Date: Wed, 26 Mar 2008 13:19:50 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Paul Mundt" <lethal@linux-sh.org>, "Bryan Wu" <cooloney@kernel.org>,
       wim@iguana.be, linux-kernel@vger.kernel.org,
       "Mike Frysinger" <vapier.adi@gmail.com>
Subject: Re: [PATCH 1/1] Blackfin Watchdog Driver: split platform device/driver registering from actual watchdog device/driver registering so we can cleanly load/unload
In-Reply-To: <20080326163736.GA12632@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1206581401-26046-1-git-send-email-cooloney@kernel.org>
	 <20080326163736.GA12632@linux-sh.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2008 at 12:37 PM, Paul Mundt <lethal@linux-sh.org> wrote:
> On Wed, Mar 26, 2008 at 06:30:01PM -0700, Bryan Wu wrote:
>  > +#define pr_devinit(fmt, args...) ({ static const __devinitdata char __fmt[] = fmt; printk(__fmt, ## args); })
>  >  #define pr_init(fmt, args...) ({ static const __initdata char __fmt[] = fmt; printk(__fmt, ## args); })
>
>  WTF? You are trying to micro-optimize the string? And you have a printk
>  that changes behaviour if you have hotplug enabled or not. That's so
>  utterly bizarre that the rationale must be fascinating.

the rationale behind it seems fairly obvious to me.  the strings are
placed into the respective init sections so they get released as
needed.  it isnt a matter of tying it to hotplug as tying it to the
function: __init or __devinit.

>  pr_xxx() also is a protected namespace that belongs in
>  include/linux/kernel.h, though I can see why you opted to hide these in
>  your driver rather than post them for general inclusion.

actually, it was already posted to lkml some time ago as an idea.  the
idea stalled so i just use it in my drivers in the meantime.  it's
certainly much cleaner than what was proposed by someone else
originally:
char __init foo[] = "moo";
...
    printk(foo, ...)
...

>  If you are hurting that badly for space, just turn off CONFIG_PRINTK and
>  move on with life. This is just insane.

doing it this way seems pretty clean to me using existing section markings.
-mike
