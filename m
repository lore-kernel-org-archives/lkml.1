Return-Path: <linux-kernel-owner+w=401wt.eu-S1762606AbXK2OPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762606AbXK2OPS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 09:15:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755733AbXK2OPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 09:15:05 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:41961 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755098AbXK2OPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 09:15:04 -0500
Date: Thu, 29 Nov 2007 15:14:44 +0100
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: linux-usb@vger.kernel.org, kristoffer.ericson@gmail.com,
       drussell@redhat.com, johann.wilhelm@student.tugraz.at,
       linux-kernel@vger.kernel.org
Subject: Re: Add the infamous Huawei E220 to option.c
Message-ID: <20071129141444.GA27279@gamma.logic.tuwien.ac.at>
References: <20071128161305.b01167b3.zaitcev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071128161305.b01167b3.zaitcev@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pete, hi all,

On Mi, 28 Nov 2007, Pete Zaitcev wrote:
> It looks like the Huawei E220 saga is not over yet. A collegue of mine,
> David Russll, reported that the modem does not work reliably on Fedora 8,
> which does have the initializer in usb-storage.

That is what I said.

> it's random which wins. If usb-storage wins, everything is fine. If option
> wins, it binds to modem still in storage mode and does not work.

That could be the source of my disconnect/reconnect cycles.

> This way no matter which driver wins the modem gets initialized. The
> patch is tested on David's modem, but I would like someone give it more
> testing.
> 
> I dunno, do we want some kind of code sharing between storage and option?
> They both could use the normal usb_control_msg, I think.
> 
> Also, from archives it looks like Johann may need PID 0x1004 added.
> 
> Since we're on topic, David's modem has exactly same IDs as Norbert's,
> but works fine with the length of 1. Although it's possible that the
> firmware is different without different firmware reported in USB desc-
> riptors. Does anyone know a magic AT command? ATI or something?
> Norbert, please try my patch, maybe it'll work this time.

I tried your patch with the reverted 0x1 -> 0 change. But it didn't
work. I get connects/reconnects.

So to be clear: kernl 2.6.24-rc3 + your patch gives me permanent cycles
and an error:
	option_start_huawei: HUAWEI E220 setup failed (1)
I attach the syslog part which exhibits the behaviour.

> And finally, pleas stop using that script from the polish website and

Did it already, but without the 0x1->0 change it does not work here.

> above all quit using the generic serial subdriver. The option must

Long done, I assume that the option module depending on usbserial is not
the problem.

> work now with the patch. Please let me know if it fails.

It does.

Best wishes

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
MUNDERFIELD (n.) A meadow selected, whilst driving past, as being
ideal for a picnic which, from a sitting position, turns out to be
full of stubble, dust and cowpats, and almost impossible to enjoy
yourself in.
			--- Douglas Adams, The Meaning of Liff
