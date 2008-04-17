Return-Path: <linux-kernel-owner+w=401wt.eu-S933350AbYDQKTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933350AbYDQKTw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 06:19:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932211AbYDQKTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 06:19:35 -0400
Received: from rv-out-0708.google.com ([209.85.198.249]:14265 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765658AbYDQKTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 06:19:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Tg///tySOCw6+JTp0KxP9gYfNxiheo3jSWIx67YhzS5XNYf5gGhYdFhhSQlHEv6DTNxwcSjpWC/d8lQoBVq1wCdbFUPCJbzHMo/Mp5Ld/xMqUFKf+BScSXbSbKkzWcXm3eF9J99swGz0YRbLS7+dl5T01Fiuels8TL0xnB6dckM=
Message-ID: <84144f020804170319g6e0b90ffq1c42179e084d18f@mail.gmail.com>
Date: Thu, 17 Apr 2008 13:19:32 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [v2.6.26] what's brewing in x86.git for v2.6.26
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Vegard Nossum" <vegard.nossum@gmail.com>
In-Reply-To: <20080417023603.672d1032.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080416202338.GA6007@elte.hu>
	 <20080417002552.5742ad65.akpm@linux-foundation.org>
	 <20080417083000.GA4935@elte.hu>
	 <20080417014054.ea788f1f.akpm@linux-foundation.org>
	 <20080417090626.GA14383@elte.hu>
	 <20080417021813.04df7912.akpm@linux-foundation.org>
	 <20080417093025.GA17389@elte.hu>
	 <20080417023603.672d1032.akpm@linux-foundation.org>
X-Google-Sender-Auth: ffc7969df5d50fd0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2008 at 12:36 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> > you mean kmemcheck? Yes, that's planned. We've been working 4 months
> > non-stop on kmemcheck to make it mergeable and usable, it's at version 7
> > right now, and it caught a handful of real bugs already (such as
> > 63a7138671c - unfortunately not credited in the log to kmemcheck). But
> > because it touches SLUB (because it has to - and they are acked by
> > Pekka) i never had the chance to move it into the for-akpm branch.
>
>  Does it really really really need to consume one of our few remaining page
>  flags?  We'll be in a mess when we run out.

FYI, the initial version of kmemcheck didn't have a separate page flag
(it abused SLUB internals) but it got really hairy and I think I
finally convinced Vegard to switch over to page flags after some
hair-pulling when we hit a bug. So yes, from SLUB maintainer point of
view, we _really, really_ want to use a page flag here.
