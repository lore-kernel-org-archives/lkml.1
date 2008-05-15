Return-Path: <linux-kernel-owner+w=401wt.eu-S1761690AbYEOSbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761690AbYEOSbq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 14:31:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752982AbYEOSbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 14:31:36 -0400
Received: from web95109.mail.in2.yahoo.com ([203.104.18.161]:37524 "HELO
	web95109.mail.in2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752297AbYEOSbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 14:31:34 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=s1DsmYisSB29gqbcr5hhteJ5auJW0EDMLeBxJ2ffNikxnPlIiA84iPJHPECa/b656NbVykoZbdy9bzH7pDyOsyyg4JaD+QTg9UC6u8mrmRJdsNayKcOzUNxDbtnJAGaebwZRmL6QKjFLCyy+wJQQ+j38whmmWcfbLV4vLDCC9tM=;
X-YMail-OSG: eKJTeUcVM1n_mySuAkEg2xPIXr6ld.CWWGZ7GOj8ZP9tVbvUodk7y8xjc8tqotuWdyQS1ANwb0TQhugqnAYZyQBVRbr1RU9kEeVSVMYHAcvz06oOahA4WecrAg--
Date: Thu, 15 May 2008 19:31:31 +0100 (BST)
From: murtuja bharmal <murtuja_bharmal@yahoo.com>
Subject: Re: Kbuild Makefile output
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org, linux-kbuild <linux-kbuild@vger.kernel.org>
In-Reply-To: <20080515174222.GB24024@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Message-ID: <818830.6509.qm@web95109.mail.in2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Sam Ravnborg <sam@ravnborg.org> wrote:

> On Thu, May 15, 2008 at 11:07:19PM +0530, murtuja
> bharmal wrote:
> > Hello All.
> > I want to collect all my object file in
> onedirectory and then want to create a kernel
> module.
> > For example: This my directory structure.
> > dir
> > |
> > --------------------------------------
> > |            |        |        |
> > dir1    dir2       dir3   dir4
> > This is my makefile in 'dir'.
> > obj-m := test.o
> > test-objs += \
> >                 dir1/test1.o  \
> >                 dir2/test2.o  \
> >                 dir3/test3.o
> > all:
> >             make -C /usr/src/linux M=`pwd` modules
> > 
> > Now I want to save all output objectfile test1.o
> test2.o test3.o in one directory
> > called 'dir4' not in source directory. 'test.o'
> should look all this object file in 'dir4' for
> linking, not in the source directory and 'test.ko'
> should also be create in 'dir4'.
> > Can any one tell me, what is require changes in
> Kernel Makefile for the same.
> 
> Do not do that...
> 
> If you really need to do so - please explain why so
> we can understand the rationale.
> There are ~2000 modules that does not need this so
> what makes your maodule so special?
> 
> [Added kbuild@vger to cc as you also asked there]
> 
> 	Sam
> 

Hello Sam,

Thanks for reply.
Actually Problem is.
As I told you I have near near about 1000 file that
compiles for single module creation which spread in
multiple directies in 2.4 with lots of makefile.

Now I have created single makefile to compile all this
file and able to create kernel module.

But now the problem is lots of file included in kernel
module, compiled twice or even more then twice for
user space (whithou kernel flag set) and kernel space
as well.

Previously in 2.4 we use to put all output object file
in different directories for kernel module and user
binaries based on their compilation Flags.

Now after attaching kbuild makefile with this system,
kbuild make all object file in source directory itself
becasue of that userspace makefiles not able to
compile those file again. Because one object file is
already there by kbuild. So I am not able create
userspace binary.

Now either solution is generate kbuild object file in
different directory not in source directory as per our
previous design or make a copy of exsisting file with
some other name. One for kernel and one for user
space but this is also not a good approach.

So I thought lets check the possibility of generating
all kernel related object file in some other directory
not in source directory.
So I just want to know whether it is possible or not
and if possible how.


Thanks 
Murtuja




      Forgot the famous last words? Access your message archive online at http://in.messenger.yahoo.com/webmessengerpromo.php
