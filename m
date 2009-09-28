Return-Path: <linux-kernel-owner+w=401wt.eu-S1752608AbZI1H1D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbZI1H1D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 03:27:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752046AbZI1H1C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 03:27:02 -0400
Received: from mga11.intel.com ([192.55.52.93]:9612 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751302AbZI1H1B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 03:27:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,464,1249282800"; 
   d="scan'208";a="730763886"
Subject: Re: [PATCH 3/5] mce-inject: make injected mce valid only during
 faked handler call
From: Huang Ying <ying.huang@intel.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4AC05D48.1000007@jp.fujitsu.com>
References: <1254100882.15717.1312.camel@yhuang-dev.sh.intel.com>
	 <4AC05BBF.3010102@jp.fujitsu.com>  <4AC05D48.1000007@jp.fujitsu.com>
Content-Type: text/plain
Date: Mon, 28 Sep 2009 15:27:03 +0800
Message-Id: <1254122823.15717.1389.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-28 at 14:52 +0800, Hidetoshi Seto wrote: 
> In the current implementation, injected MCE is valid from the point
> the MCE is injected to the point the MCE is processed by the faked
> handler call.
> 
> This has an undesired side-effect: it is possible for it to be
> consumed by real machine_check_poll. This may confuse a real system
> error and may confuse the mce test suite.
> 
> To fix this, this patch changes mce_rdmsrl/wemsrl() to refer injected
> data only when injectm.valid states 3rd state "2", which indicates that
> the injected MCE entry is valid and ready for the handler.
> 
> The injectm.valid becomes "2" only during faked MCE handler call
> and protected by IRQ disabling. This make it impossible for real
> machine_check_poll to consume it.

Anyway, I don't think it is a good idea to use a magic number like "2"
here. A meaningful name is better.

And I think my original method is clearer. Because injection related
flags go inject_flags, not be mixed with normal path flag "finished".

Best Regards,
Huang Ying

