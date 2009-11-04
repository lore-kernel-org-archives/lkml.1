Return-Path: <linux-kernel-owner+w=401wt.eu-S932306AbZKDUTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932306AbZKDUTy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 15:19:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932257AbZKDUTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 15:19:53 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:39252 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932233AbZKDUTw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 15:19:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VObi6kQ5pSdRJynCCD/vRzExC1NspSm7hPVcLgoxqcRpAjuLAdSdBb/rKKgBrzfR+m
         p9DsfnHmmAz7EIH3PeBACMIPmewfdLCKsAw0azU5fypD/mIMF/kaHTc6bBNI87RCnc+Y
         DoAaLymfAv4L8ZqeVXBfDZsQkqaeO3Uuu6c0g=
MIME-Version: 1.0
In-Reply-To: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
Date: Wed, 4 Nov 2009 21:19:57 +0100
Message-ID: <14add3d10911041219j6ab25282re4f98d14029b1f68@mail.gmail.com>
Subject: Re: [PATCH 00/41] rewritten rt2800 drivers
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 4, 2009 at 6:31 PM, Bartlomiej Zolnierkiewicz
<bzolnier@gmail.com> wrote:
>
> Hi,
>
> Here is the rt2800 rewrite in the form of patches (I've trimmed cc:
> list considerably since I'm not sure whether most people really want
> to see 40+ patches in their mailboxes).
>
>
> There were some minor changes since yesterday:
>
> - two new patches were added at the top of tree fixing Kconfig help
>  entries of rt2800[pci,usb] drivers to be more helpful and to prevent
>  wasting people's time (I think that patch #1 should go to Linus'
>  tree as soon as possible, ditto for patch #2 and net-next tree)
>
> - patch descriptions were improved for many patches
>  (suggestion from Ingo)
>
> - rt2x00_intf_is_[pci,usb]() helpers for commonly used checks were
>  added to "rt2x00: add support for different chipset interfaces" patch
>  (suggestion from Ivo)
>
> - addition of separate rt2800 MAINTAINERS entry was dropped for now
>  because it stirred needless controversies distracting people from
>  technical issues (thanks to Julian Calaby for pointing this to me),
>  the goal of change was to make sure that people won't bother busy
>  rt2x00 maintainers about rt2800 tree so it is not a big deal anyway
>
>
> The rt2800 tree has also been updated to reflect those changes
> (old branch is still available as rt2800-v1 for reference):
>
> The following changes since commit fa867e7355a1bdcd9bf7d55ebe9296f5b9c4028a:
>  Juuso Oikarinen (1):
>        wl1271: Generalize command response reading
>
> are available in the git repository at:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/bart/misc.git rt2800
>
> Bartlomiej Zolnierkiewicz (41):
>      rt2800usb: make Kconfig help entry more helpful
>      rt2800pci: make Kconfig help entry more helpful
>      rt2800usb: fix rt2800usb_rfcsr_read()
>      rt2800pci: fix crypto in TX frame
>      rt2800pci: fix comment about register access
>      rt2800pci: fix comment about IV/EIV fields
>      rt2x00: fix rt2x00usb_register_read() comment
>      rt2800usb: use rt2x00usb_register_multiwrite() to set key entries
>      rt2800usb: add rt2800_register_[read,write]() wrappers
>      rt2800pci: add rt2800_register_[read,write]() wrappers
>      rt2800usb: add rt2800_register_multi[read,write]() wrappers
>      rt2800pci: add rt2800_register_multi[read,write]() wrappers
>      rt2800usb: add rt2800_regbusy_read() wrapper
>      rt2800pci: add rt2800_regbusy_read() wrapper
>      rt2800usb: add rt2800_bbp_[read,write]() wrappers
>      rt2800pci: add rt2800_bbp_[read,write]() wrappers
>      rt2800usb: add rt2800_rfcsr_[read,write]() wrappers
>      rt2800pci: add rt2800_rfcsr_[read,write]() wrappers
>      rt2800usb: add rt2800_rf_[read,write]() wrappers
>      rt2800pci: add rt2800_rf_[read,write]() wrappers
>      rt2800usb: add rt2800_mcu_request() wrapper
>      rt2800pci: add rt2800_mcu_request() wrapper
>      rt2x00: add driver private field to struct rt2x00_dev
>      rt2800usb: convert to use struct rt2800_ops methods
>      rt2800pci: convert to use struct rt2800_ops methods
>      rt2x00: fix rt2x00usb_register_multiwrite() arguments
>      rt2x00: fix rt2x00usb_regbusy_read() arguments
>      rt2x00: fix rt2x00pci_register_multi[read,write]() arguments
>      rt2800: add rt2800lib.h
>      rt2800usb: fix comments in rt2800usb.h
>      rt2800usb: add RXINFO_DESC_SIZE definition
>      rt2800: fix duplication in header files
>      rt2800: fix comments in rt2800.h
>      rt2x00: add support for different chipset interfaces
>      rt2800: prepare for rt2800lib addition
>      rt2800: add rt2800lib (part one)
>      rt2x00: remove needless ifdefs from rt2x00leds.h
>      rt2800: add rt2800lib (part two)
>      rt2x00: move REGISTER_BUSY_* definitions to rt2x00.h
>      rt2800: add rt2800lib (part three)
>      rt2800: add rt2800lib (part four)
>
>  drivers/net/wireless/rt2x00/Kconfig      |   16 +-
>  drivers/net/wireless/rt2x00/Makefile     |    1 +
>  drivers/net/wireless/rt2x00/rt2800.h     | 1816 ++++++++++++++++++++++++++++
>  drivers/net/wireless/rt2x00/rt2800lib.c  | 1817 ++++++++++++++++++++++++++++
>  drivers/net/wireless/rt2x00/rt2800lib.h  |  134 +++
>  drivers/net/wireless/rt2x00/rt2800pci.c  | 1908 +++---------------------------
>  drivers/net/wireless/rt2x00/rt2800pci.h  | 1780 ----------------------------
>  drivers/net/wireless/rt2x00/rt2800usb.c  | 1828 ++---------------------------
>  drivers/net/wireless/rt2x00/rt2800usb.h  | 1818 +----------------------------
>  drivers/net/wireless/rt2x00/rt2x00.h     |   43 +
>  drivers/net/wireless/rt2x00/rt2x00leds.h |    4 -
>  drivers/net/wireless/rt2x00/rt2x00pci.h  |   24 +-
>  drivers/net/wireless/rt2x00/rt2x00usb.c  |    2 +-
>  drivers/net/wireless/rt2x00/rt2x00usb.h  |   17 +-
>  14 files changed, 4048 insertions(+), 7160 deletions(-)
>  create mode 100644 drivers/net/wireless/rt2x00/rt2800.h
>  create mode 100644 drivers/net/wireless/rt2x00/rt2800lib.c
>  create mode 100644 drivers/net/wireless/rt2x00/rt2800lib.h
>

Hi Bart,

Many thanks for these patches.

So far I have been able to go through the first 30 patches of the
series. I'll finish the other 11 tomorrow (when I'm back home and have
better facilities to review these more elaborate patches of the
series).
They all look fine to me, I only had a comment for patch 10.

I've sent my ACKs for the remaining 29 I reviewed.

I guess Ivo still has to review them as well, as, so far, he has been
the one of the rt2x00 project to give the final ACK for inclusion,
unless he indicates that he is fine with my assessments.

---
Gertjan
rt2x00 developer
