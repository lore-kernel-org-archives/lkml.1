Return-Path: <linux-kernel-owner+w=401wt.eu-S1755518AbZCRAtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518AbZCRAtt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 20:49:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753552AbZCRAtl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 20:49:41 -0400
Received: from fwtops.0.225.230.202.in-addr.arpa ([202.230.225.126]:31031 "EHLO
	topsms.toshiba-tops.co.jp" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752710AbZCRAtk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 20:49:40 -0400
Date: Wed, 18 Mar 2009 09:49:35 +0900 (JST)
Message-Id: <20090318.094935.238694196.nemoto@toshiba-tops.co.jp>
To: dan.j.williams@intel.com
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
       linux-kernel@vger.kernel.org, haavard.skinnemoen@atmel.com
Subject: Re: [PATCH 1/2] dmaengine: TXx9 Soc DMA Controller driver
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <e9c3a7c20903171002n50964148v8366fa2f00e3164c@mail.gmail.com>
References: <e9c3a7c20903162152w6b73b4b8hba8004e7b349c447@mail.gmail.com>
	<20090318.010939.128619068.anemo@mba.ocn.ne.jp>
	<e9c3a7c20903171002n50964148v8366fa2f00e3164c@mail.gmail.com>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 6.1 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Mar 2009 10:02:14 -0700, Dan Williams <dan.j.williams@intel.com> wrote:
> >> The sysfs device has a longer lifetime than dma_device.  See commit
> >> 41d5e59c [1].
> >
> > The sysfs device for dma_chan (dma_chan_dev) has a shorter lifetime
> > than dma_device, doesn't it?
> 
> No,  dma_async_device_unregister(), and the freeing of dma_device, may
> finish before chan_dev_release is called.  Userspace gates the final
> release of dma_chan_dev objects.

You mean, if the sysfs device file was opened when
dma_async_device_unregister() was called, the sysfs device will not be
released until the sysfs device file is closed, right?  If so I can
see.

BTW, there are another holes in dma_async_device_register.  If
idr_pre_get or idr_get_new was failed, idr_ref will not be freed.

---
Atsushi Nemoto
