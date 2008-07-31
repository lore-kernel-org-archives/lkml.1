Return-Path: <linux-kernel-owner+w=401wt.eu-S1754610AbYGaRmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610AbYGaRmd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 13:42:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751940AbYGaRmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 13:42:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44378 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751724AbYGaRmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 13:42:23 -0400
Subject: Re: [PATCH] the loginuid field should be output in all
	AUDIT_CONFIG_CHANGE audit messages
From: Eric Paris <eparis@redhat.com>
To: zhangxiliang <zhangxiliang@cn.fujitsu.com>
Cc: sgrubb@redhat.com, viro@zeniv.linux.org.uk,
       Linux Audit <linux-audit@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <488FE2B9.2040101@cn.fujitsu.com>
References: <488FE2B9.2040101@cn.fujitsu.com>
Content-Type: text/plain
Date: Thu, 31 Jul 2008 13:42:02 -0400
Message-Id: <1217526122.2902.103.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-30 at 11:40 +0800, zhangxiliang wrote:
> In the audit message which type is "AUDIT_CONFIG_CHANGE", the output format should contain "auid" field.

shouldn't these be using the "audit_get_loginuid(current)"  and if we
are going to output loginuid we also should be outputting sessionid

-Eric

> 
> Signed-off-by: Zhang Xiliang <zhangxiliang@cn.fujitsu.com>
> ---
>  kernel/auditfilter.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
> index 98c50cc..8a184f5 100644
> --- a/kernel/auditfilter.c
> +++ b/kernel/auditfilter.c
> @@ -1022,8 +1022,9 @@ static void audit_update_watch(struct audit_parent *parent,
>  			struct audit_buffer *ab;
>  			ab = audit_log_start(NULL, GFP_KERNEL,
>  				AUDIT_CONFIG_CHANGE);
> +			audit_log_format(ab, "auid=%u", current->loginuid);
>  			audit_log_format(ab,
> -				"op=updated rules specifying path=");
> +				" op=updated rules specifying path=");
>  			audit_log_untrustedstring(ab, owatch->path);
>  			audit_log_format(ab, " with dev=%u ino=%lu\n",
>  				 dev, ino);
> @@ -1058,7 +1059,8 @@ static void audit_remove_parent_watches(struct audit_parent *parent)
>  				struct audit_buffer *ab;
>  				ab = audit_log_start(NULL, GFP_KERNEL,
>  					AUDIT_CONFIG_CHANGE);
> -				audit_log_format(ab, "op=remove rule path=");
> +				audit_log_format(ab, "auid=%u", current->loginuid);
> +				audit_log_format(ab, " op=remove rule path=");
>  				audit_log_untrustedstring(ab, w->path);
>  				if (r->filterkey) {
>  					audit_log_format(ab, " key=");
> -- 
> 1.5.4.2
> 
> 

