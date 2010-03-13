Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935708Ab0CMTgx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 14:36:53 -0500
Received: from smtp107.prem.mail.sp1.yahoo.com ([98.136.44.62]:42241 "HELO
	smtp107.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S935519Ab0CMTgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 14:36:50 -0500
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: A3m_ssYVM1m4kfCXrIvTSb7hZn.9lf9hcIKXuZ9H6YtROiOxFb5E12v49EmBx2_DyaFrDjlTc9I8M.Q0BNa._7z_ttT6JP8Gx54Qk8EAQtin0PjgVzVS6AdiZckN5NlTFvHX_4GxSvYMeIFMmTYqaK48N1VO.pYdsPxMOrFggxjlIP027irAZcVskcSty5pbKtSKNngSddgsFN9RL_JXthN2R.l91Mea.oqu_BVTZvYksYuWOEaVKQ0QRxkZ4lIgs9XqXkjUxPjBycbrPA7p41q8wAqniY4RhdKrCTKSxsm2acdQRd0gM2Y5EnM.npXaLkyFTOwprX8.ZkRYODqFLZb0e.0H1hc-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4B9BE952.7080808@schaufler-ca.com>
Date: Sat, 13 Mar 2010 11:36:50 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: wzt.wzt@gmail.com
CC: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Stephen Smalley <sds@tycho.nsa.gov>,
       Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH] Security: Add break judge to smk_import_entry() in security/smack/smack_access.c
References: <20100313132545.GB3126@localhost.localdomain>
In-Reply-To: <20100313132545.GB3126@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wzt.wzt@gmail.com wrote:
> In smk_import_entry(), smack[i] = '\0' was set if found = 1, so:
> if (found)
> 	smack[i] = '\0';
> No need to continue again, just can break the loop.
>
> Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>
>   
Nacked-by: Casey Schaufler <casey@schaufler-ca.com>
> ---
>  security/smack/smack_access.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/security/smack/smack_access.c b/security/smack/smack_access.c
> index 0f9ac81..0e064e8 100644
> --- a/security/smack/smack_access.c
> +++ b/security/smack/smack_access.c
> @@ -318,7 +318,7 @@ struct smack_known *smk_import_entry(const char *string, int len)
>  
>  	for (i = 0, found = 0; i < SMK_LABELLEN; i++) {
>  		if (found)
> -			smack[i] = '\0';
> +			break;
>  		else if (i >= len || string[i] > '~' || string[i] <= ' ' ||
>  			 string[i] == '/' || string[i] == '"' ||
>  			 string[i] == '\\' || string[i] == '\'') {
>   
The intention of this code is to fill the label. Yes, I could zero the
target in advance and break here but would that be significantly better?
I don't see that it would be. In any case, the change you suggest would
not suffice by itself.

Are you looking for a real project to work on? I could suggest a
thing or two that would be much more welcome than these attempts
at pointless code change.



