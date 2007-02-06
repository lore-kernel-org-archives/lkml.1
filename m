Return-Path: <linux-kernel-owner+w=401wt.eu-S1752247AbXBFO42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247AbXBFO42 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 09:56:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752246AbXBFO42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 09:56:28 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:60143 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247AbXBFO41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 09:56:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=l205TxcPuFeglQ3pa8mDruA1u3u2RsO0GLhrmXb9ipxUDtRETtjRqauSWXom+kn+TPDNAlMtkkDw74l7Qju/tgdHoBMywbNSv3qNQiYZdBC58Y1T4yHTzxC5wkToXGgjgya7zRxx1LYIoQVnV5nFej+lx00vfQ5K1eOVMBx891s=
Date: Tue, 6 Feb 2007 14:56:09 +0000
From: Frederik Deweerdt <deweerdt@free.fr>
To: Srinivasa Ds <srinivasa@in.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       akpm@osdl.org, torvalds@osdl.org, jkenisto@us.ibm.com,
       anil.s.keshavamurthy@intel.com, prasanna@in.ibm.com, ananth@in.ibm.com
Subject: Re: [RFC] [PATCH] To list all active probes in the system
Message-ID: <20070206145609.GA11249@slug>
References: <45C85097.1000106@in.ibm.com> <20070206100607.GA10296@infradead.org> <45C856F1.7060403@in.ibm.com> <45C894EA.4060305@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45C894EA.4060305@in.ibm.com>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Comments below,

On Tue, Feb 06, 2007 at 08:17:06PM +0530, Srinivasa Ds wrote:
> Srinivasa Ds wrote:
> > Christoph Hellwig wrote:
> >> On Tue, Feb 06, 2007 at 03:25:35PM +0530, Srinivasa Ds wrote:
> >>> Hi folks
> >>>
> >>>         I have developed a patch, that lists all active probes in the
> >>> system. I have done this through /proc interface. Currently list is
> >>> available under /proc/kprobes/list. Any suggestions for better place and
> >>> name??
> >> /debug/kprobes/list? :)
> >>
> > Good Idea, I will update my patch to use debugfs.
> Patch that uses debugfs.
> 
> Signed-off-by: Srinivasa DS <srinivasa@in.ibm.com>
> 
> 
> 
> 
> 

>  fs/debugfs/inode.c      |    4 ++
>  include/linux/kprobes.h |    4 ++
>  kernel/kprobes.c        |   92 ++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 100 insertions(+)
> 
> Index: linux-2.6.20/fs/debugfs/inode.c
> ===================================================================
> --- linux-2.6.20.orig/fs/debugfs/inode.c
> +++ linux-2.6.20/fs/debugfs/inode.c
> @@ -25,6 +25,7 @@
>  #include <linux/namei.h>
>  #include <linux/debugfs.h>
>  #include <linux/fsnotify.h>
> +#include <linux/kprobes.h>
>  
>  #define DEBUGFS_MAGIC	0x64626720
>  
> @@ -320,6 +321,9 @@ static int __init debugfs_init(void)
>  	retval = register_filesystem(&debug_fs_type);
>  	if (retval)
>  		subsystem_unregister(&debug_subsys);
> +#ifdef CONFIG_KPROBES
> +	debugfs_kprobe_init();
> +#endif
The ifdef here could be skipped if ....
>  	return retval;
>  }
>  
[... snip ...]
> Index: linux-2.6.20/include/linux/kprobes.h
> ===================================================================
> --- linux-2.6.20.orig/include/linux/kprobes.h
> +++ linux-2.6.20/include/linux/kprobes.h
> @@ -203,6 +203,7 @@ struct kretprobe_instance *get_free_rp_i
>  void add_rp_inst(struct kretprobe_instance *ri);
>  void kprobe_flush_task(struct task_struct *tk);
>  void recycle_rp_inst(struct kretprobe_instance *ri, struct hlist_head *head);
> +void debugfs_kprobe_init(void);
>  #else /* CONFIG_KPROBES */
>  
>  #define __kprobes	/**/
> @@ -240,5 +241,8 @@ static inline void unregister_kretprobe(
>  static inline void kprobe_flush_task(struct task_struct *tk)
>  {
>  }
> +static inline void proc_kprobe_init(void)
> +{
> +}
... this was renamed to debugfs_kprobe_init() instead -which was your
first intention I suppose ;)-

Regards,
Frederik
