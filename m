Return-Path: <linux-kernel-owner+w=401wt.eu-S1752247AbXLDE3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247AbXLDE3S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 23:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751462AbXLDE3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 23:29:11 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:32873 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbXLDE3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 23:29:09 -0500
Message-ID: <4754D76B.8080406@ak.jp.nec.com>
Date: Tue, 04 Dec 2007 13:28:27 +0900
From: KaiGai Kohei <kaigai@ak.jp.nec.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: lkml <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org,
       Andrew Morgan <morgan@kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       Stephen Smalley <sds@epoch.ncsc.mil>, jmorris@sergelap.austin.ibm.com,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] capabilities: introduce per-process capability bounding
 set (v10)
References: <20071126200908.GA13287@sergelap.austin.ibm.com>
In-Reply-To: <20071126200908.GA13287@sergelap.austin.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge,

Please tell me the meanings of the following condition.

> diff --git a/security/commoncap.c b/security/commoncap.c
> index 3a95990..cb71bb0 100644
> --- a/security/commoncap.c
> +++ b/security/commoncap.c
> @@ -133,6 +119,12 @@ int cap_capset_check (struct task_struct *target, kernel_cap_t *effective,
>  		/* incapable of using this inheritable set */
>  		return -EPERM;
>  	}
> +	if (!!cap_issubset(*inheritable,
> +			   cap_combine(target->cap_inheritable,
> +				       current->cap_bset))) {
> +		/* no new pI capabilities outside bounding set */
> +		return -EPERM;
> +	}
>  
>  	/* verify restrictions on target's new Permitted set */
>  	if (!cap_issubset (*permitted,

It seems to me this condition requires the new inheritable capability
set must have a capability more than bounding set, at least.
What is the purpose of this checking?

In the initial state, any process have no inheritable capability set
and full bounding set. Thus, we cannot do capset() always.

Thanks,
-- 
OSS Platform Development Division, NEC
KaiGai Kohei <kaigai@ak.jp.nec.com>
