Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722Ab0BXLKf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 06:10:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47950 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756660Ab0BXLKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 06:10:33 -0500
Date: Wed, 24 Feb 2010 12:09:03 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] supress uid comparison test if core output files are
	pipes
Message-ID: <20100224110903.GA18240@redhat.com>
References: <20100222200851.GD3344@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100222200851.GD3344@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22, Neil Horman wrote:
>
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1987,8 +1987,9 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
>  	/*
>  	 * Dont allow local users get cute and trick others to coredump
>  	 * into their pre-created files:
> +	 * Note, this is not relevant for pipes
>  	 */
> -	if (inode->i_uid != current_fsuid())
> +	if (!ispipe && (inode->i_uid != current_fsuid()))
>  		goto close_fail;

Ah. This is because the previous recursion-check moved create_write_pipe()
from current's context to kthread's context, right?

Looks like a right (and "must have") fix for recent -mm changes to me.



This also reminds me do_coredump() asks for cleanup. I'll try to redo/resend
my old cleanup patches on top of your changes.

Oleg.

