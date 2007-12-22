Return-Path: <linux-kernel-owner+w=401wt.eu-S1753530AbXLVRjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530AbXLVRjm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 12:39:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752359AbXLVRjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 12:39:33 -0500
Received: from smtp.knology.net ([24.214.63.101]:57566 "EHLO smtp.knology.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752201AbXLVRjc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 12:39:32 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sat, 22 Dec 2007 12:39:32 EST
Subject: Re: list corruption on ib_srp load in v2.6.24-rc5
From: Dave Dillow <dave@thedillows.org>
To: FUJITA Tomonori <tomof@acm.org>
Cc: linux-kernel@vger.kernel.org, general@lists.openfabrics.org, pw@osc.edu,
       fujita.tomonori@lab.ntt.co.jp
In-Reply-To: <20071223014407L.tomof@acm.org>
References: <1198273973.9979.34.camel@lap75545.ornl.gov>
	 <1198275532.9979.43.camel@lap75545.ornl.gov>
	 <20071223014407L.tomof@acm.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sat, 22 Dec 2007 12:32:48 -0500
Message-Id: <1198344768.10564.1.camel@obelisk.thedillows.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-12-23 at 01:41 +0900, FUJITA Tomonori wrote:
> I think that as Pete pointed out, srp_remove_one needs to call
> srp_remove_host.
> 
> Can you try this?

If I need to escape family during the holidays, I'll test it from home.
Otherwise I'll be able to test on Wednesday.

Thanks for the patch,
Dave

> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index 950228f..bdb6f85 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -2053,6 +2053,7 @@ static void srp_remove_one(struct ib_device *device)
>  
>  		list_for_each_entry_safe(target, tmp_target,
>  					 &host->target_list, list) {
> +			srp_remove_host(target->scsi_host);
>  			scsi_remove_host(target->scsi_host);
>  			srp_disconnect_target(target);
>  			ib_destroy_cm_id(target->cm_id);

