Return-Path: <linux-kernel-owner+w=401wt.eu-S1761856AbZJNWGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761856AbZJNWGf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 18:06:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761048AbZJNWGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 18:06:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:11910 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757834AbZJNWGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 18:06:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,561,1249282800"; 
   d="scan'208";a="503255892"
Message-Id: <20091014214654.423040927@sbs-t61.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Wed, 14 Oct 2009 14:46:54 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, arjan@linux.jf.intel.com
Cc: linux-kernel@vger.kernel.org, chinang.ma@intel.com
Subject: [patch 0/2] x86_64: preserve large page text mappings with CONFIG_DEBUG_RODATA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of the distributions enable CONFIG_DEBUG_RODATA by default, with the
assumption that the debug protection checks come with no cost. Our OLTP tests
showed 1% improvement (with 2% reduction in system time and 1% increase in
iowait idle time) by disabling CONFIG_DEBUG_RODATA on a two socket
NHM-EP system.

CONFIG_DEBUG_RODATA breaks some of the kernel text/data large page
mappings to small pages, thus causing this regression. These two
patches address this issue.

Experiments with EL5 kernel and mainline show that the first patch in the series
(preserve large page mapping for 1st 2MB kernel txt with CONFIG_DEBUG_RODATA)
should recover most of the above mentioned regression. We are doing
couple of more OLTP tests for the confirmation.

thanks,
suresh

