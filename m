Return-Path: <linux-kernel-owner+w=401wt.eu-S1756306AbZJSOMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306AbZJSOMf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 10:12:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756027AbZJSOMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 10:12:34 -0400
Received: from cantor.suse.de ([195.135.220.2]:45481 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755289AbZJSOMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 10:12:34 -0400
Date: Mon, 19 Oct 2009 16:12:38 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: linux-kernel@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH 2/7] ipc: fix trivial warning
In-Reply-To: <1255906474-25091-3-git-send-email-felipe.contreras@gmail.com>
Message-ID: <alpine.LSU.2.00.0910191610160.8582@wotan.suse.de>
References: <1255906474-25091-1-git-send-email-felipe.contreras@gmail.com> <1255906474-25091-3-git-send-email-felipe.contreras@gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Oct 2009, Felipe Contreras wrote:

> Commit a0d092f introduced the following warning:
> ipc/msg.c: In function ?msgctl_down?:
> ipc/msg.c:415: warning: ?msqid64? may be used uninitialized in this function
> 
> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
> ---
>  ipc/msg.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/ipc/msg.c b/ipc/msg.c
> index 2ceab7f..085bd58 100644
> --- a/ipc/msg.c
> +++ b/ipc/msg.c
> @@ -412,7 +412,7 @@ static int msgctl_down(struct ipc_namespace *ns, int msqid, int cmd,
>  		       struct msqid_ds __user *buf, int version)
>  {
>  	struct kern_ipc_perm *ipcp;
> -	struct msqid64_ds msqid64;
> +	struct msqid64_ds uninitialized_var(msqid64);
>  	struct msg_queue *msq;
>  	int err;

What gcc are you using? I am not getting any warning at least with gcc 
"(SUSE Linux) 4.3.1 20080507 (prerelease) [gcc-4_3-branch revision 
135036]"

$ make ipc/msg.o
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  SYMLINK include/asm -> include/asm-x86
  CALL    scripts/checksyscalls.sh
  CC      ipc/msg.o
$

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
