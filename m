Return-Path: <linux-kernel-owner+w=401wt.eu-S1762869AbXHAJdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762869AbXHAJdz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 05:33:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758831AbXHAJdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 05:33:45 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:56494
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755451AbXHAJdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 05:33:44 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH FINAL] Merge the Sonics Silicon Backplane subsystem
Date: Wed, 1 Aug 2007 11:33:36 +0200
User-Agent: KMail/1.9.6
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       bcm43xx-dev@lists.berlios.de, netdev@vger.kernel.org,
       linux-wireless@vger.kernel.org, Gary Zambrano <zambrano@broadcom.com>,
       John Linville <linville@tuxdriver.com>
References: <200707291324.58691.mb@bu3sch.de> <20070731202648.e1a8c45f.akpm@linux-foundation.org>
In-Reply-To: <20070731202648.e1a8c45f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708011133.37214.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 August 2007, Andrew Morton wrote:
> On Sun, 29 Jul 2007 13:24:54 +0200 Michael Buesch <mb@bu3sch.de> wrote:
> 
> > The Sonics Silicon Backplane is a mini-bus used on
> > various Broadcom chips and embedded devices.
> 
> Sigh.
> 
> s390:
> 
> drivers/ssb/main.c: In function 'ssb_ssb_read16':
> drivers/ssb/main.c:489: error: implicit declaration of function 'readw'
> drivers/ssb/main.c: In function 'ssb_ssb_read32':
> drivers/ssb/main.c:497: error: implicit declaration of function 'readl'
> drivers/ssb/main.c: In function 'ssb_ssb_write16':
> drivers/ssb/main.c:505: error: implicit declaration of function 'writew'
> drivers/ssb/main.c: In function 'ssb_ssb_write32':
> drivers/ssb/main.c:513: error: implicit declaration of function 'writel'        
> 
> we shouldn't be compiling SSB on s390, because:
> 
> config SSB
>         tristate "Sonics Silicon Backplane support"
>         depends on EXPERIMENTAL && HAS_IOMEM
> 
> and
> 
> akpm2:/usr/src/25> grep IOMEM .config 
> CONFIG_NO_IOMEM=y
> akpm2:/usr/src/25> 
> 
> but
> 
> akpm2:/usr/src/25> grep SSB .config 
> CONFIG_DCSSBLK=m
> CONFIG_SSB=m
> CONFIG_SSB_SILENT=y
> 
> well, how did that come about?
> 
> It _has_ to be `select'.  It's _always_ `select'.
> 
> yup, it's `select':
> 
> Selected by: B44 && NETDEVICES && NET_ETHERNET || BCM43XX_MAC80211 && NETDEVICES && !S390 && MAC80211 && WLAN_80211 && EXPERIMENTAL
> 
> 
> Look.  Kconfig's `select' Just.  Does.  Not.  Work.  If you find yourself
> contemplating using it, please, don sackcloth, take a cold shower and
> several analgesics, then have another go, OK?
> 
> ho hum.

Ah, yeah. Crap select not caring about dependencies...
The problem is that people will kill me, if they don't find
bcm43xx in the kconfig anymore, as they have to enable ssb
before that. Ya know the flame with Uwe Bugla going crazy
about that? :D
Same goes for b44. It was always there in kconfig without
additional deps, but now (when we merge the b44 port) we would
need ssb selected before we see b44.
Maybe default SSB to M?
