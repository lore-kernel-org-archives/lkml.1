Return-Path: <linux-kernel-owner+w=401wt.eu-S1758274AbZEOAlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758274AbZEOAlW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 20:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751652AbZEOAlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 20:41:13 -0400
Received: from tundra.namei.org ([65.99.196.166]:52381 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470AbZEOAlN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 20:41:13 -0400
Date: Fri, 15 May 2009 10:39:42 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Eric Paris <eparis@redhat.com>
cc: zohar@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] IMA: do not measure everything opened by root by
 default
In-Reply-To: <20090512191423.6903.37464.stgit@dhcp231-142.rdu.redhat.com>
Message-ID: <alpine.LRH.2.00.0905151039340.5643@tundra.namei.org>
References: <20090512191423.6903.37464.stgit@dhcp231-142.rdu.redhat.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 May 2009, Eric Paris wrote:

> The IMA default policy measures every single file opened by root.  This is
> terrible for most users.  Consider a system (like mine) with virtual machine
> images.  When those images are touched (which happens at boot for me) those
> images are measured.  This is just way too much for the default case.
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>

Applied to 
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

> ---
> 
>  security/integrity/ima/ima_policy.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
> index b168c1d..dec6dcb 100644
> --- a/security/integrity/ima/ima_policy.c
> +++ b/security/integrity/ima/ima_policy.c
> @@ -61,8 +61,6 @@ static struct ima_measure_rule_entry default_rules[] = {
>  	 .flags = IMA_FUNC | IMA_MASK},
>  	{.action = MEASURE,.func = BPRM_CHECK,.mask = MAY_EXEC,
>  	 .flags = IMA_FUNC | IMA_MASK},
> -	{.action = MEASURE,.func = PATH_CHECK,.mask = MAY_READ,.uid = 0,
> -	 .flags = IMA_FUNC | IMA_MASK | IMA_UID}
>  };
>  
>  static LIST_HEAD(measure_default_rules);
> 

-- 
James Morris
<jmorris@namei.org>
