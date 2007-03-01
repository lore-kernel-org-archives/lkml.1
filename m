Return-Path: <linux-kernel-owner+w=401wt.eu-S1030206AbXCAVEK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030206AbXCAVEK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 16:04:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030255AbXCAVEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 16:04:09 -0500
Received: from sj-iport-5.cisco.com ([171.68.10.87]:9255 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030206AbXCAVEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 16:04:08 -0500
X-IronPort-AV: i="4.14,238,1170662400"; 
   d="scan'208"; a="395541275:sNHT45344640"
To: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       general@lists.openfabrics.org, hch@infradead.org, raisch@de.ibm.com,
       heiko.carstens@de.ibm.com
Subject: Re: [PATCH 2.6.21-rc2] ehca: fix mismatched sync between completion handler and destroy cq
X-Message-Flag: Warning: May contain useful information
References: <200702281801.02747.hnguyen@linux.vnet.ibm.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 01 Mar 2007 13:04:05 -0800
In-Reply-To: <200702281801.02747.hnguyen@linux.vnet.ibm.com> (Hoang-Nam Nguyen's message of "Wed, 28 Feb 2007 18:01:02 +0100")
Message-ID: <ada8xegr7zu.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 01 Mar 2007 21:04:05.0653 (UTC) FILETIME=[25977450:01C75C45]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Looks OK to me, queued for 2.6.21, except:

 > +#include <linux/completion.h>

This can just be <linux/wait.h>, because you're only using
wait_queue_head_t and not struct completion, right?

I fixed this up before merging.
