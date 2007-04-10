Return-Path: <linux-kernel-owner+w=401wt.eu-S1030591AbXDJWca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030591AbXDJWca (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 18:32:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030624AbXDJWc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 18:32:29 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:13805 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030591AbXDJWc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 18:32:28 -0400
X-IronPort-AV: i="4.14,392,1170662400"; 
   d="scan'208"; a="52690504:sNHT85272534"
To: "Bryan O'Sullivan" <bos@pathscale.com>
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14 of 33] IB/ipath - fix port sharing on powerpc
X-Message-Flag: Warning: May contain useful information
References: <62da2fb770b66310ac06.1173995098@iqa-25.internal.keyresearch.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 10 Apr 2007 15:32:19 -0700
In-Reply-To: <62da2fb770b66310ac06.1173995098@iqa-25.internal.keyresearch.com> (Bryan O'Sullivan's message of "Thu, 15 Mar 2007 14:44:58 -0700")
Message-ID: <adatzvnoo7g.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 10 Apr 2007 22:32:19.0469 (UTC) FILETIME=[1979ABD0:01C77BC0]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I applied this, but I still think there's some more work to do in this
area:

 > The port sharing feature mixed kernel virtual addresses as well as
 > physical addresses for the offset used to describe the mmap address to map
 > the InfiniPath hardware into user space.  This had a conflict on powerpc.
 > The new scheme converts it to a physical address so it doesn't conflict
 > with chip addresses and yet still fits in 40/44 bits so it isn't truncated
 > by 32-bit applications calling mmap64().

there's no guarantee that a physical address fits in 40 or 44 or 63
bits on a 64 bit platform.  So you've fixed this problem on the
platforms you test for now, but it could easily crop up again...
