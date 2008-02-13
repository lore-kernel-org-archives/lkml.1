Return-Path: <linux-kernel-owner+w=401wt.eu-S1765082AbYBMA1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765082AbYBMA1i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 19:27:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761860AbYBMA1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 19:27:10 -0500
Received: from sj-iport-2.cisco.com ([171.71.176.71]:30156 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760989AbYBMA1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 19:27:07 -0500
To: Steve Wise <swise@opengridcomputing.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org
Subject: Re: [ofa-general] [PATCH 2.6.25] RDMA/cxgb3: Fail loopback connections.
X-Message-Flag: Warning: May contain useful information
References: <20080212220929.24442.76874.stgit@dell3.ogc.int>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 12 Feb 2008 16:26:56 -0800
In-Reply-To: <20080212220929.24442.76874.stgit@dell3.ogc.int> (Steve Wise's message of "Tue, 12 Feb 2008 16:09:29 -0600")
Message-ID: <adafxvxvgz3.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 13 Feb 2008 00:26:56.0856 (UTC) FILETIME=[23F2A580:01C86DD7]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

applied, although:

 > +static void is_loopback_dst(struct iw_cm_id *cm_id)
 > +{
 > +	struct net_device *dev;
 > +	
 > +	dev = ip_dev_find(&init_net, cm_id->remote_addr.sin_addr.s_addr);
 > +	if (!dev)
 > +		return 0;
 > +	dev_put(dev);
 > +	return 1;
 > +}

is there any way this could trigger when it should, like if I'm trying
to make a connection from one local device to a different local device
(which should work fine)?

 - R.
