Return-Path: <linux-kernel-owner+w=401wt.eu-S1754544AbZG1U5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544AbZG1U5A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 16:57:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754244AbZG1U47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 16:56:59 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1552 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068AbZG1U46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 16:56:58 -0400
Subject: Re: [PATCH v2 2/2] IPVS: use pr_err and friends instead of
 IP_VS_ERR and friends
From: Joe Perches <joe@perches.com>
To: Hannes Eder <heder@google.com>
Cc: lvs-devel@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jan Engelhardt <jengelh@medozas.de>
In-Reply-To: <20090728203554.7654.29628.stgit@jazzy.zrh.corp.google.com>
References: <20090728203414.7654.73236.stgit@jazzy.zrh.corp.google.com>
	 <20090728203554.7654.29628.stgit@jazzy.zrh.corp.google.com>
Content-Type: text/plain
Date: Tue, 28 Jul 2009 13:56:55 -0700
Message-Id: <1248814615.18284.22.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-28 at 22:35 +0200, Hannes Eder wrote:
> Since pr_err and friends is used instead of printk there is not point
> in keeping IP_VS_ERR and friends.
> +			pr_err("Schedule: port zero only supported "
> +			       "in persistent services, "
> +			       "check your ipvs configuration\n");

You might consider ignoring the checkpatch 80 char limit here
and consolidate the message into a single string.

It helps when grepping.

> @@ -377,8 +377,8 @@ static int ip_vs_svc_hash(struct ip_vs_service *svc)
>  static int ip_vs_svc_unhash(struct ip_vs_service *svc)
>  {
>  	if (!(svc->flags & IP_VS_SVC_F_HASHED)) {
> -		IP_VS_ERR("ip_vs_svc_unhash(): request for unhash flagged, "
> -			  "called from %p\n", __builtin_return_address(0));
> +		pr_err("ip_vs_svc_unhash(): request for unhash flagged, "
> +		       "called from %p\n", __builtin_return_address(0));

Maybe use something like:
	"%s(): <foo> called from %pf",
	 __func__, __builtin_return_address(0)


