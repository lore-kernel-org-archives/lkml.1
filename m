Return-Path: <linux-kernel-owner+w=401wt.eu-S932346AbZHCXVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932346AbZHCXVj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 19:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932295AbZHCXVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 19:21:38 -0400
Received: from cantor.suse.de ([195.135.220.2]:34627 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932243AbZHCXVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 19:21:36 -0400
From: Thomas Renninger <trenn@suse.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: cpufreq tree build failure
Date: Tue, 4 Aug 2009 01:22:14 +0200
User-Agent: KMail/1.9.10
Cc: Dave Jones <davej@redhat.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20090803122819.6b738cad.sfr@canb.auug.org.au>
In-Reply-To: <20090803122819.6b738cad.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908040122.15733.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 August 2009 04:28:19 am Stephen Rothwell wrote:
> Hi Dave,
>
> Today's linux-next build (x86_64 allmodconfig) failed like this:
>
> ERROR: "cpufreq_global_kobject" [drivers/cpufreq/cpufreq_ondemand.ko]
> undefined!
>
> Caused by commit 35b104d88338e5eddb36c670fea4752f6c10c82f ("[CPUFREQ]
> ondemand - Use global sysfs dir for tuning settings").  Presumably
> cpufreq_global_kobject needs an EXPORT_SYMBOL.

Yep, that's it. Below is a fix.

Thanks a lot,

     Thomas

---------
CPUFREQ: fix build if ondemand is compiled as module

struct kobject *cpufreq_global_kobject must be exported

CC: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Dave Jones <davej@redhat.com>
Signed-off-by: Thomas Renninger <trenn@suse.de>

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 9bb2c4a..9d9251f 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -778,6 +778,7 @@ define_one_global_ro(scaling_driver);
 define_one_global_rw(scaling_governor);
 
 struct kobject *cpufreq_global_kobject;
+EXPORT_SYMBOL(cpufreq_global_kobject);
 
 #define to_policy(k) container_of(k, struct cpufreq_policy, kobj)
 #define to_attr(a) container_of(a, struct freq_attr, attr)
