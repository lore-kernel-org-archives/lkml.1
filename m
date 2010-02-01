Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602Ab0BARFz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 12:05:55 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:34366 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054Ab0BARFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 12:05:53 -0500
In-Reply-To: <4B666164.3090504@cn.fujitsu.com>
References: <4B666164.3090504@cn.fujitsu.com>
To: Shi Weihua <shiwh@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Al Viro <viro@ZenIV.linux.org.uk>
MIME-Version: 1.0
Subject: Re: security ima: Kernel BUG in ima_file_free -- bisected to commit
 6c21a7fb492bf7e2c4985937082ce58ddeca84bd
X-KeepSent: 59C26B81:9C2342BB-852576BD:005B3C33;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Release 8.5 December 05, 2008
Message-ID: <OF59C26B81.9C2342BB-ON852576BD.005B3C33-852576BD.005DE6D9@us.ibm.com>
From: Mimi Zohar <zohar@us.ibm.com>
Date: Mon, 1 Feb 2010 12:05:40 -0500
X-MIMETrack: Serialize by Router on D01ML604/01/M/IBM(Release 8.5.1HF41 | October 22, 2009) at
 02/01/2010 12:05:40,
	Serialize complete at 02/01/2010 12:05:40
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shi Weihua <shiwh@cn.fujitsu.com> wrote on 02/01/2010 12:06:44 AM:

> Hi, Mimi
> 
> Used the latest LTP to test 2.6.33-rc6, a Kernel BUG occured on my 
x86_64 (OS:
> Fedora 12).
> The message from dmesg is as following.
> The LTP case is testcases/kernel/syscalls/pipe/pipe06.c. For seeing code 
easily, I
> recreated a simple code to reproduce this BUG. please check the code in 
the attached.
> 
> I bisected a commit 6c21a7fb492bf7e2c4985937082ce58ddeca84bd,
>     --------
>     commit 6c21a7fb492bf7e2c4985937082ce58ddeca84bd
>     Author: Mimi Zohar <zohar@linux.vnet.ibm.com>
>     Date:   Thu Oct 22 17:30:13 2009 -0400
> 
>          LSM: imbed ima calls in the security hooks
>     --------
> Maybe you should fix it ;-)

Thanks for isolating the problem.  The problem is caused by 
free_write_pipe()
calling path_put(), which puts the dentry and mnt, before it calls 
put_filp(). 
The ordering should be like in __fput(), which puts the dentry and mnt as 
the
last thing it does.

Mimi
