Return-Path: <linux-kernel-owner+w=401wt.eu-S1161301AbXDKWdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161301AbXDKWdk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 18:33:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161310AbXDKWdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 18:33:40 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:41580 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161301AbXDKWdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 18:33:39 -0400
X-IronPort-AV: i="4.14,396,1170662400"; 
   d="scan'208"; a="410461883:sNHT45977782"
To: Robert Walsh <rjwalsh@pathscale.com>
Cc: "Bryan O'Sullivan" <bos@pathscale.com>, openib-general@openfabrics.org,
       linux-kernel@vger.kernel.org
Subject: Re: [ofa-general] Re: [PATCH 00 of 33] Set of ipath patches for 2.6.22
X-Message-Flag: Warning: May contain useful information
References: <patchbomb.1173995084@iqa-25.internal.keyresearch.com>
	<aday7kzooa7.fsf@cisco.com> <461D600E.4070709@pathscale.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 11 Apr 2007 15:33:30 -0700
In-Reply-To: <461D600E.4070709@pathscale.com> (Robert Walsh's message of "Wed, 11 Apr 2007 15:24:14 -0700")
Message-ID: <ada3b36lex1.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 11 Apr 2007 22:33:31.0118 (UTC) FILETIME=[6E9830E0:01C77C89]
Authentication-Results: sj-dkim-8; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim8002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > BTW: any idea how this ever got triggered?  The only way I can see is
 > if you're either not using libipathverbs and libibverbs and you just
 > create the CQ some other way, which seems unlikely.  Do you know how
 > Jason triggered this bug?

Yes, it was because he was using 32-bit userspace and so it was
impossible to libipathverbs to mmap the address the kernel driver was
looking for.  So the mmap failed and the pending mmap never got taken
off the list.

 - R.
