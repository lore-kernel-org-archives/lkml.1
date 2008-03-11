Return-Path: <linux-kernel-owner+w=401wt.eu-S1757090AbYCKGqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757090AbYCKGqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 02:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754036AbYCKGqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 02:46:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:8155 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753947AbYCKGqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 02:46:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,478,1199692800"; 
   d="scan'208";a="261846203"
Subject: Re: [PATCH -mm crypto] AES: remove crypto_fl_tab and replace
	crypto_il_tab with isb_tab
From: "Huang, Ying" <ying.huang@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "Adam J. Richter" <adam@yggdrasil.com>, Alexander Kjeldaas <astor@fast.no>,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
In-Reply-To: <1205210576.3676.7.camel@caritas-dev.intel.com>
References: <1205210576.3676.7.camel@caritas-dev.intel.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 11 Mar 2008 14:47:21 +0800
Message-Id: <1205218041.8393.11.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
X-OriginalArrivalTime: 11 Mar 2008 06:45:52.0298 (UTC) FILETIME=[8C7B08A0:01C88343]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-03-11 at 12:42 +0800, Huang, Ying wrote:
> Remove crypto_fl_tab from aes implementation. Because mix_col(1,n) = n,
> all information in cryto_fl_tab is in crypto_ft_tab too.
> crypto_il_tab is replaced by isb_tab, the byte shift is done
> during decryption.
> 
> These changes reduce the encryption cache footprint to 50% and
> decryption cache footprint to 53.1%. The code size is increased
> slightly. On my Intel CORE micro-architecture CPU, there is almost no
> performance penalty.

Similar optimization is used by OpenSSL too. So I think this is
reasonable.

Best Regards,
Huang Ying


