Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622Ab0CKHpQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 02:45:16 -0500
Received: from mga10.intel.com ([192.55.52.92]:52175 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753320Ab0CKHpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 02:45:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,619,1262592000"; 
   d="scan'208";a="779850012"
From: Sheng Yang <sheng@linux.intel.com>
Organization: Intel Opensource Technology Center
To: Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH] x86/kvm: Show guest system/user cputime in cpustat
Date: Thu, 11 Mar 2010 15:46:43 +0800
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>
References: <1268292022-31352-1-git-send-email-sheng@linux.intel.com> <4B989D61.70906@redhat.com>
In-Reply-To: <4B989D61.70906@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003111546.44059.sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 March 2010 15:36:01 Avi Kivity wrote:
> On 03/11/2010 09:20 AM, Sheng Yang wrote:
> > Currently we can only get the cpu_stat of whole guest as one. This patch
> > enhanced cpu_stat with more detail, has guest_system and guest_user cpu
> > time statistics with a little overhead.
> >
> > Signed-off-by: Sheng Yang<sheng@linux.intel.com>
> > ---
> >
> > This draft patch based on KVM upstream to show the idea. I would split it
> > into more kernel friendly version later.
> >
> > The overhead is, the cost of get_cpl() after each exit from guest.
> 
> This can be very expensive in the nested virtualization case, so I
> wouldn't like this to be in normal paths.  I think detailed profiling
> like that can be left to 'perf kvm', which only has overhead if enabled
> at runtime.

Yes, that's my concern too(though nested vmcs/vmcb read already too expensive, 
they should be optimized...). The other concern is, perf alike mechanism would 
bring a lot more overhead compared to this. 

> For example you can put the code to note the cpl in a tracepoint which
> is enabled dynamically.

Yanmin have already implement "perf kvm" to support this. We are just arguing 
if a normal top-alike mechanism is necessary.

I am also considering to make it a feature that can be disabled. But seems it 
make things complicate and result in uncertain cpustat output.

-- 
regards
Yang, Sheng
