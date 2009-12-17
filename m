Return-Path: <linux-kernel-owner+w=401wt.eu-S1765375AbZLQVTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765375AbZLQVTU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 16:19:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765346AbZLQVTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 16:19:15 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:35685 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765342AbZLQVTO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 16:19:14 -0500
Subject: Re: Wrong atime on recent kernels
From: john stultz <johnstul@us.ibm.com>
To: Petr =?UTF-8?Q?Tit=C4=9Bra?= <P.Titera@century.cz>
Cc: Petr =?UTF-8?Q?Tit=C4=9Bra?= <petr@titera.eu>,
       linux-kernel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
In-Reply-To: <4B2A1051.9010808@century.cz>
References: <4B26AB7E.9020208@titera.eu>
	 <1f1b08da0912141345ia574429k8b3e2fb73fdddb30@mail.gmail.com>
	 <4B29494B.4010305@titera.eu>
	 <1261020388.7245.27.camel@localhost.localdomain>
	 <4B2A1051.9010808@century.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Dec 2009 13:19:08 -0800
Message-ID: <1261084748.3466.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-17 at 12:04 +0100, Petr Titěra wrote:
> Now when I'm looking through stat /stats.file I was able to find some 
> really old instances of this error from October:
> 
>   File: `/mnt/data/linux-2.6/.git/refs/remotes/origin'
>   Size: 4096            Blocks: 8          IO Block: 4096   directory
> Device: fe00h/65024d    Inode: 130953      Links: 2
> Access: (0775/drwxrwxr-x)  Uid: (    0/    root)   Gid: (    0/    root)
> Access: 2009-12-16 21:21:52.776000002 +0100
> Modify: 2009-10-14 07:57:03.1000000000 +0200
> Change: 2009-10-14 07:57:03.1000000000 +0200
>   File: `/mnt/data/linux-2.6/.git/refs/remotes/origin/master'
>   Size: 41              Blocks: 8          IO Block: 4096   regular file
> Device: fe00h/65024d    Inode: 147522      Links: 1
> Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
> Access: 2009-10-14 07:57:04.040000000 +0200
> Modify: 2009-10-14 07:57:03.970000000 +0200
> Change: 2009-10-14 07:57:03.1000000000 +0200
> 
> So this happened before but only recently it started to happen in places 
> where it hurts. I found this trange behaviour because I was unable to 
> create initramfs of new kernels. mkinitrd command could not copy files 
> and preserve their times because of timestamp validity check in cp.

Huh. If its really the case, then its not the change I suspect. 

Ted: Have you seen anything like this? Where the sub-second field holds
a full second of time?


> I will try to revert commit you told me and will test.

Thanks, that will help greatly narrow this down.

thanks again
-john


