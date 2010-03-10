Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab0CJM5b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 07:57:31 -0500
Received: from msux-gh1-uea01.nsa.gov ([63.239.67.1]:39827 "EHLO
	msux-gh1-uea01.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068Ab0CJM53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 07:57:29 -0500
Subject: Re: [PATCH] Security: Fix return value of avc_has_perm_noaudit()
 in security/selinux/avc.c
From: Stephen Smalley <sds@tycho.nsa.gov>
To: wzt.wzt@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       jmorris@namei.org
In-Reply-To: <20100310205348.GA3419@localhost.localdomain>
References: <20100310205348.GA3419@localhost.localdomain>
Content-Type: text/plain
Organization: National Security Agency
Date: Wed, 10 Mar 2010 07:57:25 -0500
Message-Id: <1268225845.2214.6.camel@moss-pluto.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-11 at 04:53 +0800, wzt.wzt@gmail.com wrote:
> avc_has_perm_noaudit() is not check the return value of avc_update_node, avc_update_node() delcared as int.
> 
> Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>

NAK.  Just cast to void instead.  This is on the permissive code path
and failure to update the node is non-fatal (just means we'll try again
next time) and should not cause the permission to be denied.

> 
> ---
>  security/selinux/avc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/security/selinux/avc.c b/security/selinux/avc.c
> index f2dde26..8bbce96 100644
> --- a/security/selinux/avc.c
> +++ b/security/selinux/avc.c
> @@ -763,7 +763,7 @@ int avc_has_perm_noaudit(u32 ssid, u32 tsid,
>  		if (flags & AVC_STRICT)
>  			rc = -EACCES;
>  		else if (!selinux_enforcing || (avd->flags & AVD_FLAGS_PERMISSIVE))
> -			avc_update_node(AVC_CALLBACK_GRANT, requested, ssid,
> +			rc = avc_update_node(AVC_CALLBACK_GRANT, requested, ssid,
>  					tsid, tclass, avd->seqno);
>  		else
>  			rc = -EACCES;
-- 
Stephen Smalley
National Security Agency

