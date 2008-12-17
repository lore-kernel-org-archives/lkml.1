Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759041AbYLQHDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759041AbYLQHDQ (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 02:03:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751475AbYLQHCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 02:02:55 -0500
Received: from sj-iport-1.cisco.com ([171.71.176.70]:47282 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbYLQHCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 02:02:54 -0500
X-IronPort-AV: E=Sophos;i="4.36,235,1228089600"; 
   d="scan'208";a="119319091"
From: Roland Dreier <rdreier@cisco.com>
To: Julia Lawall <julia@diku.dk>
Cc: rolandd@cisco.com, sean.hefty@intel.com, hal.rosenstock@gmail.com,
        general@lists.openfabrics.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/11] drivers/infiniband: Move a dereference below a NULL test
References: <Pine.LNX.4.64.0812161611540.20444@pc-004.diku.dk>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 16 Dec 2008 23:02:52 -0800
In-Reply-To: <Pine.LNX.4.64.0812161611540.20444@pc-004.diku.dk> (Julia
	Lawall's message of "Tue, 16 Dec 2008 16:12:16 +0100 (CET)")
Message-ID: <ada7i5z1dyb.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 17 Dec 2008 07:02:52.0400 (UTC) FILETIME=[7A95FF00:01C96015]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > --- a/drivers/infiniband/hw/nes/nes_cm.c
 > +++ b/drivers/infiniband/hw/nes/nes_cm.c
 > @@ -376,13 +376,14 @@ int schedule_nes_timer(struct nes_cm_node *cm_node, struct sk_buff *skb,
 >  		int close_when_complete)
 >  {
 >  	unsigned long  flags;
 > -	struct nes_cm_core *cm_core = cm_node->cm_core;
 > +	struct nes_cm_core *cm_core;
 >  	struct nes_timer_entry *new_send;
 >  	int ret = 0;
 >  	u32 was_timer_set;
 >  
 >  	if (!cm_node)
 >  		return -EINVAL;
 > +	cm_core = cm_node->cm_core;

Thanks... I believe this is already taken care of by a patch pending for
2.6.29 (which should be in -next) that removes the test for NULL.

 - R.
