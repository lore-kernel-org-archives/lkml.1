Return-Path: <linux-kernel-owner+w=401wt.eu-S1756911AbXI2Qf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911AbXI2Qf2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 12:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754744AbXI2QfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 12:35:19 -0400
Received: from mail-in-09.arcor-online.net ([151.189.21.49]:56580 "EHLO
	mail-in-09.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752638AbXI2QfR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 12:35:17 -0400
From: Florian Schmidt <mista.tapas@gmx.net>
To: linux-kernel@vger.kernel.org
Subject: Re: getting FUSD compiled with current kernels
Date: Sat, 29 Sep 2007 18:35:15 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
References: <200709291823.35868.mista.tapas@gmx.net>
In-Reply-To: <200709291823.35868.mista.tapas@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200709291835.15489.mista.tapas@gmx.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 29 September 2007, Florian Schmidt wrote:
> Hi,
>
> I'm trying to build FUSD [1] against current kernels [2.6.22]. I get errors
> [2]:

Oh i forgot to show the code snippets in question. I put them to the 
crresponding error below [matching line number is marked with [*]]:

>
> [2] ~/source/build_stuff/fusd$ make
> make -C libfusd
> make[1]: Entering directory `/home/tapas/source/build_stuff/fusd/libfusd'
> make[1]: Nothing to be done for `default'.
> make[1]: Leaving directory `/home/tapas/source/build_stuff/fusd/libfusd'
> make -C kfusd
> make[1]: Entering directory `/home/tapas/source/build_stuff/fusd/kfusd'
> make -C /lib/modules/2.6.22-11-generic/build
> SUBDIRS=/home/tapas/source/build_st
> uff/fusd/kfusd
> EXTRA_CFLAGS=-I/home/tapas/source/build_stuff/fusd/kfusd/../inclu
> de modules
> make[2]: Entering directory `/usr/src/linux-headers-2.6.22-11-generic'
>   CC [M]  /home/tapas/source/build_stuff/fusd/kfusd/kfusd.o
> /home/tapas/source/build_stuff/fusd/kfusd/kfusd.c: In function ‘to_kobj’:
> /home/tapas/source/build_stuff/fusd/kfusd/kfusd.c:135: error: dereferencing
> poin
> ter to incomplete type

static inline struct kobject * to_kobj(struct dentry * dentry)
{
  struct sysfs_dirent * sd = dentry->d_fsdata;
  if(sd)
    return ((struct kobject *) sd->s_element); [*]
  else
    return NULL;
}


> /home/tapas/source/build_stuff/fusd/kfusd/kfusd.c: In
> function ‘fusd_register_de
> vice’:
> /home/tapas/source/build_stuff/fusd/kfusd/kfusd.c:2049: error: ‘struct
> kset’ has
>  no member named ‘kset’

[...]
            if(classdir2){
              // jackpot.  extract the class.
              struct kobject *ko = to_kobj(classdir2);
              sys_class = (ko?to_class(ko):NULL); [*]

              if(!sys_class)
                RDEBUG(2, "WARNING: sysfs entry for %s has no kobject!
\n",register_msg.clazz);
            }
[...]

> /home/tapas/source/build_stuff/fusd/kfusd/kfusd.c:2049: warning: type
> defaults t
> o ‘int’ in declaration of ‘__mptr’
> /home/tapas/source/build_stuff/fusd/kfusd/kfusd.c:2049: warning:
> initialization
>
> >from incompatible pointer type
>
> /home/tapas/source/build_stuff/fusd/kfusd/kfusd.c:2049: error: ‘struct
> kset’ has
>  no member named ‘kset’
> /home/tapas/source/build_stuff/fusd/kfusd/kfusd.c: At top level:
> /home/tapas/source/build_stuff/fusd/kfusd/kfusd.c:2603: error: unknown
> field ‘wr
> itev’ specified in initializer

STATIC struct file_operations fusd_fops = {
  owner:    THIS_MODULE,
  open:     fusd_open,
  read:     fusd_read,
  write:    fusd_write,
  writev:   fusd_writev, [*]
  release:  fusd_release,
  poll:     fusd_poll,
};



> /home/tapas/source/build_stuff/fusd/kfusd/kfusd.c:2603: warning:
> initialization
>
> >from incompatible pointer type
>
> make[3]: *** [/home/tapas/source/build_stuff/fusd/kfusd/kfusd.o] Error 1
> make[2]: *** [_module_/home/tapas/source/build_stuff/fusd/kfusd] Error 2
> make[2]: Leaving directory `/usr/src/linux-headers-2.6.22-11-generic'
> make[1]: *** [default] Error 2
> make[1]: Leaving directory `/home/tapas/source/build_stuff/fusd/kfusd'
> make: *** [default] Error 2
>
> [3] http://fort.xdas.com/~kor/oss2jack/



-- 
Palimm Palimm!
http://tapas.affenbande.org
