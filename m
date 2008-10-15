Return-Path: <linux-kernel-owner+w=401wt.eu-S1753244AbYJOJhQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244AbYJOJhQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 05:37:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751390AbYJOJhD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 05:37:03 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48405 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109AbYJOJhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 05:37:01 -0400
Date: Wed, 15 Oct 2008 11:36:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Kosina <jkosina@suse.cz>, Jean Delvare <khali@linux-fr.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [GIT] HID patches for 2.6.28
Message-ID: <20081015093636.GB19403@elte.hu>
References: <alpine.LNX.1.10.0810140055060.26779@jikos.suse.cz> <alpine.LNX.1.10.0810150011280.26779@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0810150011280.26779@jikos.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Kosina <jkosina@suse.cz> wrote:

> [ this is v2 of the request, with these changes compared to the 
> previous one:
> 
> - the compilation warning about unused _compat functions is gone
> - all the quirk-drivers are now built automatically once generic driver is
>   selected (can be overridden for EMBEDDED kernels)
> - three new patches from Mauro adding a few VID/PID ]

this or the I2C updates cause widespread build failures in latest -git:

drivers/built-in.o: In function `wm8400_i2c_write':
wm8400-core.c:(.text+0xa9ce3): undefined reference to `i2c_master_send'
drivers/built-in.o: In function `wm8400_i2c_read':
wm8400-core.c:(.text+0xa9d6b): undefined reference to `i2c_transfer'
drivers/built-in.o: In function `bright_probe':
hid-bright.c:(.text+0x2ac875): undefined reference to `usbhid_set_leds'
drivers/built-in.o: In function `dell_probe':
hid-dell.c:(.text+0x2acfb5): undefined reference to `usbhid_set_leds'
drivers/built-in.o: In function `lg_probe':
hid-lg.c:(.text+0x2ae03d): undefined reference to `usbhid_set_leds'
drivers/built-in.o: In function `hid_lgff_set_autocenter':
hid-lgff.c:(.text+0x2ae1cf): undefined reference to `usbhid_submit_report'
drivers/built-in.o: In function `hid_lgff_play':
hid-lgff.c:(.text+0x2ae28b): undefined reference to `usbhid_submit_report'
drivers/built-in.o: In function `play_effect':
hid-lg2ff.c:(.text+0x2ae3c4): undefined reference to `usbhid_submit_report'
drivers/built-in.o: In function `lg2ff_init':
: undefined reference to `usbhid_submit_report'
drivers/built-in.o: In function `wm8400_module_init':
wm8400-core.c:(.init.text+0x817f): undefined reference to `i2c_register_driver'
drivers/built-in.o: In function `wm8400_module_exit':
wm8400-core.c:(.exit.text+0x60e): undefined reference to `i2c_del_driver'

	Ingo
