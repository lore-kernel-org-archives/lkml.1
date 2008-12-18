Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753771AbYLRVQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771AbYLRVQZ (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 16:16:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752592AbYLRVQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 16:16:05 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:49004 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381AbYLRVQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 16:16:04 -0500
Message-ID: <494ABCF8.8050802@oracle.com>
Date: Thu, 18 Dec 2008 13:13:28 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: venkatesh.pallipadi@intel.com
CC: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
        akpm@linux-foundation.org, npiggin@suse.de, hugh@veritas.com,
        arjan@infradead.org, jbarnes@virtuousgeek.org, rdreier@cisco.com,
        jeremy@goop.org, linux-kernel@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [patch 7/7] x86 PAT: update documentation to cover pgprot and
 remap_pfn related changes - v3
References: <20081218194126.963894000@intel.com> <20081218194617.987565000@intel.com>
In-Reply-To: <20081218194617.987565000@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt704.oracle.com [141.146.40.82]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020A.494ABCFE.0008:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

venkatesh.pallipadi@intel.com wrote:

+Advanced APIs for drivers
+-------------------------
+A. Exporting pages to user with remap_pfn_range, io_remap_pfn_range,

                    to users
or                  to userspace

+vm_insert_pfn
+
+Drivers wanting to export some pages to userspace, do it by using mmap

Drop comma.

+interface and a combination of
+1) pgprot_noncached()
+2) io_remap_pfn_range() or remap_pfn_range() or vm_insert_pfn()
+
+With pat support, a new API pgprot_writecombine is being added. So, driver can

s/pat/PAT/
s/driver/drivers/ or s/driver/a driver/

+continue to use the above sequence, with either pgprot_noncached() or
+pgprot_writecombine() in step 1, followed by step 2.
+
+In addition, step 2 internally tracks the region as UC or WC in memtype
+list in order to ensure no conflicting mapping.
+
+Note that this set of APIs only work with IO (non RAM) regions. If driver

                                 works with IO (non-RAM) regions. If a driver

+wants to export RAM region, it has to do set_memory_uc() or set_memory_wc()

          export a RAM region,

+as step 0 above and also track the usage of those pages and use set_memory_wb()
+before the page is freed to free pool.


-- 
~Randy
