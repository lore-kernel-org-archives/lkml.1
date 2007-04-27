Return-Path: <linux-kernel-owner+w=401wt.eu-S1757919AbXD0XxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757919AbXD0XxA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 19:53:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757921AbXD0XxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 19:53:00 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:33643 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757919AbXD0Xw6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 19:52:58 -0400
X-Greylist: delayed 861 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Apr 2007 19:52:58 EDT
Message-Id: <1177717116.1762.1186993177@webmail.messagingengine.com>
X-Sasl-Enc: gcb1H7Ck5ggKFkPoQM7ktEcFT5NasFtTyIxycUqANOjS 1177717116
From: lkml777@123mail.org
To: "Jeff Chua" <jeff.chua.linux@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Eric Hopper" <hopper@omnifarious.org>,
       "William Heimbigner" <icxcnika@mar.tar.cc>,
       "Alex Zarochentsev" <zam@namesys.com>,
       "Andi Kleen" <andi@firstfloor.org>, "Rik van Riel" <riel@redhat.com>,
       "Edward Shishkin" <edward@namesys.com>
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <20070423111939.c876c9cc.akpm@linux-foundation.org>
   <462E17AF.7090604@namesys.com>
   <20070424193921.GA17129@one.firstfloor.org>
   <462F6717.70508@namesys.com>
   <b6a2187b0704250749s2a00dadep93b2943bc0b9df9d@mail.gmail.com>
   <1177564182.15467.1186637743@webmail.messagingengine.com>
   <b6a2187b0704252348t1242560dqad6a1d30e665abc5@mail.gmail.com>
   <b6a2187b0704260118x7cf8ed57mab9a12d06a2471a9@mail.gmail.com>
   <1177658163.8094.1186854037@webmail.messagingengine.com>
   <b6a2187b0704270937g18f305cdxfdd54349fb73f3ea@mail.gmail.com>
Subject: Re: Question about Reiser4 (how to boot it?)
In-Reply-To: <b6a2187b0704270937g18f305cdxfdd54349fb73f3ea@mail.gmail.com>
Date: Fri, 27 Apr 2007 16:38:36 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, that is certainly helpful, but that only mounts one directory
(partition) as Reiser4.

This I have already done.

I was more interested in how to have a whole partition dedicated to
Reiser4 and being able to boot into it.

By any chance did you do that?


On Sat, 28 Apr 2007 00:37:05 +0800, "Jeff Chua"
<jeff.chua.linux@gmail.com> said:
> On 4/27/07, lkml777@123mail.org <lkml777@123mail.org> wrote:
> 
> > Hi Jeff, could you outline the procedure that YOU used to get Reiser4
> > installed and running.
> 
> Pretty much the same as the steps from   ...
>      http://linuxhelp.150m.com/installs/compile-kernel.htm
> 
> cd /usr/src
> tar --use=bzip2 -xpf linux-2.6.21.tar.bz2
> ln -nsf linux-2.6.21 linux
> cd /usr/src/linux
> bzip2 -d -c /tmp/reiser4-for-2.6.20.patch.bz2 | patch -p1
> # copy your old .config here
> make menuconfig
>     File systems  --->
>           <*> Reiser4 (EXPERIMENTAL)
> make
> make modules_install
> # copy ./i386/boot/bzImage to the boot directory
> # reboot
> 
> 
> # download, compile and install ...
>           libaal-1.0.5.tar.gz
>           reiser4progs-1.0.6.tar.gz
> 
> I got them from  ftp://ftp.namesys.com/pub/reiser4progs/
> 
> Take an unused partition, and create reiser4fs on it...
> 
> mkfs.reiser4 /dev/sda8
> mount /dev/sda8 /mnt
> 
> Or you may want to try it on a loop device ...
> 
> dd if=/dev/zero  of=disk1  bs=1024k count=100
> mkfs.reiser4 -yf disk1
> mount -o loop disk1 /u0
> 
> Here's an entry in /etc/fstab
>     /dev/sda8    /u3    reiser4    noatime      0 0
> 
> 
> I hope this is good enough to get you started.
> 
> Thanks,
> Jeff.
-- 
  
  lkml777@123mail.org

-- 
http://www.fastmail.fm - And now for something completely different…

