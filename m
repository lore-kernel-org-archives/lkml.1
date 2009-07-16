Return-Path: <linux-kernel-owner+w=401wt.eu-S1756600AbZGPAFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600AbZGPAFx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 20:05:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756381AbZGPAFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 20:05:53 -0400
Received: from tundra.namei.org ([65.99.196.166]:56116 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752750AbZGPAFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 20:05:52 -0400
Date: Thu, 16 Jul 2009 10:05:47 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: linux-security-module@vger.kernel.org, Sten Spans <Sten_Spans@genua.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: security_file_lock cmd argument
In-Reply-To: <alpine.LRH.2.00.0907092031020.4944@tundra.namei.org>
Message-ID: <alpine.LRH.2.00.0907161003550.27259@tundra.namei.org>
References: <alpine.LRH.2.00.0907092031020.4944@tundra.namei.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Sten Spans <Sten_Spans@genua.de>

This looks good, but you need to add a signed-off-by line per 
Documentation/SubmittingPatches


> To: linux-kernel@vger.kernel.org
> Subject: security_file_lock cmd argument
> 
> 
> I was playing around with the security_file_lock hook which
> is invoked from fs/locks.c. The desciption in include/linux/security.h
> states the following:
> 
>  * @file_lock:
>  *      Check permission before performing file locking operations.
>  *      Note: this hook mediates both flock and fcntl style locks.
>  *      @file contains the file structure.
>  *      @cmd contains the posix-translated lock operation to perform
>  *      (e.g. F_RDLCK, F_WRLCK).
> 
> However when invoked via sys_flock:
> 
> SYSCALL_DEFINE2(flock, unsigned int, fd, unsigned int, cmd)
> {
> ..
>         error = security_file_lock(filp, cmd);
> 
> Which results in passing flock style arguments (LOCK_*) rather
> than fcntl (F_*LCK). This also is inconsistent with the two
> other security_file_lock invocations in the same file.
> This one-liner fixes the issue:
> 
> --- fs/locks.c.orig	2009-07-09 11:26:45.000000000 +0200
> +++ fs/locks.c	2009-07-09 11:27:24.000000000 +0200
> @@ -1590,7 +1590,7 @@
>  	if (can_sleep)
>  		lock->fl_flags |= FL_SLEEP;
>  
> -	error = security_file_lock(filp, cmd);
> +	error = security_file_lock(filp, lock->fl_type);
>  	if (error)
>  		goto out_free;
>  
> -- 
> GeNUA Gesellschaft f?r Netzwerk - und Unix-Administration mbH
> Domagkstr. 7, D-85551 Kirchheim. http://www.genua.de
> Tel: (089) 99 19 50-0, Fax: (089) 99 19 50 - 999
>  
>  Gesch?ftsf?hrer: Dr. Magnus Harlander, Dr. Michaela Harlander,
>  Bernhard Schneck. Amtsgericht M?nchen HRB 98238
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
James Morris
<jmorris@namei.org>
