Return-Path: <linux-kernel-owner+w=401wt.eu-S1757171AbYADAsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757171AbYADAsR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 19:48:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752913AbYADAsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 19:48:05 -0500
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:49390 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786AbYADAsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 19:48:04 -0500
To: dave@thedillows.org
Cc: tomof@acm.org, fujita.tomonori@lab.ntt.co.jp, rdreier@cisco.com,
       linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: [ofa-general] Re: list corruption on ib_srp load in v2.6.24-rc5
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1199393485.7561.51.camel@lap75545.ornl.gov>
References: <20080103173330T.tomof@acm.org>
	<1199390957.7561.33.camel@lap75545.ornl.gov>
	<1199393485.7561.51.camel@lap75545.ornl.gov>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080104094722F.fujita.tomonori@lab.ntt.co.jp>
Date: Fri, 04 Jan 2008 09:47:22 +0900
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Jan 2008 15:51:25 -0500
David Dillow <dave@thedillows.org> wrote:

> 
> On Thu, 2008-01-03 at 15:09 -0500, David Dillow wrote:
> > As for a better fix, I'm not sure.
> 
> Here's a better way than the strncmp. If this meets everyone's approval,
> then I can roll up a proper commit.

Thanks! I really apprecate it.

I think that this is the root problem and the patch fixes it in the
right way. Please send this patch to linux-scsi@vger.kernel.org and a
patch to move srp_remove_host before scsi_remove_host in
srp_remove_one to Roland.

Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

> diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
> index 44a340b..65c584d 100644
> --- a/drivers/scsi/scsi_transport_srp.c
> +++ b/drivers/scsi/scsi_transport_srp.c
> @@ -265,7 +265,8 @@ EXPORT_SYMBOL_GPL(srp_rport_del);
>  
>  static int do_srp_rport_del(struct device *dev, void *data)
>  {
> -	srp_rport_del(dev_to_rport(dev));
> +	if (scsi_is_srp_rport(dev))
> +		srp_rport_del(dev_to_rport(dev));
>  	return 0;
>  }
>  
> 
