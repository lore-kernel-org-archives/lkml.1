Return-Path: <linux-kernel-owner+w=401wt.eu-S1756722AbZLRDNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722AbZLRDNt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 22:13:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753023AbZLRDNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 22:13:47 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:60414 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752565AbZLRDNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 22:13:46 -0500
Subject: Re: Wrong atime on recent kernels
From: john stultz <johnstul@us.ibm.com>
To: Petr =?UTF-8?Q?Tit=C4=9Bra?= <P.Titera@century.cz>
Cc: Petr =?UTF-8?Q?Tit=C4=9Bra?= <petr@titera.eu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <4B2A1051.9010808@century.cz>
References: <4B26AB7E.9020208@titera.eu>
	 <1f1b08da0912141345ia574429k8b3e2fb73fdddb30@mail.gmail.com>
	 <4B29494B.4010305@titera.eu>
	 <1261020388.7245.27.camel@localhost.localdomain>
	 <4B2A1051.9010808@century.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Dec 2009 19:13:41 -0800
Message-ID: <1261106021.3466.76.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-17 at 12:04 +0100, Petr Titěra wrote:
> john stultz napsal(a):
> > On Wed, 2009-12-16 at 21:55 +0100, Petr Titěra wrote:
> >   
> >> john stultz napsal(a): 
> >>     
> >>> 2009/12/14 Petr Titěra <petr@titera.eu>:
> >>>   
> >>>       
> >>>> Hello,
> >>>>
> >>>>      I see some strange file modification times recently. It seems to me
> >>>> that in some situations, kernel allows to set nanoseconds part of  file
> >>>> access, modification or change time  to 100000000 ns. Problem seems to be in
> >>>> some generic part of kernel because I see it on several different
> >>>> filesysytems (ext4 and nilf2). These is I've got during my testing on kernel
> >>>>  2.6.32-tip-08309-gad8e75a.
> >>>>
> >>>>  File: `./Documentation/dvb/contributors.txt'
> >>>>  Size: 3035            Blocks: 8          IO Block: 4096   regular file
> >>>> Device: fe04h/65028d    Inode: 818         Links: 1
> >>>> Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
> >>>> Access: 2009-12-14 10:29:04.1000000000 +0100
> >>>> Modify: 2009-12-14 10:29:04.1000000000 +0100
> >>>> Change: 2009-12-14 10:29:04.1000000000 +0100
> >>>>
> >>>> See that all times of that file ends with 1e6 nanoseconds.
> >>>>         
> >>     I did not test reverting this patch yet, because I did not find
> >> reliable way how to reproduce these strange modify times. But as I
> >> read your description. Would it be possible that if there would be bug
> >> in your patch i would be observer on mostly quiet system? I'm asking
> >> because full day of testing of the system under load did not produce
> >> any result, but then when I tried to run "find / | xargs stat" on idle
> >> system I've got several new instances of wrong access time (filesystem
> >> is mounted without noatime)
> >>     
> >
> > Another quick question:
> >
> > What is the normal behavior you see when this issue is not cropping up?
> >
> > Do you normally see all 0's in the ns field? Or do you expect to see an
> > actual ns value?
> >
> >   
> Sorry to reply again. Previous message did not get to list:
> 
> I see values which seems to be ns times there. My root filesystem is 
> ext4 too (recently I do not remeber if I formated it from scratch when I 
> reinstalled that system) but I see this happen on other filesystems too
> 
> Root filesystem (ext4 may be converted from ext3)
> 
>   File: `/etc/sysconfig'
>   Size: 4096            Blocks: 8          IO Block: 4096   directory
> Device: fe00h/65024d    Inode: 65282       Links: 7
> Access: (0755/drwxr-xr-x)  Uid: (    0/    root)   Gid: (    0/    root)
> Access: 2009-12-16 21:14:00.172000000 +0100
> Modify: 2009-12-12 11:01:48.1000000000 +0100
> Change: 2009-12-12 11:01:48.1000000000 +0100
>   File: `/etc/sysconfig/prelink'
>   Size: 1459            Blocks: 8          IO Block: 4096   regular file
> Device: fe00h/65024d    Inode: 22706       Links: 1
> Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
> Access: 2009-12-14 10:27:46.912000002 +0100
> Modify: 2004-11-23 11:43:08.000000000 +0100
> Change: 2009-12-08 22:57:24.656000002 +0100
>   File: `/etc/sysconfig/i18n'
>   Size: 47              Blocks: 8          IO Block: 4096   regular file
> Device: fe00h/65024d    Inode: 48962       Links: 1
> Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
> Access: 2010-08-27 18:07:21.500013018 +0200
> Modify: 2009-06-22 23:33:43.113581313 +0200
> Change: 2009-06-22 23:58:39.936318201 +0200

So I'm not reproducing this with 2.6.33-rc1 on a fresh ext4 partition on
x68_64.

  File: `virt'
  Size: 4096            Blocks: 8          IO Block: 4096   directory
Device: 804h/2052d      Inode: 1868440     Links: 3
Access: (0755/drwxr-xr-x)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2009-12-17 21:22:44.692710730 -0500
Modify: 2009-12-17 20:14:40.000000000 -0500
Change: 2009-12-17 21:20:21.001915208 -0500
  File: `vmlinux'
  Size: 21122497        Blocks: 24136      IO Block: 4096   regular file
Device: 804h/2052d      Inode: 1874435     Links: 1
Access: (0755/-rwxr-xr-x)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2009-12-17 21:22:05.381691121 -0500
Modify: 2009-12-17 21:22:05.376691754 -0500
Change: 2009-12-17 21:22:05.376691754 -0500
  File: `vmlinux.o'
  Size: 16701780        Blocks: 32624      IO Block: 4096   regular file
Device: 804h/2052d      Inode: 1874418     Links: 1
Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2009-12-17 21:22:01.138228732 -0500
Modify: 2009-12-17 21:22:01.131229619 -0500
Change: 2009-12-17 21:22:01.131229619 -0500


Let me know if you find anything that helps narrow this down.

thanks
-john



