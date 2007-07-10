Return-Path: <linux-kernel-owner+w=401wt.eu-S1763483AbXGJUbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763483AbXGJUbo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 16:31:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758577AbXGJUbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 16:31:37 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:57705 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757305AbXGJUbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 16:31:36 -0400
Subject: Re: [PATCH 0/16] Pid namespaces
From: Badari Pulavarty <pbadari@gmail.com>
To: Pavel Emelianov <xemul@openvz.org>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Cedric Le Goater <clg@fr.ibm.com>, Kirill Korotaev <dev@openvz.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>
In-Reply-To: <46938440.7000301@openvz.org>
References: <468DF6F7.1010906@openvz.org>
	 <1184003180.21234.39.camel@dyn9047017100.beaverton.ibm.com>
	 <46938440.7000301@openvz.org>
Content-Type: text/plain
Date: Tue, 10 Jul 2007 13:33:14 -0700
Message-Id: <1184099594.8390.0.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-10 at 17:06 +0400, Pavel Emelianov wrote:
> > Not able to boot my ppc64 machine with the patchset :(
> > 
> > Thanks,
> > Badari
> 
> That's the hunk lost during the split:
> 
> --- ./fs/proc/root.c.procfix	2007-07-10 13:52:08.000000000 +0400
> +++ ./fs/proc/root.c	2007-07-10 15:23:20.000000000 +0400
> @@ -111,7 +111,7 @@ void __init proc_root_init(void)
>  	err = register_filesystem(&proc_fs_type);
>  	if (err)
>  		return;
> -	proc_mnt = kern_mount(&proc_fs_type);
> +	proc_mnt = kern_mount_data(&proc_fs_type, &init_pid_ns);
>  	err = PTR_ERR(proc_mnt);
>  	if (IS_ERR(proc_mnt)) {
>  		unregister_filesystem(&proc_fs_type);
> 
> 
> With this machine should boot fine.

Yes. My ppc64 box booted fine with this patch.

Thanks,
Badari

