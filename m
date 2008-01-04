Return-Path: <linux-kernel-owner+w=401wt.eu-S1755212AbYADWNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212AbYADWNZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 17:13:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753308AbYADWNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 17:13:15 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:8358 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029AbYADWNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 17:13:14 -0500
X-IronPort-AV: E=Sophos;i="4.24,247,1196668800"; 
   d="scan'208";a="30613832"
To: Miguel =?iso-8859-1?Q?Bot=C3=B3n?= <mboton.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       yi.zhu@intel.com, linville@tuxdriver.com
Subject: Re: [PATCH] iwlwifi: fix compilation warning in 'iwl-4965.c'
X-Message-Flag: Warning: May contain useful information
References: <200801042305.55188.mboton@gmail.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 04 Jan 2008 14:13:12 -0800
In-Reply-To: <200801042305.55188.mboton@gmail.com> (Miguel
 =?iso-8859-1?Q?Bot=C3=B3n's?= message of "Fri, 4 Jan 2008 23:05:54 +0100")
Message-ID: <adaabnlme87.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 04 Jan 2008 22:13:12.0949 (UTC) FILETIME=[FF375A50:01C84F1E]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > -			       "radiotap head [%d]\n",
 > +			       "radiotap head [%ld]\n",
 >  			       skb_headroom(skb), sizeof(*iwl4965_rt));

Actually I think the correct printf format for printing a size_t
(coming here from sizeof foo) is "%zd".  Otherwise you'll fix the
warning on 64-bit targets but add a new warning on 32-bit targets.

 - R.
