Return-Path: <linux-kernel-owner+w=401wt.eu-S1161131AbXCHXnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161131AbXCHXnZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 18:43:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161221AbXCHXnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 18:43:24 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:56533 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161131AbXCHXnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 18:43:24 -0500
Message-ID: <45F09F9C.4030801@cosmosbay.com>
Date: Fri, 09 Mar 2007 00:43:24 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: "Michael K. Edwards" <medwards.linux@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: sys_write() racy for multi-threaded append?
References: <f2b55d220703081508r3d8d033cu99f53104943d16cb@mail.gmail.com>
In-Reply-To: <f2b55d220703081508r3d8d033cu99f53104943d16cb@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Fri, 09 Mar 2007 00:43:21 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael K. Edwards a écrit :
> from sys_write():
> 
>        file = fget_light(fd, &fput_needed);
>        if (file) {
>                loff_t pos = file_pos_read(file);
>                ret = vfs_write(file, buf, count, &pos);
>                file_pos_write(file, pos);
>                fput_light(file, fput_needed);
>        }
> 
> Surely that's racy when two threads write to the same fd and the first
> vfs_write call blocks or is preempted.  Or does fget_light take some
> per-file lock that I'm not seeing?

Nothing in the manuals says that write() on same fd should be non racy : In 
particular file pos might be undefined. There is a reason pwrite() exists.

Kernel doesnt have to enforce thread safety as standard is quite clear.

Only O_APPEND case is specially handled (and NFS might fail to handle this 
case correctly)

