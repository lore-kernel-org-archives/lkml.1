Return-Path: <linux-kernel-owner+w=401wt.eu-S1754401AbXLGEH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401AbXLGEH2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 23:07:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752772AbXLGEHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 23:07:20 -0500
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:38759 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752612AbXLGEHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 23:07:19 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=vHNPJ5t4sdcGRYRPs0NWjf5gp4bGc7Ia0fS4nAfFrA5QeeqOuShZLThAJHB2FWhfDp7GgieIMPH6OOtTef2HVmN49BeYx0geIcHDzjOIR/KFvskpPLbNtcInQzVgcUspTbgBJ9Ic2pURyIDbSN8q8rXhUM3MOeDiVaxLAfAm6hY=  ;
X-YMail-OSG: .u1hW9cVM1lWPzomIPk9GA1Zz0XvxVXW_ZB2BUpLUfh8LIv64hpZGa2rJjMXAxDBUm.DdBhv6A--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 1/3] POWERPC: don't cast a pointer to pointer of list_head
Date: Fri, 7 Dec 2007 15:07:09 +1100
User-Agent: KMail/1.9.5
Cc: paulus@samba.org, LKML <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, Andrew Morton <akpm@linux-foundation.org>
References: <4757C1DA.6060603@cn.fujitsu.com>
In-Reply-To: <4757C1DA.6060603@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712071507.10161.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 December 2007 20:33, Li Zefan wrote:
> The casting is safe only when the list_head member is the
> first member of the structure.

Even so, I don't think too safe :) It might technically work,
but it could break more easily.

So even if you find places where list_head is the first member of
a structure, it would be nice to explicitly use the list_head member
and avoid casts IMO.

Thanks,
Nick

> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
>
> ---
>  arch/ppc/syslib/ocp.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/ppc/syslib/ocp.c b/arch/ppc/syslib/ocp.c
> index 3f5be2c..d42d408 100644
> --- a/arch/ppc/syslib/ocp.c
> +++ b/arch/ppc/syslib/ocp.c
> @@ -376,7 +376,7 @@ ocp_remove_one_device(unsigned int vendor, unsigned int
> function, int index)
>
>  	down_write(&ocp_devices_sem);
>  	dev = __ocp_find_device(vendor, function, index);
> -	list_del((struct list_head *)dev);
> +	list_del(&dev->link);
>  	up_write(&ocp_devices_sem);
>
>  	DBG(("ocp: ocp_remove_one_device(vendor: %x, function: %x, index: %d)...
> done.\n", vendor, function, index));
