Return-Path: <linux-kernel-owner+w=401wt.eu-S1762223AbZENNNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762223AbZENNNb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 09:13:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761319AbZENNM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 09:12:59 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:59430 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759400AbZENNM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 09:12:57 -0400
Subject: Re: [PATCH] IMA: do not measure everything opened by root by
 default
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Eric Paris <eparis@redhat.com>
Cc: jmorris@namei.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090512191423.6903.37464.stgit@dhcp231-142.rdu.redhat.com>
References: <20090512191423.6903.37464.stgit@dhcp231-142.rdu.redhat.com>
Content-Type: text/plain
Date: Thu, 14 May 2009 09:12:44 -0400
Message-Id: <1242306764.4647.6.camel@dyn9002018117.watson.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-12 at 15:14 -0400, Eric Paris wrote:
> The IMA default policy measures every single file opened by root.  This is
> terrible for most users.  Consider a system (like mine) with virtual machine
> images.  When those images are touched (which happens at boot for me) those
> images are measured.  This is just way too much for the default case.
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>

Acked-by: Mimi Zohar <zohar@us.ibm.com>

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

