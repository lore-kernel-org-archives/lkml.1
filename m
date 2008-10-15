Return-Path: <linux-kernel-owner+w=401wt.eu-S1753955AbYJOPft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbYJOPft (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 11:35:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751757AbYJOPfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 11:35:41 -0400
Received: from gv-out-0910.google.com ([216.239.58.190]:33115 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbYJOPfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 11:35:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=ifbYZEi7TTVI5pjkBhiaIDHVsC1IJlPCS5uw0Jxl5uWjvJOcgpNZ5q7kYTshl7Yz6T
         M5geIsnzg6eP/7iv6Ko+DFAw1rQdnGUtRXb+HhGIdyojUWHa0Ok/oemftjgzVfphdm2K
         7S3LYyBuunmA1/z86u1xWPCBZ/o9rcaxVQwec=
Date: Wed, 15 Oct 2008 19:35:33 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: =?utf-8?B?0JXQstCz0LXQvdC40Lkg0JzQsNC90LDRh9C60LjQvQ==?= 
	<sfstudio@mail.ru>
Cc: linux-kernel@vger.kernel.org
Subject: Re: patch to 2.6.27 fix build rpm
Message-ID: <20081015153533.GA20222@localhost>
References: <E1Kq6yo-000PeN-00.sfstudio-mail-ru@f143.mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <E1Kq6yo-000PeN-00.sfstudio-mail-ru@f143.mail.ru>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Евгений Маначкин - Wed, Oct 15, 2008 at 08:04:02PM +0600]
| Latest working kernel version:2.6.26.6
| Distribution: any
| Hardware Environment: any
| Software Environment: any
| Problem Description: Build error from make rpm. Many unpacked files (*.fw).
| 
| Steps to reproduce: 
| 
| Add in .config:
| # CONFIG_PREVENT_FIRMWARE_BUILD is not set
| CONFIG_FW_LOADER=y
| CONFIG_FIRMWARE_IN_KERNEL=y
| CONFIG_EXTRA_FIRMWARE=""
| 
| and say make rpm to build.
| 
| This patch for file linux-2.6.27/scripts/package/mkspec is fix this problem:
| 
| 
| --- mkspec.old  2008-10-11 00:00:38.000000000 +0700
| +++ mkspec      2008-10-11 00:39:43.000000000 +0700
| @@ -64,8 +64,10 @@
|  echo "%install"
|  echo "%ifarch ia64"
|  echo 'mkdir -p $RPM_BUILD_ROOT/boot/efi $RPM_BUILD_ROOT/lib/modules'
| +echo 'mkdir -p $RPM_BUILD_ROOT/boot/efi $RPM_BUILD_ROOT/lib/firmware'
|  echo "%else"
|  echo 'mkdir -p $RPM_BUILD_ROOT/boot $RPM_BUILD_ROOT/lib/modules'
| +echo 'mkdir -p $RPM_BUILD_ROOT/boot $RPM_BUILD_ROOT/lib/firmware'
|  echo "%endif"
| 
|  echo 'INSTALL_MOD_PATH=$RPM_BUILD_ROOT make %{_smp_mflags} modules_install'
| @@ -92,5 +94,6 @@
|  echo '%defattr (-, root, root)'
|  echo "%dir /lib/modules"
|  echo "/lib/modules/$KERNELRELEASE"
| +echo "/lib/firmware"
|  echo "/boot/*"
|  echo ""
| 
| С уважением, Маначкин Е.Р.
| ________________________________________
| |Комплексные решения на базе Linux.
| |Opensource wireless routers firmware
| |www: http://wive-ng.sf.net
| |mail-to: sfstudio@mail.ru
| |ICQ: 485758428
| |JID: sfstudio-omsk@jabber.ru
| 
| 

Hi Евгений,

please use patch form described in Documentation/SubmittingPatches
(kernel source tree). Thanks.

		- Cyrill -
