Return-Path: <linux-kernel-owner+w=401wt.eu-S1752124AbYDDUxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124AbYDDUxT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 16:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751247AbYDDUxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 16:53:05 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:61803 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbYDDUxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 16:53:04 -0400
Message-ID: <47F68804.5060902@oracle.com>
Date: Fri, 04 Apr 2008 12:56:52 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Mark Fasheh <mfasheh@suse.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, joel.becker@oracle.com
Subject: Re: linux-next: Tree for March 25 (ocfs2 build)
References: <20080325175224.3ee62b09.sfr@canb.auug.org.au> <20080325143902.e69b704b.randy.dunlap@oracle.com> <20080404194716.GM21261@wotan.suse.de>
In-Reply-To: <20080404194716.GM21261@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Fasheh wrote:
> On Tue, Mar 25, 2008 at 02:39:02PM -0700, Randy Dunlap wrote:
>> ocfs2 link/build problem with
>> CONFIG_OCFS2_FS=y
>> CONFIG_OCFS2_FS_O2CB=m
>>
>> ERROR: "dlmunlock" [fs/ocfs2/ocfs2_stack_o2cb.ko] undefined!
>> ERROR: "dlm_setup_eviction_cb" [fs/ocfs2/ocfs2_stack_o2cb.ko] undefined!
>> ERROR: "dlm_register_eviction_cb" [fs/ocfs2/ocfs2_stack_o2cb.ko] undefined!
>> ERROR: "dlm_register_domain" [fs/ocfs2/ocfs2_stack_o2cb.ko] undefined!
>> ERROR: "dlm_unregister_domain" [fs/ocfs2/ocfs2_stack_o2cb.ko] undefined!
>> ERROR: "dlm_unregister_eviction_cb" [fs/ocfs2/ocfs2_stack_o2cb.ko] undefined!
>> ERROR: "dlmlock" [fs/ocfs2/ocfs2_stack_o2cb.ko] undefined!
>> ERROR: "dlm_print_one_lock" [fs/ocfs2/ocfs2_stack_o2cb.ko] undefined!
>> make[2]: *** [__modpost] Error 1
> 
> Ok, does this patch fix it for you?
> 	--Mark

Yes, thanks.

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>


> --
> Mark Fasheh
> 
> 
> From: Mark Fasheh <mfasheh@suse.com>
> 
> ocfs2: Only build ocfs2/dlm with the o2cb stack module
> 
> fs/ocfs2/dlm/ocfs2_dlm.ko and fs/ocfs2/dlm/ocfs2_dlmfs.ko get built if
> CONFIG_FS_OCFS2 is specified. This isn't quite how it should happen any more
> - the "o2cb" dlm modules should only be built if CONFIG_FS_OCFS2_O2CB is
> set, so update the dlm Makefile accordingly.
> 
> Signed-off-by: Mark Fasheh <mfasheh@suse.com>
> ---
>  fs/ocfs2/dlm/Makefile |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ocfs2/dlm/Makefile b/fs/ocfs2/dlm/Makefile
> index ce3f7c2..1903613 100644
> --- a/fs/ocfs2/dlm/Makefile
> +++ b/fs/ocfs2/dlm/Makefile
> @@ -1,6 +1,6 @@
>  EXTRA_CFLAGS += -Ifs/ocfs2
>  
> -obj-$(CONFIG_OCFS2_FS) += ocfs2_dlm.o ocfs2_dlmfs.o
> +obj-$(CONFIG_OCFS2_FS_O2CB) += ocfs2_dlm.o ocfs2_dlmfs.o
>  
>  ocfs2_dlm-objs := dlmdomain.o dlmdebug.o dlmthread.o dlmrecovery.o \
>  	dlmmaster.o dlmast.o dlmconvert.o dlmlock.o dlmunlock.o dlmver.o


-- 
~Randy
