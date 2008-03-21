Return-Path: <linux-kernel-owner+w=401wt.eu-S1759622AbYCUTXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759622AbYCUTXR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 15:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755729AbYCUTXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 15:23:04 -0400
Received: from mga11.intel.com ([192.55.52.93]:19648 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755593AbYCUTXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 15:23:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,536,1199692800"; 
   d="scan'208";a="308278912"
Date: Fri, 21 Mar 2008 12:19:22 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: venkatesh.pallipadi@intel.com, ak@muc.de, ebiederm@xmission.com,
       rdreier@cisco.com, torvalds@linux-foundation.org, gregkh@suse.de,
       airlied@skynet.ie, davej@redhat.com, mingo@elte.hu, tglx@linutronix.de,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com,
       linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com
Subject: Re: [patch 00/13] x86: PAT support updated - v3
Message-ID: <20080321191921.GA23347@linux-os.sc.intel.com>
References: <20080319000012.439150000@intel.com> <47E3B84C.6070808@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47E3B84C.6070808@zytor.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2008 at 06:29:48AM -0700, H. Peter Anvin wrote:
> venkatesh.pallipadi@intel.com wrote:
> >* UC_MINUS in PAT to provide backward compatibility to /dem/mem mmap users.
> 
> I have to say I think this looks like a good patchset.  However, I'd 
> like a bit more clarification with regards to the above point?
> 

X seems to use (in that order)
- mmap the range through /dev/mem
- Set MTRR for the range to WC

I see this happening on one of my test systems with relatively new xorg.

In this case, when mmap does the reserve for this range, if we give UC mapping
then we will effectively negate the MTRR WC setting with the range being mapped
UC. To accomodate this special use case, we give /dev/mem mmap (only when there
are no other already existing mappings) a UC_MINUS attribute. With that,
if and when X sets MTRR the range will become WC and until that time it will be
UC. We ensure that all page table mappings use UC_MINUS for that range.

Long term, we want X to switch to /proc/ of /sys interfaces. But, we can also
provide backward compatibility for existing X usage like above.

Thanks,
Venki
