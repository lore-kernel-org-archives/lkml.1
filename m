Return-Path: <linux-kernel-owner+w=401wt.eu-S966709AbXFGWJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966709AbXFGWJh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 18:09:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966609AbXFGWIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 18:08:18 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:25286 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966739AbXFGWII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 18:08:08 -0400
Date: Thu, 7 Jun 2007 15:06:17 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Pavel Emelianov <xemul@openvz.org>
Cc: Andrew Morton <akpm@osdl.org>, linux-arch@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org, Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] Report that kernel is tainted if there were an OOPS
 before (v3)
Message-Id: <20070607150617.3e58d2a2.randy.dunlap@oracle.com>
In-Reply-To: <4667FF66.4010304@openvz.org>
References: <4667FF66.4010304@openvz.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Jun 2007 16:51:50 +0400 Pavel Emelianov wrote:

> If the kernel OOPSed or BUGed then it probably should
> be considered as tainted. Thus, all subsequent OOPSes 
> and SysRq dumps will report the tainted kernel. This 
> saves a lot of time explaining oddities in the calltraces.
> 
> The previous version was buggy and reported the kernel 
> to be tainted at the very first oops as was noticed by 
> Dave Jones in the report from Antonino Daplas.
> 
> Compilation is checked for i386, x86_64 and ia64 since 
> I have no all the others at hands :)
> 
> Signed-off-by: Pavel Emelianov <xemul@openvz.org>
> Cc: Randy Dunlap <randy.dunlap@oracle.com>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

I would change the doc. comment below:


> ---
> 
> diff --git a/Documentation/oops-tracing.txt b/Documentation/oops-tracing.txt
> index 7d5b60d..610e234 100644
> --- a/Documentation/oops-tracing.txt
> +++ b/Documentation/oops-tracing.txt
> @@ -237,6 +237,8 @@ characters, each representing a particul
>    7: 'U' if a user or user application specifically requested that the
>       Tainted flag be set, ' ' otherwise.
>  
> +  8: 'D' if the kernel has died recently, i.e. there was an OOPS or BUG.

something like:

+  8: 'D' if the kernel has already died, i.e. there was a prior OOPS or BUG.

> +
>  The primary reason for the 'Tainted: ' string is to tell kernel
>  debuggers if this is a clean kernel or if anything unusual has
>  occurred.  Tainting is permanent: even if an offending module is

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
