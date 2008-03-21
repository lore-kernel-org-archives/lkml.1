Return-Path: <linux-kernel-owner+w=401wt.eu-S1761101AbYCUUEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761101AbYCUUEn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 16:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754163AbYCUUEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 16:04:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47421 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047AbYCUUEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 16:04:34 -0400
Message-ID: <47E413B4.5050503@zytor.com>
Date: Fri, 21 Mar 2008 12:59:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
CC: ak@muc.de, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, gregkh@suse.de, airlied@skynet.ie,
       davej@redhat.com, mingo@elte.hu, tglx@linutronix.de,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com,
       linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com
Subject: Re: [patch 00/13] x86: PAT support updated - v3
References: <20080319000012.439150000@intel.com> <47E3B84C.6070808@zytor.com> <20080321191921.GA23347@linux-os.sc.intel.com>
In-Reply-To: <20080321191921.GA23347@linux-os.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Venki Pallipadi wrote:
> On Fri, Mar 21, 2008 at 06:29:48AM -0700, H. Peter Anvin wrote:
>> venkatesh.pallipadi@intel.com wrote:
>>> * UC_MINUS in PAT to provide backward compatibility to /dem/mem mmap users.
>> I have to say I think this looks like a good patchset.  However, I'd 
>> like a bit more clarification with regards to the above point?
>>
> 
> X seems to use (in that order)
> - mmap the range through /dev/mem
> - Set MTRR for the range to WC
> 
> I see this happening on one of my test systems with relatively new xorg.
> 
> In this case, when mmap does the reserve for this range, if we give UC mapping
> then we will effectively negate the MTRR WC setting with the range being mapped
> UC. To accomodate this special use case, we give /dev/mem mmap (only when there
> are no other already existing mappings) a UC_MINUS attribute. With that,
> if and when X sets MTRR the range will become WC and until that time it will be
> UC. We ensure that all page table mappings use UC_MINUS for that range.
> 
> Long term, we want X to switch to /proc/ of /sys interfaces. But, we can also
> provide backward compatibility for existing X usage like above.
> 

Makes total sense.  Eventually I think we want to do /proc/mtrr 
emulation, but for now, this is probably the best option.

	-hpa
