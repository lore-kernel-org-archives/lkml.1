Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808Ab0CIHA6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 02:00:58 -0500
Received: from claw.goop.org ([74.207.240.146]:33857 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607Ab0CIHA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 02:00:56 -0500
Message-ID: <4B95F224.3060205@goop.org>
Date: Mon, 08 Mar 2010 23:00:52 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.3
MIME-Version: 1.0
To: Sheng Yang <sheng@linux.intel.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
       xen-devel <xen-devel@lists.xensource.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ian Campbell <Ian.Campbell@eu.citrix.com>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>,
       Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>, Ingo Molnar <mingo@elte.hu>,
       Konrad Rzeszutek Wilk <kliw@darnok.org>
Subject: Re: [Xen-devel] [PATCH 7/7] xen: Enable event channel of PV extension
 of HVM
References: <1268032732-8025-1-git-send-email-sheng@linux.intel.com>	<1268032732-8025-8-git-send-email-sheng@linux.intel.com>	<alpine.DEB.2.00.1003081701160.16237@kaball-desktop> <201003090953.16985.sheng@linux.intel.com>
In-Reply-To: <201003090953.16985.sheng@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2010 05:53 PM, Sheng Yang wrote:
> On Tuesday 09 March 2010 01:10:56 Stefano Stabellini wrote:
>    
>> I think that mapping interrupts into VIRQs is a bad idea: you should map
>> interrupts into pirqs instead, the code exists already on the kernel
>> side so we don't need to do any (ugly) change ther.
>>      
> The code existed in the pv_ops dom0 side, but not in the upstream Linux. The
> latter is our target. We want this work to be accepted by upstream Linux soon.

I don't think its a sound idea to rush this stuff upstream, for several 
reasons:

   1. It is currently based on 2.6.33, which means it will not get into
      any distros in the near future.  If it were based on 2.6.32 then
      it has a much greater chance of being accepted into distros. 
      (They may decide to backport the work, but it would be helpful if
      that were done in advance.)
   2. It has significant overlaps with the current xen.git development
      which is also targeted for upstream.  There's no point in creating
      an unnecessary duplicate mechanism when the infrastructure will be
      in place anyway.
   3. The code has had very little exposure within the Xen community,
      especially since the Xen-side patches have not been accepted into
      xen-unstable yet, let alone a released hypervisor.  On the kernel
      side, it would help if the patches were based on 2.6.32 (or even
      .31) so they can be merged into the xen.git kernels people are
      actually using.
   4. The kernel Xen code is already complicated with a number of
      different code paths according to architecture, options, features
      etc.  I would like to see some strong concrete evidence that these
      changes make a worthwhile improvement on a real workload before
      adding yet another thing which needs to be tested and maintained
      indefinitely.

     J
