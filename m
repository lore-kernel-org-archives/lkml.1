Return-Path: <linux-kernel-owner+w=401wt.eu-S1761319AbYBFJPE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761319AbYBFJPE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 04:15:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760127AbYBFJOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 04:14:47 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45390 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760102AbYBFJOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 04:14:45 -0500
Date: Wed, 6 Feb 2008 01:14:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Grzegorz Chwesewicz <ceho@chilan.com>
Cc: linux-kernel@vger.kernel.org, chilek@chilan.com
Subject: Re: [BUG] Problem with recording on hda-intel (sata_sil or
 hda-intel bug) - HP nx6325
Message-Id: <20080206011453.567922ac.akpm@linux-foundation.org>
In-Reply-To: <200802052015.23170.ceho@chilan.com>
References: <200802052015.23170.ceho@chilan.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2008 20:15:23 +0100 Grzegorz Chwesewicz <ceho@chilan.com> wrote:

> 	Hi. 
> Problem description:
> 
> I have a problem with recording on HP nx6325 notebook (hda-intel with AD1981HD 
> codec). Playback works fine, but after 5-10 min. of recording microphone 
> stops working (playback works all the time). Unloading and loading sound 
> modules fixes problem, but only for another 5-10 minutes. This problem exists 
> from more than a year (at least from 2.6.17.13 kernel). In [1] we came to 
> conclusion that this problem is ralated to IRQ sharing [2] (HDA Intel is on 
> the same IRQ as sata_sil). 
> 
> How to reproduce the problem:
> 
> 1) on one console run arecord and see the output (You should see some garbage)
> 2) on another console run cat /etc/*
> 3) at once arecord on the first console gives no output
> 
> So, doing lot of hdd I/O occurs problem with mic.
> 
> What had been done:
> 
> 1) I tried to boot Fedora 8 livecd and unload sata_sil, so that hda_intel was 
> the only device using IRQ. After that microphone was working all the time (I 
> left recording for all night, and in the morning I had almost 2h voip chat 
> using Twinkle). So when sata_sil is unloaded, and hda-intel is not sharing 
> the IRQ, the mic. is working all the time. Look at [3] to 
> see /proc/interrupts output when laptop is booted from livecd, and mic works.
> 
> 2) I tried to load hda-intel with enable_msi=1 (my RS480 chip is on blacklist, 
> but I've removed it). Module loads and playback works ok, but problem with 
> mic still exists. Difference here is that when recording stops to work the 
> playback also stops to work (without MSI only mic stops to work). Look at [4] 
> to see /proc/interrupts output when module is loaded with enable_msi=1.
> 
> Question:
> 
> What information I need to provide to help resolving the problem ? Where to 
> start, because I've run out of ideas :) ?
> 
> References:
> [1] https://bugtrack.alsa-project.org/alsa-bug/view.php?id=2449

Recording the bug in the alsa bugtracker is good, and Takashi is actively
working on the bug, and he is the best guy to do that.

So I don't think anything else really needs to be done here - please work
with him on solving this?

