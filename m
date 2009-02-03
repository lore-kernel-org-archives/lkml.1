Return-Path: <linux-kernel-owner+w=401wt.eu-S1753635AbZBCVdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635AbZBCVdS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 16:33:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbZBCVdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 16:33:03 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51996 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501AbZBCVdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 16:33:01 -0500
Date: Tue, 3 Feb 2009 22:32:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Luca Olivetti <luca@ventoso.org>
Cc: Daniel Walker <dwalker@fifo99.com>, Greg KH <gregkh@suse.de>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
       Janne Grunau <janne-dvb@grunau.be>
Subject: Re: [crash] af9005_usb_module_init(): BUG: unable to handle kernel
	paging request at ff100000
Message-ID: <20090203213245.GD20527@elte.hu>
References: <20090203172836.GA6964@elte.hu> <1233685361.5903.131.camel@desktop> <20090203193029.GA13726@elte.hu> <4988ABEE.6020703@ventoso.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4988ABEE.6020703@ventoso.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Luca Olivetti <luca@ventoso.org> wrote:

> En/na Ingo Molnar ha escrit:
>> * Daniel Walker <dwalker@fifo99.com> wrote:
>>
>>> On Tue, 2009-02-03 at 18:28 +0100, Ingo Molnar wrote:
>>>> FYI, -tip qa keeps triggering this bootup crash occasionally, ever 
>>>> since June 2008 when a DVB merge brought in this new driver:
>>> It looks like it could be a config problem.. The crash happens around 
>>> these two symbol "af9005_rc_keys", and "af9005_rc_keys_size" , and 
>>> they are both defined inside af9005-remote.c different from where the 
>>> init functions is lcoated .. af9005-remote.c needs a special config  
>>> CONFIG_DVB_USB_AF9005_REMOTE to get compiled which you have 
>>> disabled..
>>
>> ok - but it shouldnt crash, obviously.
>
> Did you try my suggestion I sent the past December 26th?
> Quote:
>
> El Fri, 26 Dec 2008 11:08:33 -0200
> Mauro Carvalho Chehab <mchehab@infradead.org> escribió:
> > > Luca,
> > >
> > > Could you please verify this issue?
>
> No, I don't have 2.6.28, but I guess that maybe once usb_register is
> called the dvb-usb subsystem asynchronously (is that an smp system?)
> starts polling the remote before the rc_decode function pointer has been
> initialized.

Correct, and the bug triggered on a 'very SMP' system: a hyperthreading 
system that triggers SMP races much sooner than other (multi-core) SMP 
systems. It also triggered spuriously - i.e. not in a reproducible way.

> Could you try to initialize it to NULL before calling usb_register?

Sorry - there was no patch i think for me to try so i didnt try it. I'll try 
the patch in your next mail. Please queue your fix up for upstream and 
consider the bug fixed, unless i re-report it in a few days. Since it's a 
spurious crash there's no clear reproducer i can test.

	Ingo
