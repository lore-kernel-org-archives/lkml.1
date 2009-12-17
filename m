Return-Path: <linux-kernel-owner+w=401wt.eu-S1764406AbZLQLFB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764406AbZLQLFB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 06:05:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764381AbZLQLFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 06:05:00 -0500
Received: from chudak.whitesoft.cz ([81.92.149.98]:47832 "EHLO
	sahara.whitesoft.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764373AbZLQLE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 06:04:58 -0500
Message-ID: <4B2A1051.9010808@century.cz>
Date: Thu, 17 Dec 2009 12:04:49 +0100
From: =?UTF-8?B?UGV0ciBUaXTEm3Jh?= <P.Titera@century.cz>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: =?UTF-8?B?UGV0ciBUaXTEm3Jh?= <petr@titera.eu>,
       linux-kernel@vger.kernel.org
Subject: Re: Wrong atime on recent kernels
References: <4B26AB7E.9020208@titera.eu>	 <1f1b08da0912141345ia574429k8b3e2fb73fdddb30@mail.gmail.com>	 <4B29494B.4010305@titera.eu> <1261020388.7245.27.camel@localhost.localdomain>
In-Reply-To: <1261020388.7245.27.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

john stultz napsal(a):
> On Wed, 2009-12-16 at 21:55 +0100, Petr Titěra wrote:
>   
>> john stultz napsal(a): 
>>     
>>> 2009/12/14 Petr Titěra <petr@titera.eu>:
>>>   
>>>       
>>>> Hello,
>>>>
>>>>      I see some strange file modification times recently. It seems to me
>>>> that in some situations, kernel allows to set nanoseconds part of  file
>>>> access, modification or change time  to 100000000 ns. Problem seems to be in
>>>> some generic part of kernel because I see it on several different
>>>> filesysytems (ext4 and nilf2). These is I've got during my testing on kernel
>>>>  2.6.32-tip-08309-gad8e75a.
>>>>
>>>>  File: `./Documentation/dvb/contributors.txt'
>>>>  Size: 3035            Blocks: 8          IO Block: 4096   regular file
>>>> Device: fe04h/65028d    Inode: 818         Links: 1
>>>> Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
>>>> Access: 2009-12-14 10:29:04.1000000000 +0100
>>>> Modify: 2009-12-14 10:29:04.1000000000 +0100
>>>> Change: 2009-12-14 10:29:04.1000000000 +0100
>>>>
>>>> See that all times of that file ends with 1e6 nanoseconds.
>>>>         
>>     I did not test reverting this patch yet, because I did not find
>> reliable way how to reproduce these strange modify times. But as I
>> read your description. Would it be possible that if there would be bug
>> in your patch i would be observer on mostly quiet system? I'm asking
>> because full day of testing of the system under load did not produce
>> any result, but then when I tried to run "find / | xargs stat" on idle
>> system I've got several new instances of wrong access time (filesystem
>> is mounted without noatime)
>>     
>
> Another quick question:
>
> What is the normal behavior you see when this issue is not cropping up?
>
> Do you normally see all 0's in the ns field? Or do you expect to see an
> actual ns value?
>
>   
Sorry to reply again. Previous message did not get to list:

I see values which seems to be ns times there. My root filesystem is 
ext4 too (recently I do not remeber if I formated it from scratch when I 
reinstalled that system) but I see this happen on other filesystems too

Root filesystem (ext4 may be converted from ext3)

  File: `/etc/sysconfig'
  Size: 4096            Blocks: 8          IO Block: 4096   directory
Device: fe00h/65024d    Inode: 65282       Links: 7
Access: (0755/drwxr-xr-x)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2009-12-16 21:14:00.172000000 +0100
Modify: 2009-12-12 11:01:48.1000000000 +0100
Change: 2009-12-12 11:01:48.1000000000 +0100
  File: `/etc/sysconfig/prelink'
  Size: 1459            Blocks: 8          IO Block: 4096   regular file
Device: fe00h/65024d    Inode: 22706       Links: 1
Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2009-12-14 10:27:46.912000002 +0100
Modify: 2004-11-23 11:43:08.000000000 +0100
Change: 2009-12-08 22:57:24.656000002 +0100
  File: `/etc/sysconfig/i18n'
  Size: 47              Blocks: 8          IO Block: 4096   regular file
Device: fe00h/65024d    Inode: 48962       Links: 1
Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2010-08-27 18:07:21.500013018 +0200
Modify: 2009-06-22 23:33:43.113581313 +0200
Change: 2009-06-22 23:58:39.936318201 +0200

/home (nilfs2)

  File: `/home/linux-2.6/include/linux/netfilter_ipv4/ipt_tos.h'
  Size: 184             Blocks: 8          IO Block: 4096   regular file
Device: fe04h/65028d    Inode: 20141       Links: 1
Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2009-12-15 18:59:33.1000000000 +0100
Modify: 2009-12-15 18:59:33.1000000000 +0100
Change: 2009-12-15 18:59:33.1000000000 +0100
  File: `/home/linux-2.6/include/linux/netfilter_ipv4/ipt_ttl.h'
  Size: 350             Blocks: 8          IO Block: 4096   regular file
Device: fe04h/65028d    Inode: 20547       Links: 1
Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2009-12-15 00:23:58.135760901 +0100
Modify: 2009-12-15 00:23:58.135760901 +0100
Change: 2009-12-15 00:23:58.135760901 +0100


/sources (btrfs)

  File: 
`/sources/linux-2.6/.git/objects/pack/pack-9aea3a0847debb83ad688214f648799fc46af3d3.pack'
  Size: 6255096         Blocks: 12224      IO Block: 4096   regular file
Device: 13h/19d Inode: 2129247     Links: 1
Access: (0444/-r--r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2009-12-16 21:16:09.424000000 +0100
Modify: 2009-12-16 21:17:20.1000000000 +0100
Change: 2009-12-16 21:17:21.564000000 +0100
  File: 
`/sources/linux-2.6/.git/objects/pack/pack-9aea3a0847debb83ad688214f648799fc46af3d3.idx'
  Size: 159552          Blocks: 312        IO Block: 4096   regular file
Device: 13h/19d Inode: 2129248     Links: 1
Access: (0444/-r--r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2009-12-16 21:17:21.296000000 +0100
Modify: 2009-12-16 21:17:21.324000001 +0100
Change: 2009-12-16 21:17:21.592000001 +0100


Now when I'm looking through stat /stats.file I was able to find some 
really old instances of this error from October:

  File: `/mnt/data/linux-2.6/.git/refs/remotes/origin'
  Size: 4096            Blocks: 8          IO Block: 4096   directory
Device: fe00h/65024d    Inode: 130953      Links: 2
Access: (0775/drwxrwxr-x)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2009-12-16 21:21:52.776000002 +0100
Modify: 2009-10-14 07:57:03.1000000000 +0200
Change: 2009-10-14 07:57:03.1000000000 +0200
  File: `/mnt/data/linux-2.6/.git/refs/remotes/origin/master'
  Size: 41              Blocks: 8          IO Block: 4096   regular file
Device: fe00h/65024d    Inode: 147522      Links: 1
Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2009-10-14 07:57:04.040000000 +0200
Modify: 2009-10-14 07:57:03.970000000 +0200
Change: 2009-10-14 07:57:03.1000000000 +0200

So this happened before but only recently it started to happen in places 
where it hurts. I found this trange behaviour because I was unable to 
create initramfs of new kernels. mkinitrd command could not copy files 
and preserve their times because of timestamp validity check in cp.

I will try to revert commit you told me and will test.

Petr

> I'm asking as all the filesystems I've played with have all zeros, so
> I'm not sure if I need to try a different filesystem (I tried ext4, but
> it was with a disk that was originally ext3), or if the issue is just
> the stray 1sec value in the ns field. 
>
> thanks
> -john
>
>
>
>
> __________ Informace od ESET Smart Security, verze databaze 4694 (20091216) __________
>
> Tuto zpravu proveril ESET Smart Security.
>
> http://www.eset.cz
>
>
>   



__________ Informace od ESET Smart Security, verze databaze 4694 (20091216) __________

Tuto zpravu proveril ESET Smart Security.

http://www.eset.cz


