Return-Path: <linux-kernel-owner+w=401wt.eu-S965215AbZLPXEO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965215AbZLPXEO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 18:04:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935317AbZLPXEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 18:04:10 -0500
Received: from sj-iport-5.cisco.com ([171.68.10.87]:8590 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763203AbZLPXEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 18:04:08 -0500
Authentication-Results: sj-iport-5.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAKb2KEurRN+K/2dsb2JhbAC+QpcMhCsE
X-IronPort-AV: E=Sophos;i="4.47,409,1257120000"; 
   d="scan'208";a="120938321"
From: Roland Dreier <rdreier@cisco.com>
To: Simon Horman <horms@verge.net.au>
Cc: linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
       kexec@lists.infradead.org
Subject: Re: kexec reboot broken with ioatdma?
References: <ada3a3a8v1g.fsf@roland-alpha.cisco.com>
	<20091216224912.GC16219@verge.net.au>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 16 Dec 2009 15:04:03 -0800
In-Reply-To: <20091216224912.GC16219@verge.net.au> (Simon Horman's message of
	"Thu, 17 Dec 2009 09:49:12 +1100")
Message-ID: <aday6l27c7w.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 16 Dec 2009 23:04:03.0797 (UTC) FILETIME=[0FC7D050:01CA7EA4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > from a kexec point of view I believe that the preferred option is the
 > former - shutdown the device so it can be initialised using standard paths
 > in the second kernel.

OK... however I'm not suggesting a separate kexec initialization path,
simply adding a reset of the device in the standard initialization.
This would be fairly normal for other types of device; for example, the
BIOS may have left a NIC in an undefined state due to network boot.  Of
course BIOS is unlikely to use an IOAT DMA engine but the principle of
limiting assumptions about platform state still stands I think.

>From a quick look, it seems tricky to get a clean shutdown of IOAT stuff
since there doesn't seem to be a clean ordering that makes sure the
ioatdma stuff is shutdown after everything using it.

 - R.


