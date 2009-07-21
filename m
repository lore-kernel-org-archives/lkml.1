Return-Path: <linux-kernel-owner+w=401wt.eu-S1752686AbZGUFWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686AbZGUFWH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 01:22:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751563AbZGUFWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 01:22:05 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:54276 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265AbZGUFWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 01:22:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AsH53DmMdUDSReGE4sjTAFF7aS920sPFCNNqqdKmLp/QnI/ICk8DpfGFhVYfRdmZG5
         XdBCEzg/5xEC/x9zLo9VXSGoIPA84EUnLsb2b7vv1+Qaq9eML8WcbqkuF0AracF8gh5z
         sGNpAj/1pu8AVuOYkcamhFnaN5Cd5K8vDcht0=
Date: Mon, 20 Jul 2009 22:21:57 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Subrata Modak <subrata@linux.vnet.ibm.com>
Cc: Pau Oliva Fora <pof@eslack.org>, linux-input@vger.kernel.org,
       Sachin P Sant <sachinp@linux.vnet.ibm.com>,
       David Howells <dhowells@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/06][RESEND] Fix compilation warning for
	drivers/input/touchscreen/htcpen.c
Message-ID: <20090721052157.GA2605@dtor-d630.eng.vmware.com>
References: <20090721022344.30853.25784.sendpatchset@subratamodak.linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090721022344.30853.25784.sendpatchset@subratamodak.linux.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Subrata,

On Tue, Jul 21, 2009 at 07:53:44AM +0530, Subrata Modak wrote:
> gcc 4.4.1 generates the following build warning on i386:
> 
> CC drivers/input/touchscreen/htcpen.o
> drivers/input/touchscreen/htcpen.c:50: warning: 'pnp_ids' defined but not used
> 
> Fix this by removing the static keyword when you are actually exporting
> that structure. This patch was earlier posted on 14th July 2009:
> http://lkml.org/lkml/2009/7/14/362,
> 
> Signed-off-by: Subrata Modak<subrata@linux.vnet.ibm.com>

Umm, no, we don't export this particular structure, we are exporting
another structure referencing this. Are you compiling without module
support by any chance?

> ---
> 
> --- a/drivers/input/touchscreen/htcpen.c	2009-05-20 10:40:54.000000000 +0530
> +++ b/drivers/input/touchscreen/htcpen.c	2009-07-15 06:15:34.000000000 +0530
> @@ -47,7 +47,7 @@ static int invert_y;
>  module_param(invert_y, bool, 0644);
>  MODULE_PARM_DESC(invert_y, "If set, Y axis is inverted");
>  
> -static struct pnp_device_id pnp_ids[] = {
> +struct pnp_device_id pnp_ids[] = {
>  	{ .id = "PNP0cc0" },
>  	{ .id = "" }
>  };
> 

-- 
Dmitry
