Return-Path: <linux-kernel-owner+w=401wt.eu-S1753981AbZGNHba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981AbZGNHba (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 03:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753937AbZGNHb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 03:31:29 -0400
Received: from n12.bullet.mail.mud.yahoo.com ([209.191.125.209]:31817 "HELO
	n12.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753678AbZGNHb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 03:31:29 -0400
X-Yahoo-Newman-Id: 708799.14560.bm@omp412.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=rgcx80YnLOR1hXgZHRB40Vo/NAs9yiXEWI59u2y3KxzJtxXEZeLSMxv5khc7KVghOG01NKqvRGVmaNw2kpEA93VaLthoJ4heB8KxXmEyD0dmI2QiTZO0jYitrY1lqhgSe26GOFPcPIpikFV43Go5+A5Dyn4lw5KmMcMWq2bguxA=  ;
X-YMail-OSG: 2SgYmgQVM1lcTQdkHPr4kK0T2fDJVUalDoA4AcKyNIqYxmTQSVjcAiowLpodAQroRrl348rSvtnsMrJQTuuwfsW.PJMgts81_HP2Rv8kYIoMi5FEepbPbalG6IQtsGKhmsbl0Q4wOUvf1Uqk0tVEhrvtL0kDEKNhV3pYXaxEB3duevaISrROH_BuCtbKRc2ea2D4CoEOzZ5dj_5UdLNYvbSeR8Wz3zeVnZjFoof6L0lhvnM2n_RRcM5xnUntpVFfCXAzfkzLuvLBEEaDkvBSfNFjF7VVvjfka97UBucrqPmY36hLwx.rpPHQfhX89FC.SfvHxJiVX3EUeZuN1FyHOTTW
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: driver-core tree build failure
Date: Tue, 14 Jul 2009 00:31:27 -0700
User-Agent: KMail/1.9.10
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20090714163309.f2ee320d.sfr@canb.auug.org.au>
In-Reply-To: <20090714163309.f2ee320d.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907140031.27979.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 13 July 2009, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next build (x86_64 allmodconfig) failed like this:
> 
> drivers/mtd/mtdcore.c:220: error: expected '{' before 'const'
> drivers/mtd/mtdcore.c:227: error: 'mtd_groups' undeclared here (not in a function)
> 
> Caused by the update to commit ba87b739a1f5dd545679d886b8d193cdede991cf
> ("driver model: constify attribute groups").
> 
> I have applied the patch below for today.

That's a good patch, go with it.  Sorry; I guess this wasn't
the version I had test-built.  My eyes were reporting "static"
as the (expected) initial keyword there; they lied!


> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Tue, 14 Jul 2009 16:29:39 +1000
> Subject: [PATCH] driver-core: fix for mtd typo
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/mtd/mtdcore.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
> index 93e6731..05a16be 100644
> --- a/drivers/mtd/mtdcore.c
> +++ b/drivers/mtd/mtdcore.c
> @@ -217,7 +217,7 @@ struct attribute_group mtd_group = {
>  	.attrs		= mtd_attrs,
>  };
>  
> -struct const attribute_group *mtd_groups[] = {
> +const struct attribute_group *mtd_groups[] = {
>  	&mtd_group,
>  	NULL,
>  };
> -- 
> 1.6.3.3
> 
> 



