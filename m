Return-Path: <linux-kernel-owner+w=401wt.eu-S1753449AbZGRS0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbZGRS0r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 14:26:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752800AbZGRS0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 14:26:47 -0400
Received: from mail.atlantis.sk ([80.94.52.35]:51907 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751526AbZGRS0q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 14:26:46 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Sat, 18 Jul 2009 14:26:45 EDT
From: Ondrej Zary <linux@rainbow-software.org>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: Re: "floppy: fix hibernation" causes error on resume from ram
Date: Sat, 18 Jul 2009 20:19:54 +0200
User-Agent: KMail/1.9.10
Cc: Ingo Molnar <mingo@elte.hu>, Pavel Machek <pavel@ucw.cz>,
       Jens Axboe <jens.axboe@oracle.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <4A620F3E.8080900@tuffmail.co.uk>
In-Reply-To: <4A620F3E.8080900@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907182019.57909.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 18 July 2009 20:06:54 Alan Jenkins wrote:
> Thanks for the hibernation fix!  Until recently I thought my floppy was
> just dead.  Unfortunately, the fix seems to cause me errors on resume
> from suspend to ram.  The floppy works fine afterwards, it just spams
> the log.
>
> On 2.6.30 there were no errors, and the floppy survived suspend-to-ram.
> So I guess the quick fix would be to only do the fix-up on resume from
> hibernation, and not suspend-to-ram.

My machine has no suspend-to-RAM so I haven't tested it.

That would be probably the correct fix. But how to do it? AFAIK, there's only 
one suspend() and one resume() for everything. And that looks very wrong as 
resume-from-hibernation is fundamentally different from resume-from-RAM.

>
> Thanks
> Alan
>
> Jul 18 15:27:23 alan-desktop kernel: [34795.256645]
> Jul 18 15:27:23 alan-desktop kernel: [34795.256647] floppy driver state
> Jul 18 15:27:23 alan-desktop kernel: [34795.256649] -------------------
> Jul 18 15:27:23 alan-desktop kernel: [34795.256652] now=4305315874 last
> interrupt=4303125175 diff=2190699 last called handler=ffffffffa00a64d0
> Jul 18 15:27:23 alan-desktop kernel: [34795.256655] timeout_message=lock
> fdc Jul 18 15:27:23 alan-desktop kernel: [34795.256657] last output bytes:
> Jul 18 15:27:23 alan-desktop kernel: [34795.256659]  8 80 4295201276 Jul 18
> 15:27:23 alan-desktop kernel: [34795.256662]  8 80 4295201276 Jul 18
> 15:27:23 alan-desktop kernel: [34795.256664]  8 80 4295201276 Jul 18
> 15:27:23 alan-desktop kernel: [34795.256666]  8 80 4295201276 Jul 18
> 15:27:23 alan-desktop kernel: [34795.256668]  8 80 4297332499 Jul 18
> 15:27:23 alan-desktop kernel: [34795.256669]  8 80 4297332499 Jul 18
> 15:27:23 alan-desktop kernel: [34795.256671]  8 80 4297332499 Jul 18
> 15:27:23 alan-desktop kernel: [34795.256673]  8 80 4297332499 Jul 18
> 15:27:23 alan-desktop kernel: [34795.256675]  8 80 4298652310 Jul 18
> 15:27:23 alan-desktop kernel: [34795.256677]  8 80 4298652310 Jul 18
> 15:27:23 alan-desktop kernel: [34795.256679]  8 80 4298652310 Jul 18
> 15:27:23 alan-desktop kernel: [34795.256681]  8 80 4298652310 Jul 18
> 15:27:23 alan-desktop kernel: [34795.256683]  8 80 4299614961 Jul 18
> 15:27:23 alan-desktop kernel: [34795.256685]  8 80 4299614961 Jul 18
> 15:27:23 alan-desktop kernel: [34795.256687]  8 80 4299614961 Jul 18
> 15:27:23 alan-desktop kernel: [34795.256689]  8 80 4299614961 Jul 18
> 15:27:23 alan-desktop kernel: [34795.256691]  8 80 4303125175 Jul 18
> 15:27:23 alan-desktop kernel: [34795.256693]  8 80 4303125175 Jul 18
> 15:27:23 alan-desktop kernel: [34795.256695]  8 80 4303125175 Jul 18
> 15:27:23 alan-desktop kernel: [34795.256697]  8 80 4303125175 Jul 18
> 15:27:23 alan-desktop kernel: [34795.256699] last result at 4303125175
> Jul 18 15:27:23 alan-desktop kernel: [34795.256701] last redo_fd_request
> at 4303125175
> Jul 18 15:27:23 alan-desktop kernel: [34795.256703]
> Jul 18 15:27:23 alan-desktop kernel: [34795.256709] status=0
> Jul 18 15:27:23 alan-desktop kernel: [34795.256711] fdc_busy=1
> Jul 18 15:27:23 alan-desktop kernel: [34795.256713]
> do_floppy=ffffffffa00a64d0
> Jul 18 15:27:23 alan-desktop kernel: [34795.256715] cont=ffffffffa00ad8c0
> Jul 18 15:27:23 alan-desktop kernel: [34795.256717] current_req=(null)
> Jul 18 15:27:23 alan-desktop kernel: [34795.256719] command_status=-1
> Jul 18 15:27:23 alan-desktop kernel: [34795.256720]
> Jul 18 15:27:23 alan-desktop kernel: [34795.256829] floppy0: floppy
> timeout called
> Jul 18 15:27:23 alan-desktop kernel: [34795.259455] Restarting tasks ...
> done.



-- 
Ondrej Zary
