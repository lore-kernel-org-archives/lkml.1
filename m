Return-Path: <linux-kernel-owner+w=401wt.eu-S1752389AbYHISy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389AbYHISy0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 14:54:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751948AbYHISyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 14:54:15 -0400
Received: from mga01.intel.com ([192.55.52.88]:45420 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695AbYHISyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 14:54:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,334,1215414000"; 
   d="scan'208";a="369201686"
Date: Sat, 9 Aug 2008 11:54:13 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Wolfgang Walter <wolfgang.walter@stwm.de>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "viro@ZenIV.linux.org.uk" <viro@zeniv.linux.org.uk>,
       "vegard.nossum@gmail.com" <vegard.nossum@gmail.com>
Subject: Re: Kernel oops with 2.6.26, padlock and ipsec: probably problem with fpu state changes
Message-ID: <20080809185412.GI13158@linux-os.sc.intel.com>
References: <200807171653.59177.wolfgang.walter@stwm.de> <20080808231121.GA13158@linux-os.sc.intel.com> <20080809143727.GA30499@gondor.apana.org.au> <200808091757.32999.wolfgang.walter@stwm.de> <20080809181219.GF13158@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080809181219.GF13158@linux-os.sc.intel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 09, 2008 at 11:12:19AM -0700, Suresh Siddha wrote:
> In this padlock case with the patch, we may encounter a nested
> kernel_fpu_begin() and end()
> but this is ok, as the padlock is not actually touching fpu/sse registers.

I take this back. kernel_fpu_end() is unconditionally doing stts(). So,
nesting of kernel_fpu_begin/end() is not ok.
