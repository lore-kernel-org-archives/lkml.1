Return-Path: <linux-kernel-owner+w=401wt.eu-S1762554AbZFPWls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762554AbZFPWls (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 18:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754749AbZFPWlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 18:41:37 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:44845 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753774AbZFPWlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 18:41:36 -0400
Message-Id: <1245192098.31604.1320729303@webmail.messagingengine.com>
X-Sasl-Enc: JeSMlxln6r5YNKsGovG8B+jcCROleXUB6K/+AnWVwB/g 1245192098
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Stas Sergeev" <stsp@aknet.ru>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Cyrill Gorcunov" <gorcunov@gmail.com>, "Tejun Heo" <tj@kernel.org>,
       "Zachary Amsden" <zach@vmware.com>,
       "Chuck Ebbert" <76306.1226@compuserve.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Linux kernel" <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <1244378557-5455-1-git-send-email-heukelum@fastmail.fm>
 <1245182594.27756.1320705931@webmail.messagingengine.com>
 <4A380C49.6050206@aknet.ru>
Subject: Re: Ping: Re: [PATCH 0/2] i386: espfix fixes
In-Reply-To: <4A380C49.6050206@aknet.ru>
Date: Wed, 17 Jun 2009 00:41:38 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Jun 2009 01:19:05 +0400, "Stas Sergeev" <stsp@aknet.ru> said:
> Hi.
> 
> 17.06.2009 00:03, Alexander van Heukelum wrote:
> > Just wanted to get a little attention for the espfix fixes...
> >
> > http://lkml.org/lkml/2009/6/7/106 : fix return to 16-bit stack from NMI
> > http://lkml.org/lkml/2009/6/7/109 : fix/simplify espfix, move it into
> > assembly
> >
> > Any objections against those?
> Well, the dynamic limits were advocated
> by Zach and Chuck, so lets ask them first
> (added CCs).

Hi!

I see...

On http://lkml.indiana.edu/hypermail/linux/kernel/0608.0/0162.html:
> > > - .quad 0x0000920000000000 /* 0xd0 - ESPFIX 16-bit SS */
> > > + .quad 0x00cf92000000ffff /* 0xd0 - ESPFIX SS */
> > 
> > Seems a bit dangerous to allow access to full 4GB through this.
> > Can you tighten the limit any? I suppose not, because the high
> > bits in %esp really could be anything. But it might be nice to
> > try setting the limit to regs->esp + THREAD_SIZE. Of course, this
> > is not strictly necessary, just an extra paranoid protection
> > mechanism. 
> Since, when calculating the base, I do &-THREAD_SIZE, I guess the
> minimal safe limit is regs->esp + THREAD_SIZE*2... Well, may just
> I not do that please? :) For what, btw? There are no such a things
> for __KERNEL_DS or anything, so I just don't see the necessity.

In the normal case user-esp would be between 0 and 65535, and in
that case the memory range in the ESPFIX stack segment would be
pretty small. But userspace can set esp to just about anything if
it really wants to, and in that case the reduction of the memory
range is pretty much wothless (kernel stacks are allocated way
above the code). As you said: may we just not do that, please?

> For the rest:
> Acked-by: Stas Sergeev <stsp@aknet.ru>

Thanks, very much appreciated!

> In particular, I am asking now myself why
> have I used THREAD_SIZE there, and can't
> recall the reason...

Other parts of the complete fix were not massochistic enough?
( http://lkml.indiana.edu/hypermail/linux/kernel/0608.0/0858.html )

Greetings,
    Alexander
