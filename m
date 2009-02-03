Return-Path: <linux-kernel-owner+w=401wt.eu-S1755529AbZBCVHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529AbZBCVHX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 16:07:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751630AbZBCVHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 16:07:04 -0500
Received: from [84.77.67.98] ([84.77.67.98]:1666 "EHLO ventoso.org"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752700AbZBCVHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 16:07:03 -0500
X-Greylist: delayed 1531 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Feb 2009 16:07:03 EST
Message-ID: <4988ABEE.6020703@ventoso.org>
Date: Tue, 03 Feb 2009 21:41:18 +0100
From: Luca Olivetti <luca@ventoso.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090114)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Daniel Walker <dwalker@fifo99.com>, Greg KH <gregkh@suse.de>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
       Janne Grunau <janne-dvb@grunau.be>
Subject: Re: [crash] af9005_usb_module_init(): BUG: unable to handle kernel
 paging request at ff100000
References: <20090203172836.GA6964@elte.hu> <1233685361.5903.131.camel@desktop> <20090203193029.GA13726@elte.hu>
In-Reply-To: <20090203193029.GA13726@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

En/na Ingo Molnar ha escrit:
> * Daniel Walker <dwalker@fifo99.com> wrote:
> 
>> On Tue, 2009-02-03 at 18:28 +0100, Ingo Molnar wrote:
>>> FYI, -tip qa keeps triggering this bootup crash occasionally, ever since 
>>> June 2008 when a DVB merge brought in this new driver:
>> It looks like it could be a config problem.. The crash happens around 
>> these two symbol "af9005_rc_keys", and "af9005_rc_keys_size" , and they 
>> are both defined inside af9005-remote.c different from where the init 
>> functions is lcoated .. af9005-remote.c needs a special config 
>> CONFIG_DVB_USB_AF9005_REMOTE to get compiled which you have disabled..
> 
> ok - but it shouldnt crash, obviously.

Did you try my suggestion I sent the past December 26th?
Quote:

El Fri, 26 Dec 2008 11:08:33 -0200
Mauro Carvalho Chehab <mchehab@infradead.org> escribió:
 > > Luca,
 > >
 > > Could you please verify this issue?

No, I don't have 2.6.28, but I guess that maybe once usb_register is
called the dvb-usb subsystem asynchronously (is that an smp system?)
starts polling the remote before the rc_decode function pointer has been
initialized.
Could you try to initialize it to NULL before calling usb_register?

Bye
-- 
Luca
