Return-Path: <linux-kernel-owner+w=401wt.eu-S1753527AbYJORrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527AbYJORrg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 13:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755093AbYJORrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 13:47:21 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:53330 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754875AbYJORrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 13:47:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=N26/cq8BfldVukPSAqUOOccJIy50OgBypzDLIHQwFQ2MFEHgjXwByRZv7MZnJZ77xE
         nFHGF7VKYuh2lUPkSgUndTSa8we9NMbI4I81OySy5ZDJg8Hs/pFzeMgtYY1E9AxIwoXq
         1Mbhr3BL/EDohek1tFPWUotn7XaL3gjmS6T5I=
Date: Wed, 15 Oct 2008 21:47:15 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: =?utf-8?B?0JXQstCz0LXQvdC40Lkg0JzQsNC90LDRh9C60LjQvQ==?= 
	<sfstudio@mail.ru>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Re: Re: patch to 2.6.27 fix build rpm
Message-ID: <20081015174715.GA768@localhost>
References: <20081015172412.GB20222@localhost> <E1KqAJK-000KWz-00.sfstudio-mail-ru@f121.mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <E1KqAJK-000KWz-00.sfstudio-mail-ru@f121.mail.ru>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Евгений Маначкин - Wed, Oct 15, 2008 at 11:37:26PM +0600]
| From: Evgeniy Manachkin <sfstudio@mail.ru>
| Subject: [PATCH] mkspec - fix build rpm
| 
| This is patch to fix incorrect mkspec script to make rpm correctly at 2.6.27 vanilla kernel. This is regression in 2.6.27. 2.6.26 make rpm work good.
| In 2.6.27 'make rpm' say error from rpmbuild "Many unpacked files (*.fw)." 
| This is patch fix it this error.
| 
| Sorry my English.
| 
| Signed-off-by: Evgeniy Manachkin <sfstudio@mail.ru>
| 
|  --- linux-2.6.27/scripts/package/mkspec.orig    2008-10-11 00:00:38.000000000 +0700
|  +++ linux-2.6.27/scripts/package/mkspec 2008-10-11 00:39:43.000000000 +0700
|  @@ -64,8 +64,10 @@ fi
|   echo "%install"
|   echo "%ifarch ia64"
|   echo 'mkdir -p $RPM_BUILD_ROOT/boot/efi $RPM_BUILD_ROOT/lib/modules'
|  +echo 'mkdir -p $RPM_BUILD_ROOT/boot/efi $RPM_BUILD_ROOT/lib/firmware'
|   echo "%else"
|   echo 'mkdir -p $RPM_BUILD_ROOT/boot $RPM_BUILD_ROOT/lib/modules'
|  +echo 'mkdir -p $RPM_BUILD_ROOT/boot $RPM_BUILD_ROOT/lib/firmware'
|   echo "%endif"
|  
|   echo 'INSTALL_MOD_PATH=$RPM_BUILD_ROOT make %{_smp_mflags} modules_install'
|  @@ -92,5 +94,6 @@ echo "%files"
|   echo '%defattr (-, root, root)'
|   echo "%dir /lib/modules"
|   echo "/lib/modules/$KERNELRELEASE"
|  +echo "/lib/firmware"
|   echo "/boot/*"
|   echo ""
| 

Much better thanks! Lets wait for LKML feedback.

P.S.
As I see you use Mail.ru web interface for patch submission
unfortunately it's not goot -- better use Thunderbird or something
like that since mPOP does mangle tabulators. There was some doc about
how to configure mail clients but I don't remember where is it (maybe
somewhere inside Documentations :-)

		- Cyrill -
