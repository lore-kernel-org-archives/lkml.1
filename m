Return-Path: <linux-kernel-owner+w=401wt.eu-S1755486AbZBVLko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486AbZBVLko (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 06:40:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753649AbZBVLkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 06:40:31 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:51454 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753672AbZBVLk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 06:40:29 -0500
To: etienne.basset@numericable.fr
Cc: casey@schaufler-ca.com, paul.moore@hp.com,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][SMACK] convert smack rule list to linux list
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <49A13E15.6020509@numericable.fr>
In-Reply-To: <49A13E15.6020509@numericable.fr>
Message-Id: <200902222040.CAB86425.VMOQHFFFtOSLOJ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Sun, 22 Feb 2009 20:40:25 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

etienne wrote:
> diff --git a/security/smack/smack_access.c b/security/smack/smack_access.c
> index 2e0b83e..3dc312d 100644
> --- a/security/smack/smack_access.c
> +++ b/security/smack/smack_access.c
> @@ -87,7 +87,6 @@ static u32 smack_next_secid = 10;
>  int smk_access(char *subject_label, char *object_label, int request)
>  {
>  	u32 may = MAY_NOT;
> -	struct smk_list_entry *sp;
>  	struct smack_rule *srp;
>  
>  	/*
> @@ -139,8 +138,8 @@ int smk_access(char *subject_label, char *object_label, int request)
>  	 * access (e.g. read is included in readwrite) it's
>  	 * good.
>  	 */
> -	for (sp = smack_list; sp != NULL; sp = sp->smk_next) {
> -		srp = &sp->smk_rule;
> +
> +	list_for_each_entry(srp, &smack_rule_list, list) {
>  
>  		if (srp->smk_subject == subject_label ||
>  		    strcmp(srp->smk_subject, subject_label) == 0) {

Use of standard doubly linked list requires a lock, doesn't it?
What lock protects smack_rule_list?
