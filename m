Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275Ab0BBQK4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 11:10:56 -0500
Received: from denise.shiny.it ([194.20.232.1]:34234 "EHLO denise.shiny.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752826Ab0BBQKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 11:10:55 -0500
X-Greylist: delayed 529 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Feb 2010 11:10:54 EST
Date: Tue, 2 Feb 2010 17:02:07 +0100 (CET)
From: Giuliano Pochini <pochini@denise.shiny.it>
To: Clemens Ladisch <clemens@ladisch.de>
cc: Frederick V Heitkamp <heitkamp@ameritech.net>,
       Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
       alsa-devel@alsa-project.org
Subject: Re: [alsa-devel] Crash 2.6.32.x, Echo 3G, Alsa, SCSI
In-Reply-To: <4B684513.8090201@ladisch.de>
Message-ID: <Pine.LNX.4.64.1002021655170.24618@denise.shiny.it>
References: <73211.74714.qm@web180714.mail.sp1.yahoo.com> <4B684513.8090201@ladisch.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 2 Feb 2010, Clemens Ladisch wrote:

>> [ 5485.965788]  [<c10041c0>] ? do_divide_error+0x0/0x90
>> [ 5485.980619]  [<f87aa037>] ? pcm_pointer+0x37/0x70 [snd_echo3g]
>> [ 5485.998047]  [<c104764e>] ? run_timer_softirq+0x17e/0x2e0
>> [ 5486.014175]  [<f87ac9bf>] ? snd_echo_interrupt+0x11f/0x240 [snd_echo3g]
>> [ 5486.033940]  [<c107a5d5>] ? handle_IRQ_event+0x45/0x190
>
> bytes_to_frames() divides by runtime->frame_bits which is not set until
> after the hw_params callback has succeeded, but the corresponding
> chip->substream[] entry is set in that callback, by init_engine().  It
> should probably have been set in the prepare callback.

How can an irq arrive before hw_params() and prepare() ?

Frederick, are you using the midi interface ?


--
Giuliano.
