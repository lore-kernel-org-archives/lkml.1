Return-Path: <linux-kernel-owner+w=401wt.eu-S1754151AbYICLoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151AbYICLoU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 07:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751219AbYICLoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 07:44:12 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:59070 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbYICLoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 07:44:11 -0400
Message-ID: <48BE7885.3070609@fr.ibm.com>
Date: Wed, 03 Sep 2008 13:44:05 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Andrey Mirkin <major@openvz.org>
CC: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: [PATCH 1/9] Introduce trivial sys_checkpoint and sys_restore
 system	calls
References: <1220439476-16465-1-git-send-email-major@openvz.org> <1220439476-16465-2-git-send-email-major@openvz.org>
In-Reply-To: <1220439476-16465-2-git-send-email-major@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey Mirkin wrote:
> Right now they just return -ENOSYS. Later they will provide functionality
> to checkpoint and restart a container.
> 
> Both syscalls take as arguments a file descriptor and flags.
> Also sys_checkpoint take as the first argument a PID of container's init
> (later it will be container ID); sys_restart takes as the first argument
> a container ID (right now it will not be used).
> 
> Signed-off-by: Andrey Mirkin <major@openvz.org>
> ---
>  Makefile                           |    2 +-
>  arch/x86/kernel/syscall_table_32.S |    2 +
>  cpt/Makefile                       |    1 +
>  cpt/sys_core.c                     |   38 ++++++++++++++++++++++++++++++++++++
>  include/asm-x86/unistd_32.h        |    2 +
>  5 files changed, 44 insertions(+), 1 deletions(-)
>  create mode 100644 cpt/Makefile
>  create mode 100644 cpt/sys_core.c
> 
> diff --git a/Makefile b/Makefile
> index ea413fa..1dee5c0 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -619,7 +619,7 @@ export mod_strip_cmd
>  
>  
>  ifeq ($(KBUILD_EXTMOD),)
> -core-y		+= kernel/ mm/ fs/ ipc/ security/ crypto/ block/
> +core-y		+= kernel/ mm/ fs/ ipc/ security/ crypto/ block/ cpt/
>  
>  vmlinux-dirs	:= $(patsubst %/,%,$(filter %/, $(init-y) $(init-m) \
>  		     $(core-y) $(core-m) $(drivers-y) $(drivers-m) \
> diff --git a/arch/x86/kernel/syscall_table_32.S b/arch/x86/kernel/syscall_table_32.S
> index fd9d4f4..4a0d7fb 100644
> --- a/arch/x86/kernel/syscall_table_32.S
> +++ b/arch/x86/kernel/syscall_table_32.S
> @@ -333,3 +333,5 @@ ENTRY(sys_call_table)
>  	.long sys_pipe2
>  	.long sys_inotify_init1
>  	.long sys_hijack
> +	.long sys_checkpoint
> +	.long sys_restart		/* 335 */

this patchset is based on top of :

git://git.kernel.org/pub/scm/linux/kernel/git/daveh/linux-2.6-lxc.git

right ?

C.
