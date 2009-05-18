Return-Path: <linux-kernel-owner+w=401wt.eu-S1755416AbZERPG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416AbZERPG5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 11:06:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752655AbZERPGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 11:06:49 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:53870 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751090AbZERPGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 11:06:48 -0400
Date: Mon, 18 May 2009 11:06:49 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       <linux-usb@vger.kernel.org>
Subject: Re: Oops in usb-serial with keyspan adapter on current upstream
In-Reply-To: <1242605255.18075.13.camel@pasglop>
Message-ID: <Pine.LNX.4.44L0.0905181104070.2981-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 May 2009, Benjamin Herrenschmidt wrote:

> Hi folks !
> 
> Current kernels give the oops below at boot with my Keyspan plugged,
> used to work fine on 2.6.28 at least.

Does your test kernel include commit 
2d93148ab6988cad872e65d694c95e8944e1b626?

> It looks to me like some kind of race between the disconnection after
> the FW load and the re-connect but I'm not sure.

I don't think that's quite right.  Your trace shows the oops occurred 
during the disconnect processing, which means the re-connect had not 
yet started.

> Cheers,
> Ben.
> 
> usbcore: registered new interface driver usbserial
> USB Serial support registered for generic
> usbcore: registered new interface driver usbserial_generic
> usbserial: USB Serial Driver core
> USB Serial support registered for Keyspan - (without firmware)
> USB Serial support registered for Keyspan 1 port adapter
> USB Serial support registered for Keyspan 2 port adapter
> USB Serial support registered for Keyspan 4 port adapter
> keyspan 2-1:1.0: Keyspan - (without firmware) converter detected
> usb 2-1: firmware: using built-in firmware keyspan/usa49w.fw
> usb 2-1: USB disconnect, address 2
> usbcore: registered new interface driver keyspan
> keyspan: v1.1.5:Keyspan USB to Serial Converter Driver
> Unable to handle kernel paging request for data at address 0x00000010
> Faulting instruction address: 0xc0000000002da15c
> Oops: Kernel access of bad area, sig: 11 [#1]
> SMP NR_CPUS=4 PowerMac
> Modules linked in: snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device snd keyspan uninorth_agp usbserial agpgart soundcore
> NIP: c0000000002da15c LR: c0000000002d3760 CTR: c0000000002d35ec
> REGS: c00000017a4cb4c0 TRAP: 0300   Not tainted  (2.6.30-rc6-00037-g8646010-dirty)
> MSR: 9000000000009032 <EE,ME,IR,DR>  CR: 24000024  XER: 200fffff
> DAR: 0000000000000010, DSISR: 0000000040000000
> TASK = c00000017a4890e0[191] 'khubd' THREAD: c00000017a4c8000 CPU: 2
> GPR00: c000000000755f30 c00000017a4cb740 c000000000783d48 0000000000000001 
> GPR04: 0000000000000000 c0000001783fba90 0000000000000001 0000000000000000 
> GPR08: 0000000000000000 0000000000000000 0000000000000000 c0000000002d35ec 
> GPR12: 0000000024000082 c0000000007b5680 0000000000000002 c0000001781c0a30 
> GPR16: 00000000000003e8 0000000000000000 c0000001781fd000 c0000001781c0a30 
> GPR20: 0000000000000000 0000000000000000 c0000001781fd800 0000000000000001 
> GPR24: c00000017a41a600 c0000001789ab480 c0000001783fb998 0000000000000000 
> GPR28: 0000000000000000 c00000017a4cb7b0 c00000000070f8d0 0000000000000000 
> NIP [c0000000002da15c] .release_nodes+0x54/0x254
> LR [c0000000002d3760] .device_del+0x174/0x1e8
> Call Trace:
> [c00000017a4cb740] [c00000017a4cb880] 0xc00000017a4cb880 (unreliable)
> [c00000017a4cb7f0] [c0000000002d3760] .device_del+0x174/0x1e8

Is it possible to pin this down to a single bad data access or 
instruction?

Alan Stern

