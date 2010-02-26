Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933175Ab0BZJzT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 04:55:19 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63085 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932442Ab0BZJzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 04:55:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=CxqBei/hXOfzLUDfb7m7veq8cHZqGfLB5pYY2qmZtYvBPLWYu02ay/pi2ht1XATFdd
         aaUkHCCzERq0GKDpQTODipR1ESQ+sA7LewVNRovDbJB9E02oB110Gj/Qkbp+CnSs2zQx
         TAFaEDwwHR6PTe0FP0orsUez59YwI/jeSp+CA=
MIME-Version: 1.0
In-Reply-To: <1267170179.12041.4.camel@Joe-Laptop.home>
References: <20100225155359.GA2722@darkstar> <20100225185515.GB3305@core2>
	 <a8e1da1002251714l55ccbd44ibc1119770667c62b@mail.gmail.com>
	 <b6fcc0a1002252315k1fd5360ehf5ea33566c19515d@mail.gmail.com>
	 <a8e1da1002252333g6e8bf94crba465c59c0cbc07a@mail.gmail.com>
	 <1267170179.12041.4.camel@Joe-Laptop.home>
Date: Fri, 26 Feb 2010 17:55:14 +0800
Message-ID: <a8e1da1002260155l5e75a473oca5649ab33cce124@mail.gmail.com>
Subject: Re: [PATCH 03/07] kernel.h string cleanup
From: Dave Young <hidave.darkstar@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 26, 2010 at 3:42 PM, Joe Perches <joe@perches.com> wrote:
> On Fri, 2010-02-26 at 15:33 +0800, Dave Young wrote:
>> It will be better to move some of them to proper place instead of kernel.h
>
> Perhaps you could describe some of the reasons why
> it's better to move them.
>
> Maybe you could post the results of a timed compile
> comparison with kernel.h broken into multiple pieces
> while you're at it.
>

Thanks joe.

Spliting is necessary from my point of view.
It will be more clean to put externs/declarations to their own header files.
At the same time compiling time benifits as well.

printk/panic/string/trace header are splited then included by kernel.h so
just hexdump/int_sqrt are actually seperated.

fresh boot and same .config, make without -j, test result as following:

with the patches applied:

time:
real 15m16.504s
user 12m51.866s
sys 1m39.700s

vmlinux .text size: 003bfcd2

without the patches applied*
time:
real 15m20.518s
user 12m54.120s
sys 1m40.190s

vmlinux .text size: 003bfcea

-- 
Regards
dave
