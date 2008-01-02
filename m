Return-Path: <linux-kernel-owner+w=401wt.eu-S1753354AbYABRv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbYABRv6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 12:51:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751472AbYABRvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 12:51:50 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:3116 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbYABRvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 12:51:49 -0500
X-IronPort-AV: E=Sophos;i="4.24,235,1196668800"; 
   d="scan'208";a="29327668"
To: FUJITA Tomonori <tomof@acm.org>
Cc: David Dillow <dillowda@ornl.gov>, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org, pw@osc.edu,
       fujita.tomonori@lab.ntt.co.jp
Subject: Re: list corruption on ib_srp load in v2.6.24-rc5
X-Message-Flag: Warning: May contain useful information
References: <1198273973.9979.34.camel@lap75545.ornl.gov>
	<1198275532.9979.43.camel@lap75545.ornl.gov>
	<20071223014407L.tomof@acm.org>
	<1198689251.25003.2.camel@lap75545.ornl.gov>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 02 Jan 2008 09:51:38 -0800
In-Reply-To: <1198689251.25003.2.camel@lap75545.ornl.gov> (David Dillow's message of "Wed, 26 Dec 2007 12:14:11 -0500")
Message-ID: <adaprwkundh.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 02 Jan 2008 17:51:39.0056 (UTC) FILETIME=[2019D300:01C84D68]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > > Can you try this?
 > 
 > That patched oopsed in scsi_remove_host(), but reversing the order has
 > survived over 500 insert/probe/remove cycles.
 > 
 > Tested-by: David Dillow <dillowda@ornl.gov>
 > ---
 > diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
 > index 950228f..77e8b90 100644
 > --- a/drivers/infiniband/ulp/srp/ib_srp.c
 > +++ b/drivers/infiniband/ulp/srp/ib_srp.c
 > @@ -2054,6 +2054,7 @@ static void srp_remove_one(struct ib_device *device)
 >  		list_for_each_entry_safe(target, tmp_target,
 >  					 &host->target_list, list) {
 >  			scsi_remove_host(target->scsi_host);
 > +			srp_remove_host(target->scsi_host);
 >  			srp_disconnect_target(target);

Where do we stand on this?  What is the right place to put the
srp_remove_host?  Is there a bug somewhere else?

I'd like to get this fixed before 2.6.24 final comes out...

 - R.
