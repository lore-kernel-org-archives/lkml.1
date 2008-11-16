Return-Path: <linux-kernel-owner+w=401wt.eu-S1753420AbYKPKnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420AbYKPKnk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 05:43:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751802AbYKPKnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 05:43:32 -0500
Received: from mirapoint3.brutele.be ([212.68.199.148]:16804 "EHLO
	mirapoint3.brutele.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbYKPKnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 05:43:31 -0500
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Sun, 16 Nov 2008 05:43:31 EST
Message-ID: <491FF81F.6000602@tvcablenet.be>
Date: Sun, 16 Nov 2008 11:38:23 +0100
From: =?ISO-8859-1?Q?Fran=E7ois_Valenduc?= 
	<francois.valenduc@tvcablenet.be>
User-Agent: Thunderbird 2.0.0.17 (X11/20081005)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: [patch 00/22] 2.6.27.7-stable review
References: <20081115052220.GA3710@kroah.com>
In-Reply-To: <20081115052220.GA3710@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Junkmail-Status: score=10/50, host=mirapoint3.brutele.be
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A0B0202.491FF820.01B6,ss=1,fgs=0,
	ip=192.168.1.2,
	so=2008-05-01 23:44:25,
	dmn=5.7.1/2008-09-02
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH a écrit :
> This is the start of the stable review cycle for the 2.6.27.7 release.
> There are 22 patches in this series, all will be posted as a response to
> this one.  If anyone has any issues with these being applied, please let
> us know.  If anyone is a maintainer of the proper subsystem, and wants
> to add a Signed-off-by: line to the patch, please respond with it.
> 
> These patches are sent out with a number of different people on the Cc:
> line.  If you wish to be a reviewer, please email stable@kernel.org to
> add your name to the list.  If you want to be off the reviewer list,
> also email us.
> 
> Responses should be made by Monday, Nov 17, 2008, 06:00:00 UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.27.7-rc1.gz
> and the diffstat can be found below.
> 
> 
> thanks,
> 
> greg k-h
> 
>  Makefile                                  |    2 +-
>  arch/arm/mm/cache-feroceon-l2.c           |    4 +-
>  arch/powerpc/include/asm/mpic.h           |    2 +
>  arch/powerpc/platforms/85xx/mpc85xx_ds.c  |    3 +-
>  arch/powerpc/platforms/86xx/pic.c         |    3 +-
>  arch/powerpc/sysdev/mpic.c                |   59 +++++++++++++++++++++++--
>  block/blk-merge.c                         |   19 +++++++-
>  drivers/acpi/ec.c                         |   13 ++++-
>  drivers/acpi/system.c                     |   25 +++++++---
>  drivers/char/ipmi/ipmi_msghandler.c       |   20 +++++----
>  drivers/char/ipmi/ipmi_si_intf.c          |   16 ++++---
>  drivers/hwmon/ibmaem.c                    |   18 ++++---
>  drivers/input/mouse/alps.c                |    1 +
>  drivers/misc/sony-laptop.c                |    6 ++-
>  drivers/net/Kconfig                       |    1 +
>  drivers/net/bnx2x_init.h                  |    9 ++--
>  drivers/net/bnx2x_main.c                  |    6 ++-
>  drivers/net/wireless/ath5k/base.c         |   67 +++++++++++++++--------------
>  drivers/net/wireless/ath5k/base.h         |    3 +-
>  drivers/net/wireless/ath5k/hw.c           |   22 +++------
>  drivers/net/wireless/ath5k/initvals.c     |    2 +
>  drivers/net/wireless/hostap/hostap_wlan.h |    5 ++-
>  drivers/net/wireless/iwlwifi/iwl-agn.c    |    6 ++-
>  drivers/net/wireless/rtl8187_dev.c        |    3 +
>  fs/namespace.c                            |    7 +++-
>  include/linux/bio.h                       |    7 +++
>  mm/hugetlb.c                              |    5 +-
>  mm/page_isolation.c                       |    5 +-
>  scripts/package/builddeb                  |   24 +++++++++-
>  29 files changed, 251 insertions(+), 112 deletions(-)

Is it possible to add other EC related patches recently merged in the
mainline tree. These are the following:
      ACPI: EC: revert msleep patch
      ACPI: EC: wait for last write gpe
      ACPI: EC: restart failed command
      ACPI: EC: lower interrupt storm treshold
      ACPI: EC: Don't do transaction from GPE handler in poll mode.

All these patches apply without any problem on the 2.7.26 kernel. Theses
patches solves bugs #12004, #11841 and #11994. In particular, the first
one allows my computer to power down, which was not possible when the
following commit was merged in the 2.6.27.5 kernel:

ACPI: EC: do transaction from interrupt context

commit 7c6db4e050601f359081fde418ca6dc4fc2d0011 upstream.

It is easier and faster to do transaction directly from interrupt
context rather than waking control thread.:


Thanks.

François Valenduc
