Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab0BXCd0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 21:33:26 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61015 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867Ab0BXCdY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 21:33:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=UE+Knc2yLdTb7+IdmM6e8GScjDTsF6apwIeQkqU+vKunpDNLg05ANoMXarjGmLW+gh
         yi0nJA6pAxZDm/DXodkx3r90V4O1DKrDmRwqWl1MgltzhgAlHqmlXX9FweR9vd/jlvHL
         5m3JzlW8phF+4YsH/WPeGZGrkpwJOAeJtiUTs=
MIME-Version: 1.0
In-Reply-To: <cover.1266893507.git.joe@perches.com>
References: <cover.1266893507.git.joe@perches.com>
Date: Tue, 23 Feb 2010 18:33:23 -0800
X-Google-Sender-Auth: b457a366869f01bf
Message-ID: <9929d2391002231833j65008a1ev1d2297672a39a483@mail.gmail.com>
Subject: Re: [PATCH net-next 0/7] drivers/net conversions to netdev_<level>, 
	etc
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Joe Perches <joe@perches.com>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Bruce Allan <bruce.w.allan@intel.com>,
       Alex Duyck <alexander.h.duyck@intel.com>,
       PJ Waskiewicz <peter.p.waskiewicz.jr@intel.com>,
       John Ronciak <john.ronciak@intel.com>,
       Andrew Gallatin <gallatin@myri.com>, Brice Goglin <brice@myri.com>,
       linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 22, 2010 at 18:56, Joe Perches <joe@perches.com> wrote:
> Some more conversions of drivers to:
>
>    netif_<level>
>    netdev_<level>
>    pr_<level>
>
> with some other minor updates/corrections
> noticed during conversions.
>
> Joe Perches (7):
>  drivers/net/chelsio: Use pr_<level>, netif_msg_<type>
>  drivers/net/myri10ge: Use pr_<level> and netdev_<level>
>  drivers/net/ixgbe: Use pr_<level> and netif_<level>
>  drivers/net/ixgb: Use pr_<level> and netdev_<level>
>  drivers/net/e1000: Use pr_<level> and netif_<level>
>  drivers/net/e1000e: Use pr_<level> and netdev_<level>
>  drivers/net/igb: Use netdev_<level>
>
>  drivers/net/chelsio/common.h      |   24 +--
>  drivers/net/chelsio/cxgb2.c       |   18 +-
>  drivers/net/chelsio/espi.c        |    4 +-
>  drivers/net/chelsio/pm3393.c      |   16 +-
>  drivers/net/chelsio/sge.c         |   10 +-
>  drivers/net/chelsio/subr.c        |   32 ++--
>  drivers/net/chelsio/vsc7326.c     |   24 ++--
>  drivers/net/e1000/e1000.h         |   17 --
>  drivers/net/e1000/e1000_ethtool.c |   38 ++--
>  drivers/net/e1000/e1000_hw.c      |  383 ++++++++++++++++++-------------------
>  drivers/net/e1000/e1000_main.c    |  272 +++++++++++++-------------
>  drivers/net/e1000/e1000_osdep.h   |   14 +--
>  drivers/net/e1000/e1000_param.c   |  121 +++++++------
>  drivers/net/e1000e/82571.c        |   57 ++++--
>  drivers/net/e1000e/e1000.h        |   21 --
>  drivers/net/e1000e/es2lan.c       |   27 ++--
>  drivers/net/e1000e/ethtool.c      |   37 ++--
>  drivers/net/e1000e/ich8lan.c      |   90 +++++----
>  drivers/net/e1000e/lib.c          |  131 +++++++-------
>  drivers/net/e1000e/netdev.c       |   95 +++++-----
>  drivers/net/e1000e/param.c        |   20 +-
>  drivers/net/e1000e/phy.c          |  114 ++++++------
>  drivers/net/igb/e1000_82575.c     |   58 +++---
>  drivers/net/igb/e1000_hw.h        |   12 +-
>  drivers/net/igb/e1000_mac.c       |   84 ++++----
>  drivers/net/igb/e1000_nvm.c       |   22 +-
>  drivers/net/igb/e1000_phy.c       |  104 +++++-----
>  drivers/net/igb/igb.h             |    1 -
>  drivers/net/igb/igb_ethtool.c     |    6 +-
>  drivers/net/igb/igb_main.c        |   43 ++---
>  drivers/net/ixgb/ixgb.h           |    8 +-
>  drivers/net/ixgb/ixgb_ee.c        |   14 +-
>  drivers/net/ixgb/ixgb_hw.c        |  147 ++++++---------
>  drivers/net/ixgb/ixgb_hw.h        |   12 --
>  drivers/net/ixgb/ixgb_main.c      |   33 ++--
>  drivers/net/ixgb/ixgb_osdep.h     |   16 +--
>  drivers/net/ixgb/ixgb_param.c     |   31 ++--
>  drivers/net/ixgbe/ixgbe.h         |    6 -
>  drivers/net/ixgbe/ixgbe_common.h  |   15 +-
>  drivers/net/ixgbe/ixgbe_dcb_nl.c  |    5 +-
>  drivers/net/ixgbe/ixgbe_ethtool.c |   40 +++--
>  drivers/net/ixgbe/ixgbe_fcoe.c    |   25 ++--
>  drivers/net/ixgbe/ixgbe_main.c    |  110 +++++------
>  drivers/net/ixgbe/ixgbe_phy.c     |    2 +
>  drivers/net/ixgbe/ixgbe_sriov.c   |   11 +-
>  drivers/net/myri10ge/myri10ge.c   |  183 +++++++-----------
>  46 files changed, 1202 insertions(+), 1351 deletions(-)
>

I have applied patches 3-7 (the patches to Intel drivers) to my queue
of patches for review and testing.

-- 
Cheers,
Jeff
