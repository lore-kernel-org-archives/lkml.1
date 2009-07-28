Return-Path: <linux-kernel-owner+w=401wt.eu-S1752643AbZG1Xdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643AbZG1Xdk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:33:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752160AbZG1Xdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:33:39 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:59509 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbZG1Xdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:33:38 -0400
Date: Wed, 29 Jul 2009 09:33:38 +1000
From: Simon Horman <horms@verge.net.au>
To: Joe Perches <joe@perches.com>
Cc: Hannes Eder <heder@google.com>, lvs-devel@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH v2 2/2] IPVS: use pr_err and friends instead of
	IP_VS_ERR and friends
Message-ID: <20090728233338.GD4026@verge.net.au>
References: <20090728203414.7654.73236.stgit@jazzy.zrh.corp.google.com> <20090728203554.7654.29628.stgit@jazzy.zrh.corp.google.com> <1248814615.18284.22.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248814615.18284.22.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 28, 2009 at 01:56:55PM -0700, Joe Perches wrote:
> On Tue, 2009-07-28 at 22:35 +0200, Hannes Eder wrote:
> > Since pr_err and friends is used instead of printk there is not point
> > in keeping IP_VS_ERR and friends.
> > +			pr_err("Schedule: port zero only supported "
> > +			       "in persistent services, "
> > +			       "check your ipvs configuration\n");
> 
> You might consider ignoring the checkpatch 80 char limit here
> and consolidate the message into a single string.

Personally, I prefer it the way it is.

> It helps when grepping.
> 
> > @@ -377,8 +377,8 @@ static int ip_vs_svc_hash(struct ip_vs_service *svc)
> >  static int ip_vs_svc_unhash(struct ip_vs_service *svc)
> >  {
> >  	if (!(svc->flags & IP_VS_SVC_F_HASHED)) {
> > -		IP_VS_ERR("ip_vs_svc_unhash(): request for unhash flagged, "
> > -			  "called from %p\n", __builtin_return_address(0));
> > +		pr_err("ip_vs_svc_unhash(): request for unhash flagged, "
> > +		       "called from %p\n", __builtin_return_address(0));
> 
> Maybe use something like:
> 	"%s(): <foo> called from %pf",
> 	 __func__, __builtin_return_address(0)
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
