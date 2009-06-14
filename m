Return-Path: <linux-kernel-owner+w=401wt.eu-S1755324AbZFNHUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324AbZFNHUr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 03:20:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754746AbZFNHTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 03:19:55 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:47489 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049AbZFNHTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 03:19:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Nmh5ynYNA12jLxLSBwI+meVJ6APuIdyXAoZepvUICCvzP5lPbRPPVwY6f+KmYqjGHd
         Jg/ZHqKOkvy/3JIUi0hA0r7rdn9M62CLGdaboeToqsQYvARhpObGSbvOvnppQRSxx14T
         jnkQI0Hn2LstDImvoPHdELCkHKy+9NZ9zXkss=
Message-ID: <4A34A3AF.5060900@gmail.com>
Date: Sun, 14 Jun 2009 09:15:59 +0200
From: Marco <marco.stornelli@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Daniel Walker <dwalker@soe.ucsc.edu>
Subject: Re: [PATCH 08/14] Pramfs: Makefile and Kconfig
References: <4A33A802.8040507@gmail.com> <20090613135604.GB30053@uranus.ravnborg.org>
In-Reply-To: <20090613135604.GB30053@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
>> +
>> +config PRAMFS_NOWP
>> +	bool "Disable PRAMFS write protection"
>> +	depends on PRAMFS
>> +	default n
>> +	help
>> +	   Say Y here to disable the write protect feature of PRAMFS.
> n is default so "default n" is not needed.
> If you reverse the logic (and add a default y) then..
> 
>> +ifneq ($(CONFIG_PRAMFS_NOWP),y)
>> +pramfs-objs += wprotect.o
>> +endif
> This is a trivial:
> pramfs-$(PRAMFS_WRITE_PROTECT) += wprotect.o
> 
> (I renamed the option to something more descriptive - please do so in the abvoe).
> 
> 
>> +++ linux-2.6.30/fs/pramfs/Makefile	2009-04-19 11:58:51.000000000 +0200
>> @@ -0,0 +1,13 @@
>> +#
>> +# Makefile for the linux pram-filesystem routines.
>> +#
>> +
>> +obj-$(CONFIG_PRAMFS) += pramfs.o
>> +obj-$(CONFIG_TEST_MODULE) += pramfs_test.o
>> +
>> +pramfs-objs := balloc.o dir.o file.o inode.o namei.o super.o symlink.o
> 
> Use:
> pramfs-y := balloc.o ...
> 
> This match usa later in this file.
> 
>> +
>> +ifneq ($(CONFIG_PRAMFS_NOWP),y)
>> +pramfs-objs += wprotect.o
>> +endif
>> +pramfs-$(CONFIG_PRAMFS_XIP) += xip.o
> 
> 
> 	Sam
> 

Ok, thanks.

Marco


