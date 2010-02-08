Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751071Ab0BHV2i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 16:28:38 -0500
Received: from tundra.namei.org ([65.99.196.166]:40241 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750701Ab0BHV2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 16:28:36 -0500
Date: Tue, 9 Feb 2010 08:28:33 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: wzt wzt <wzt.wzt@gmail.com>
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH] security/smack/smack.h: Fix smk_known length
In-Reply-To: <628d1651002080341k34331712l55797971b3546ba4@mail.gmail.com>
Message-ID: <alpine.LRH.2.00.1002090827330.1779@tundra.namei.org>
References: <628d1651002080341k34331712l55797971b3546ba4@mail.gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(note: please copy security/ patches to the LSM list, cc'd, along with the 
Smack maintainer).


On Mon, 8 Feb 2010, wzt wzt wrote:

> in security/smack/smack.h:
> struct smack_known {
>         struct list_head        list;
>         char                    smk_known[SMK_LABELLEN];
> but in security/smack/smack_access.c
> void smack_from_cipso(u32 level, char *cp, char *result)
> {
>         strncpy(result, final, SMK_MAXLEN);
> }
> miss '\0'.
> 
> Signed-off-by: wzt <wzt.wzt@gmail.com>
> Cc: Jmorris <jmorris@namei.org>
> 
> diff --git a/security/smack/smack.h b/security/smack/smack.h
> index c6e9aca..600474b 100644
> --- a/security/smack/smack.h
> +++ b/security/smack/smack.h
> @@ -109,7 +109,7 @@ struct smk_netlbladdr {
>   */
>  struct smack_known {
>         struct list_head        list;
> -       char                    smk_known[SMK_LABELLEN];
> +       char                    smk_known[SMK_LABELLEN + 1]; /*
> smk_known + \0 */
>         u32                     smk_secid;
>         struct smack_cipso      *smk_cipso;
>         spinlock_t              smk_cipsolock; /* for changing cipso map */
> 

-- 
James Morris
<jmorris@namei.org>
