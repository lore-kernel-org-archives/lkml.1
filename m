Return-Path: <linux-kernel-owner+w=401wt.eu-S1759417AbYFSPgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759417AbYFSPgq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 11:36:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751032AbYFSPgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 11:36:39 -0400
Received: from gv-out-0910.google.com ([216.239.58.187]:48743 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbYFSPgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 11:36:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:x-mailer:mime-version:content-type
         :content-transfer-encoding;
        b=qw6PfIRu1jSM5Qw2o8MHQOYleGV6/R4HYXZCvA3w7/vdoqW6OFGmPTq8L2YEbrgU+9
         5lZyMofaCkIlK9Wt5+b4MKNjSah7Ty04JzlvRQgCXFOy96bUUPizC9CCyMu3miZ81VTZ
         /Z7k6kUwMIvKhtxzJbq8DGmgd1T4b46Z61maU=
Date: Thu, 19 Jun 2008 16:34:16 +0100
From: WANG Cong <xiyou.wangcong@gmail.com>
To: "Madhu R" <tuxmadhu@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: KLOGD loops continuously calling 'syslog' system call when
 prink is disabled
Message-ID: <20080619163416.57d7efc0@hack>
In-Reply-To: <94a8a9170806190609v4ad0049dva37c9712f3d928a1@mail.gmail.com>
References: <94a8a9170806190531j7404c96ei4bee3cf5774cbe5a@mail.gmail.com>
	<94a8a9170806190559x3d253006ic009b9c4b6714e5b@mail.gmail.com>
	<94a8a9170806190606r626bc57aq77c46586af97ea05@mail.gmail.com>
	<94a8a9170806190609v4ad0049dva37c9712f3d928a1@mail.gmail.com>
Organization: xiyou.edu.cn
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jun 2008 18:39:10 +0530
"Madhu R" <tuxmadhu@gmail.com> wrote:

> Hi All,
> 
>          when I disable printk(CONFIG_PRINTK=n) in the kernel config
> (2.6.26-rc6),  the klogd  loops continuously calling the 'syslog'
> system call. It consumes 99% of the cpu time ( using 'top' command ) .
> I found similar problem in the kernel mailing list and a patch had
> gone into the mainline kernel
> http://linux.derkeiler.com/Mailing-Lists/Kernel/2006-11/msg03317.html
> 
>          In the patch, it returns 'ENOSYS'' while calling 'syslog'
> system call if printk is disabled. So the klogd keeps on calling this
> 'syslog' and returns ENOSYS and this process takes most of the CPU
> time.
> 
> 
>          Please clarify whether I am following correct procedure or
> this is DEFAULT behavior of klogd.


IIRC, this is the fault of klogd. It doesn't check the return value
of syslog(2) (or klogclt(3), a wrapper in glibc) carefully.

If you can, please send a patch to sysklogd people.

Thanks.


-- 
Hi, I'm a .signature virus, please copy/paste me to help me spread
all over the world.
