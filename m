Return-Path: <linux-kernel-owner+w=401wt.eu-S1764688AbYBWIF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764688AbYBWIF7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 03:05:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762066AbYBWIDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 03:03:52 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:38405 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761790AbYBWIDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 03:03:49 -0500
Date: Sat, 23 Feb 2008 00:02:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Andrew Morgan <morgan@kernel.org>
Subject: Re: [PATCH 1/1] file capabilities: simplify signal check
Message-Id: <20080223000243.e6efb30f.akpm@linux-foundation.org>
In-Reply-To: <20080220161550.GA14630@sergelap.austin.ibm.com>
References: <20080220161550.GA14630@sergelap.austin.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2008 10:15:50 -0600 "Serge E. Hallyn" <serue@us.ibm.com> wrote:

> >From bd076c7245d02be0cc01b7c09bd7170ec5946492 Mon Sep 17 00:00:00 2001
> From: Serge E. Hallyn <serue@us.ibm.com>
> Date: Sun, 17 Feb 2008 20:28:07 -0500
> Subject: [PATCH 1/1] file capabilities: simplify signal check
> 
> Simplify the uid equivalence check in cap_task_kill().  Anyone
> can kill a process owned by the same uid.
> 
> Without this patch wireshark is reported to fail.

Strange that a patch titled "simplify...." actually fixes a bug.

> Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
> Signed-off-by: Andrew G. Morgan <morgan@kernel.org>
> ---
>  security/commoncap.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/security/commoncap.c b/security/commoncap.c
> index 5aba826..bb0c095 100644
> --- a/security/commoncap.c
> +++ b/security/commoncap.c
> @@ -552,7 +552,7 @@ int cap_task_kill(struct task_struct *p, struct siginfo *info,
>  	 * allowed.
>  	 * We must preserve legacy signal behavior in this case.
>  	 */
> -	if (p->euid == 0 && p->uid == current->uid)
> +	if (p->uid == current->uid)
>  		return 0;
>  
>  	/* sigcont is permitted within same session */

I've marked this as needed-in-2.6.24.  Was that appropriate?
