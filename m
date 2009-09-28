Return-Path: <linux-kernel-owner+w=401wt.eu-S1752780AbZI1Suk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780AbZI1Suk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 14:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752398AbZI1Suk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 14:50:40 -0400
Received: from mga05.intel.com ([192.55.52.89]:21185 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752286AbZI1Suj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 14:50:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,467,1249282800"; 
   d="scan'208";a="730938244"
Message-ID: <4AC10588.90808@linux.intel.com>
Date: Mon, 28 Sep 2009 20:50:48 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
CC: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/5] mce-inject: make injected mce valid only during faked
 handler call
References: <1254100882.15717.1312.camel@yhuang-dev.sh.intel.com> <4AC05BBF.3010102@jp.fujitsu.com> <4AC05D48.1000007@jp.fujitsu.com>
In-Reply-To: <4AC05D48.1000007@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hidetoshi Seto wrote:

> This has an undesired side-effect: it is possible for it to be
> consumed by real machine_check_poll. This may confuse a real system
> error and may confuse the mce test suite.

You can just disable the poll handler in the test suite. That's
what we did.

> To fix this, this patch changes mce_rdmsrl/wemsrl() to refer injected
> data only when injectm.valid states 3rd state "2", which indicates that
> the injected MCE entry is valid and ready for the handler.
> 
> The injectm.valid becomes "2" only during faked MCE handler call
> and protected by IRQ disabling. This make it impossible for real
> machine_check_poll to consume it.

Using magic numbers for this seems very hackish.

-Andi
