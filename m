Return-Path: <linux-kernel-owner+w=401wt.eu-S936333AbYEUUSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936333AbYEUUSV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 16:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755832AbYEUUSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 16:18:05 -0400
Received: from saeurebad.de ([85.214.36.134]:46809 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754490AbYEUUSC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 16:18:02 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Philipp Marek <philipp@marek.priv.at>
Cc: linux-kernel@vger.kernel.org, linux-trivial@kernel.org
Subject: Re: [patch] kmalloc returns (void*), don't do type conversions
References: <200805212113.51936@marek.priv.at>
Date: Wed, 21 May 2008 22:17:34 +0200
In-Reply-To: <200805212113.51936@marek.priv.at> (Philipp Marek's message of
	"Wed, 21 May 2008 21:13:51 +0200")
Message-ID: <877idn4dk1.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Phillip,

Philipp Marek <philipp@marek.priv.at> writes:

> I tried a "make allyesconfig", but that gave some compile errors 
> that don't seem related to my changes:
> 	drivers/block/cciss_scsi.c:75: error: ‘MAX_CTLR’ undeclared here (not in a function)
> 	drivers/block/cciss_scsi.c:76: error: field name not in record or union initializer

You probably should write another email regarding this.

> Please tell me if that's the correct approach; I'm sorry that I 
> couldn't find out who the correct maintainer for these changes is.

Added the trivial tree maintainer to CC.  Jesper?

> $ diffstat kmalloc-type-changes.patch
>  arch/cris/arch-v32/mm/intmem.c                |   13 +++++--------
>  arch/ia64/kernel/mca_drv.c                    |    4 ++--
>  arch/powerpc/kernel/nvram_64.c                |    3 +--
>  drivers/block/cciss.c                         |    3 +--
>  drivers/block/cciss_scsi.c                    |    3 +--
>  drivers/block/floppy.c                        |    3 +--
>  drivers/i2c/i2c-dev.c                         |    3 +--
>  drivers/isdn/capi/capidrv.c                   |    3 +--
>  drivers/isdn/hisax/hfc_sx.c                   |    5 +++--
>  drivers/media/video/vino.c                    |    8 ++++----
>  drivers/message/i2o/i2o_config.c              |    3 +--
>  drivers/mtd/maps/tqm8xxl.c                    |    2 +-
>  drivers/net/gianfar.c                         |    6 ++----
>  drivers/net/s2io.c                            |    4 ++--
>  drivers/net/tulip/eeprom.c                    |    8 ++++----
>  drivers/net/wireless/hostap/hostap_80211_rx.c |    3 +--
>  drivers/net/wireless/hostap/hostap_ioctl.c    |    3 +--
>  drivers/net/wireless/ipw2100.c                |   10 ++++------
>  drivers/net/wireless/zd1211rw/zd_chip.c       |    2 +-
>  drivers/s390/net/ctcm_mpc.c                   |    6 ++----
>  drivers/s390/net/qeth_core_main.c             |    4 ++--
>  drivers/scsi/osst.c                           |    5 ++---
>  drivers/usb/storage/isd200.c                  |    3 +--
>  fs/befs/btree.c                               |    4 ++--
>  fs/ufs/util.c                                 |    3 +--
>  net/ipv4/igmp.c                               |    3 +--
>  net/ipv6/mcast.c                              |    3 +--
>  net/sctp/protocol.c                           |    4 ++--
>  security/selinux/ss/conditional.c             |    4 ++--
>  29 files changed, 53 insertions(+), 75 deletions(-)

You can include the diffstat in the patch as comment.  And please don't
attach patches, include them inline.  See
Documentation/SubmittingPatches.

> Remove type conversions that are done on the result of kmalloc() -
> this is defined as (void*).

How about:

  Remove unneeded explicit casting from kmalloc() return values.

> Signed-off-by: philipp@marek.priv.at

Better use:  Real Name <user@domain>

Hope that helps,

	Hannes
