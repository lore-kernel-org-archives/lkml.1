Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833Ab0BBLYc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 06:24:32 -0500
Received: from sh.osrg.net ([192.16.179.4]:33306 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755666Ab0BBLYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 06:24:30 -0500
Date: Tue, 2 Feb 2010 20:23:40 +0900
To: mitov@issp.bas.bg
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org, mingo@elte.hu,
       davej@redhat.com
Subject: Re: [BUG] agpgart-amd64 not initialized in 2.6.33-rc5 if
 iommu=allowed in kernel command line
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <201001250937.53518.mitov@issp.bas.bg>
References: <201001232314.55425.mitov@issp.bas.bg>
	<20100125141006O.fujita.tomonori@lab.ntt.co.jp>
	<201001250937.53518.mitov@issp.bas.bg>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100202202328O.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 02 Feb 2010 20:23:41 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Really sorry for taking so long. I had been away from my workplace.

On Mon, 25 Jan 2010 09:37:53 +0200
Marin Mitov <mitov@issp.bas.bg> wrote:

> > Can you test this patch with set CONFIG_AGP_AMD64 to both y and m
> > (also loading/unloading the module twice)?
> 
> If CONFIG_AGP_AMD64=y it works (I have agp) both with no kernel command 
> line parameters as well as with iommu=allowed in kernel command line.

Good.


> If CONFIG_AGP_AMD64=m  it works (I have agp)  with no kernel command
> line parameters. If I boot to no graphics (runlevel 3 in slackware), 
> lsmod output is:
> 
> amd64_agp               7463  1
> agpgart                   27765  1 amd64_agp
> 
> amd64_agp is in use (not known by who), cannot be unloaded and I cannot 
> test load/unload.
> 
> If CONFIG_AGP_AMD64=m and  iommu=allowed is in kernel command line
> I have no agp.
> dmesg:
> [drm:mga_do_agp_dma_bootstrap] *ERROR* Unable to acquire AGP: -19

This works with 2.6.32, right?  The following patch works?

Sorry for inconvenience.

> If I boot to no graphics and try:
> modprobe amd64_agp
> FATAL: Error inserting amd64_agp
> (/lib/modules/2.6.33-rc5/kernel/drivers/char/agp/amd64-agp.ko): No such
> device

diff --git a/drivers/char/agp/amd64-agp.c b/drivers/char/agp/amd64-agp.c
index 34cf04e..8d67923 100644
--- a/drivers/char/agp/amd64-agp.c
+++ b/drivers/char/agp/amd64-agp.c
@@ -768,7 +768,7 @@ int __init agp_amd64_init(void)
 static int __init agp_amd64_mod_init(void)
 {
 	if (gart_iommu_aperture)
-		return agp_bridges_found ? 0 : -ENODEV;
+		return 0;
 
 	return agp_amd64_init();
 }
