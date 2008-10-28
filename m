Return-Path: <linux-kernel-owner+w=401wt.eu-S1751800AbYJ1SoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800AbYJ1SoP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 14:44:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751495AbYJ1Sn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 14:43:58 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:33999 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494AbYJ1Sn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 14:43:57 -0400
Date: Tue, 28 Oct 2008 16:44:33 -0200
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
       herton@mandriva.com.br
Subject: Re: snd-hda-intel prevents machine to power off
Message-ID: <20081028164433.2b2c6db4@doriath.conectiva>
In-Reply-To: <s5hod14br3h.wl%tiwai@suse.de>
References: <20081028135933.36778d60@doriath.conectiva>
	<s5hskqgbt4h.wl%tiwai@suse.de>
	<20081028141916.610a2847@doriath.conectiva>
	<s5hod14br3h.wl%tiwai@suse.de>
Organization: Mandriva
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.4; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, 28 Oct 2008 17:51:30 +0100
Takashi Iwai <tiwai@suse.de> escreveu:

| At Tue, 28 Oct 2008 14:19:16 -0200,
| Luiz Fernando N. Capitulino wrote:
| > 
| > Em Tue, 28 Oct 2008 17:07:42 +0100
| > Takashi Iwai <tiwai@suse.de> escreveu:
| > 
| > | >  Hi Takashi,
| > | > 
| > | >  If I have some process with the sound device opened in my eeepc
| > | > (say KDE's kmix) and try to power off the machine, for example with:
| > | > 
| > | > # echo o > /proc/sysrq-trigger
| > | > 
| > | >  The machine will not power off.
| > | 
| > | At which point does it stop?
| > | What shows alt-sysrq-t (or w) output?
| > 
| >  I'm wondering how to get that kind of output because everything
| > is disabled at that point (display inclusive).
| 
| OK, then it's hard to see.
| A good news is that it goes at least fairly end point, thus likely no
| hanging task, etc.
| 
| 
| > | >  But it does work if I remove the snd-hda-intel module before issuing
| > | > the echo above.
| > | > 
| > | >  This problem seems to be pretty popular among distros, I could find
| > | > it reported for Mandriva, Ubuntu and Fedora.
| > | 
| > | Hmm, I haven't heard of unfixed issues.
| > 
| >  Well, these are the tickets I've found:
| > 
| > https://bugzilla.redhat.com/show_bug.cgi?id=444115
| > https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.22/+bug/126140
| > https://qa.mandriva.com/show_bug.cgi?id=44752
| 
| Looking through the comments that the power-saving helps, the problem
| may disappear even without disabling the pci device.  The power-saving
| doesn't involve with pci_disable_device() or changing the power-state
| of the controler.  So, at least, the problem is either in the codec
| or the controller setup.
| 
| Suppose you already use the power-saving and it solves the shutdown
| problem, could you set power_save_controller=0 option for
| snd-hda-intel, and check whether the shutdown still works or not?
| If the shutdown doesn't work with this option, it means that
| azx_stop_chip() is what would be needed.

 Yes, power_save_controller=0 doesn't work while the power-saving
one works.

 Where should I put a call to azx_stop_ship()? I'm not an alsa
hacker. :)

| Anyway, I feel this is rather a BIOS issue, and not sure what is the
| best way to fix in the driver itself...

 I see... I'm running with the latest BIOS update, btw.

-- 
Luiz Fernando N. Capitulino
