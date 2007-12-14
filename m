Return-Path: <linux-kernel-owner+w=401wt.eu-S935552AbXLNAyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935552AbXLNAyo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 19:54:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934096AbXLNAyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 19:54:14 -0500
Received: from mga01.intel.com ([192.55.52.88]:63139 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933482AbXLNAyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 19:54:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,164,1196668800"; 
   d="scan'208";a="437742801"
From: Jesse Barnes <jesse.barnes@intel.com>
To: venkatesh.pallipadi@intel.com
Subject: Re: [RFC PATCH 08/12] PAT 64b: coherent mmap and sysfs bin ioctl
Date: Thu, 13 Dec 2007 16:54:08 -0800
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: ak@muc.de, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, gregkh@suse.de, airlied@skynet.ie,
       davej@redhat.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org,
       linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
References: <20071213235543.568682000@intel.com> <20071213235712.813201000@intel.com>
In-Reply-To: <20071213235712.813201000@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712131654.08669.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 13, 2007 3:55 pm venkatesh.pallipadi@intel.com wrote:
> Forward port of coherent-mmap.patch and sysfs-bin-ioctl.patch to x86 tree.
>
> TBD: Do we need the ioctl interface to sysfs or get the type attribute
> through a different sysfs file. And then actually specify the attribute
> while doing pci_mmap_page_range ;-)
>
> And when this interface is in place, X server has to use this interface for
> WC mapping.

I remember talking with people about using madvise and/or mmap flags to set 
the attributes correctly, but I don't remember whether it was a good idea or 
not...

The advantage of a specific post-mmap call is that it would make setting the 
attribute types a little easier, so either ioctl or madvise seems preferable 
to mmapping over and over with different flags until you get the mapping.

Jesse
