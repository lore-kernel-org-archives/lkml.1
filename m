Return-Path: <linux-kernel-owner+w=401wt.eu-S1760196AbXHAREN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760196AbXHAREN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 13:04:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755549AbXHARD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 13:03:58 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:33535 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756350AbXHARD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 13:03:57 -0400
Date: Wed, 1 Aug 2007 18:03:03 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
cc: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>,
       Len Brown <len.brown@intel.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org, ibm-acpi-devel@lists.sourceforge.net,
       Richard Hughes <hughsient@gmail.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: THINKPAD_ACPI_INPUT_ENABLED seems regressive
In-Reply-To: <20070801162442.GO23111@khazad-dum.debian.net>
Message-ID: <Pine.LNX.4.64.0708011754560.7866@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0708011327200.4615@blonde.wat.veritas.com>
 <20070801153602.GJ23111@khazad-dum.debian.net> <20070801160805.GB11758@mellanox.co.il>
 <20070801162442.GO23111@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAACGluYm94AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAbWpnNTlAc3JjZi51Y2FtLm9yZwBpYm0tYWNwaS1kZXZlbEBsaXN0cy5zb3VyY2Vmb3JnZS5uZXQAbGVuLmJyb3duQGludGVsLmNvbQBobWhAaG1oLmVuZy5icgBtaWNoYWwuay5rLnBpb3Ryb3dza2lAZ21haWwuY29tAGh1Z2hzaWVudEBnbWFpbC5jb20AbXN0QGRldi5tZWxsYW5veC5jby5pbAA=
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Aug 2007, Henrique de Moraes Holschuh wrote:
> On Wed, 01 Aug 2007, Michael S. Tsirkin wrote:
> > Forcing the selection at compile-time isn't such a great idea IMHO.
> > Isn't there a way to support both old and new userspace?
> 
> It only afects the *defaults* of various driver knobs that can be freely
> modified at runtime:
> 
> without THINKPAD_ACPI_INPUT_ENABLED:
> 	hotkey_enable = 0
> 	hotkey_mask unchanged from whatever is already set
> 
> 	hot keys from ibm-acpi 0.14 are mapped to KEY_UNKNOWN, and thus will
> 	generate ACPI events if hotkey_enabled is set to 1.
> 
> with THINKPAD_ACPI_INPUT_ENABLED:
> 	hotkey_enable = 1
> 	hotkey_mask = hotkey_recommended_mask
> 
> 	most hot keys are mapped to something other than KEY_UNKNOWN, and
> 	thus will not generate ACPI events but rather input layer events.
> 
> You should select whichever works better with your userspace.

That reminds me of something else odd that I noticed.

While I had CONFIG_THINKPAD_ACPI_INPUT_ENABLED=y and was trying
to get Fn+F4 to give me Suspend to RAM somehow, I did try setting
/sys/blah/blah/blah/hotkey_enable to 0.

That caused the Fn+F4 key to become active, except that it wanted
to do Hibernation to Disk instead: a window popped up to tell me
(IIRC) that my kernel command line didn't have a good resume=

Hugh
