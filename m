Return-Path: <linux-kernel-owner+w=401wt.eu-S1755580AbZBDPRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580AbZBDPRA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 10:17:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751955AbZBDPQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 10:16:50 -0500
Received: from fifo99.com ([67.223.236.141]:55238 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751762AbZBDPQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 10:16:50 -0500
Subject: Re: [crash] af9005_usb_module_init(): BUG: unable to handle kernel
	paging request at ff100000
From: Daniel Walker <dwalker@fifo99.com>
To: Luca Olivetti <luca@ventoso.org>
Cc: Ingo Molnar <mingo@elte.hu>, Greg KH <gregkh@suse.de>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
       Janne Grunau <janne-dvb@grunau.be>
In-Reply-To: <4989ABA8.8010807@ventoso.org>
References: <20090203172836.GA6964@elte.hu>
	 <1233685361.5903.131.camel@desktop> <20090203193029.GA13726@elte.hu>
	 <4988ABEE.6020703@ventoso.org> <1233710080.15119.37.camel@desktop>
	 <4989ABA8.8010807@ventoso.org>
Content-Type: text/plain
Date: Wed, 04 Feb 2009 07:16:47 -0800
Message-Id: <1233760607.15119.85.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-04 at 15:52 +0100, Luca Olivetti wrote:
> En/na Daniel Walker ha escrit:
> > On Tue, 2009-02-03 at 21:41 +0100, Luca Olivetti wrote:
> > 
> >> No, I don't have 2.6.28, but I guess that maybe once usb_register is
> >> called the dvb-usb subsystem asynchronously (is that an smp system?)
> >> starts polling the remote before the rc_decode function pointer has been
> >> initialized.
> >> Could you try to initialize it to NULL before calling usb_register?
> > 
> > What happens to the decode function when you have,
> > 
> > CONFIG_DVB_USB_AF9005=y
> > CONFIG_DVB_USB_AF9005_REMOTE=n
> > 
> > It seems that the decode function is defined inside,
> > drivers/media/dvb/dvb-usb/af9005-remote.c
> > 
> > but that doesn't get compiled in the case above. It looks like you end
> > up with af9005_rc_decode being a function local weak symbol
> > (uninitialized) which then gets assigned to rc_decode .. I think the
> > crash actually happens on rc_keys_size which get assigned another
> > uninitialized local, and it gets de-referenced .
> 
> Doesn't symbol_request return a NULL in such a case?
> At the time I didn't try the above configuration 
> (CONFIG_DVB_USB_AF9005_REMOTE=n), but removed the compiled 
> dvb-usb-af9005-remote.ko, and all was well (i.e. the symbol_request 
> returned NULL and the remote handling was disabled).

I'm not sure what symbol request returns when CONFIG_MODULES=n .. Since
it basically drops symbol_request() into a macro , and you have externs
for all these functions .. Now that I look at it again, I'm not sure how
it compiles..

> > Here's a patch I compile tested, and I think it would fix the issue.
> 
> But it'd break the alternative rc decoding module (not integrated in the 
> kernel because it uses lirc):
> 
> http://ventoso.org/luca/af9005/README.lirc

I guess that would have to be fix with another patch then .. 

Daniel

