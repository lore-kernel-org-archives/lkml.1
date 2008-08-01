Return-Path: <linux-kernel-owner+w=401wt.eu-S1752538AbYHAQBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538AbYHAQBT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 12:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364AbYHAQBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 12:01:10 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:41550 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbYHAQBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 12:01:09 -0400
Message-ID: <489333C6.6070905@keyaccess.nl>
Date: Fri, 01 Aug 2008 18:03:18 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>, Wolfram Sang <w.sang@pengutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Wim Van Sebroeck <wim@iguana.be>,
       =?ISO-8859-15?Q?P=E1draig_Brady?= <P@draigBrady.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "drepper@redhat.com" <drepper@redhat.com>,
       "mikpe@it.uu.se" <mikpe@it.uu.se>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/9] x86, xsave: xsave/xrstor support
References: <20080731215808.GB8563@linux-os.sc.intel.com> <20080731221435.GS23938@one.firstfloor.org> <20080731221924.GD8563@linux-os.sc.intel.com> <alpine.LFD.1.10.0807311531271.3277@nehalem.linux-foundation.org> <20080731225004.GD22426@elte.hu> <48926FC3.3000706@keyaccess.nl> <20080801095105.GA18055@elte.hu> <48931D69.2010309@keyaccess.nl> <20080801144917.GY23938@one.firstfloor.org> <48932975.80508@keyaccess.nl> <20080801154445.GZ23938@one.firstfloor.org>
In-Reply-To: <20080801154445.GZ23938@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01-08-08 17:44, Andi Kleen wrote:
> On Fri, Aug 01, 2008 at 05:19:17PM +0200, Rene Herman wrote:
>> On 01-08-08 16:49, Andi Kleen wrote:
>>
>>>> For real ISA at the least, the best fix I feel is just not go grabbing 
>>>> resources without anything (ie, ISAPnP) or anyone (ie, the user) telling 
>>> Really old systems don't have isapnp. Neither have smbus devices.
>>>
>>>> us that's where the hardware's at.
>>> That would mean the users on these systems would need to add tons
>>> of obscure command line options.
>> No, it means users on those 1% of systems that are using drivers that 
>> break the other 99% would have to for those one or two drivers that do.
>>
>> And as said, we don't care.
> 
> Not sure who "we" is in this context.

We, the old crap hardware users the drivers for which break sensible 
systems by default.

Really, look at the patch I posted -- it's a patch to make passing in a 
base (and irq if you want one) to i2c-pca-isa needed. Right now, the 
thing just grabs those resources and breaks the boot on systems that 
don't have it as per Ingo's testing.

On plain technical grounds mucking with resources you don't own is bad 
(on those old systems, 0x330 might even be a NE2000 which gets confused 
really quickly) and even more importantly; let's take a wild guess and 
assume that that specific ISA driver has, oh let's say, less than 3 
users in the world all of whom wouldn't care one bit about sticking in 
an options line in their modprobe.conf.

There is no reason drivers like that should be allowed to break all the 
_other_ systems instead of making those users do that. Not a single one.

> Especially dropping easy support for all smbus devices (which are often like
> this) would seem quite wrong to me. And for real ISA devices there tends to 
> be a surprisingly large user base left for those.

Fortunately, smbus devices tend to not grab IRQs and go poking around 
the general I/O space willy-nilly (they go poking around the smbus I/O 
space willy-nilly). Note again, this specific case is a _bus_ driver for 
a bus on an ISA card.

Rene
