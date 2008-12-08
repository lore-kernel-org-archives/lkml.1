Return-Path: <linux-kernel-owner+w=401wt.eu-S1752596AbYLHHf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596AbYLHHf3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 02:35:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752667AbYLHHew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 02:34:52 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36286 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752601AbYLHHev (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 02:34:51 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Holger Hoffstaette" <holger@wizards.de>
Subject: Re: Nasty regression from .27.7 to .27.8: idle samba goes crazy
Date: Mon, 8 Dec 2008 08:34:22 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>, stable@kernel.org
References: <pan.2008.12.08.06.18.57.357875@wizards.de>
In-Reply-To: <pan.2008.12.08.06.18.57.357875@wizards.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812080834.22924.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 8 of December 2008, Holger Hoffstaette wrote:
> 
> Hi,
> 
> I just encountered a nasty symptom for the second time that has started to
> occur after updating my home server from vanilla 2.6.27.7 to .8 (same
> config).
> 
> A while after disconnecting a samba client, the smbd samba server
> process goes crazy and consumes 100% CPU. From that time on it is
> unkillable (kill -9 returns but the process continues to run). The only
> recourse is reboot, which works without problem (i.e. unmounting the
> served filesystems is apparently possible?). I tried to attach to the
> process with gdb but that just hung.
> 
> The system is a generic old single-core P4 box with a single SATA drive,
> Gentoo userland and Samba is 3.0.33 (in async mode). The kernel has no
> patches or binary drivers. It has been rock solid before the update and
> shows no other signs of weirdness in logs or otherwise. I downgraded to .7
> for now and will see what happens, but since it worked before I am certain
> that this is a regression in the .8 release.
> 
> The only commonality is a log entry by samba that seems to correlate with
> both occurrences:
> 
> [2008/12/08 01:02:52, 0] lib/util_sock.c:read_data(534)
>   read_data: read failure for 4 bytes to client 192.168.100.128. Error = No route to host
> 
> .128 is the Windows client machine (connected via a stable GigE link),
> which I shut down pretty much exactly 30 minutes before that (any 30
> minute timeouts in the kernel/network stack?). Both instances of these log
> entries correlate with the CPU spikes which I noticed in my MRTG graphs.
> 
> Any suspects or ideas?

Please bisect.

Thanks,
Rafael
