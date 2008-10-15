Return-Path: <linux-kernel-owner+w=401wt.eu-S1755314AbYJOS4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314AbYJOS4Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 14:56:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752181AbYJOS4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 14:56:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40074 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbYJOS4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 14:56:17 -0400
Message-ID: <48F63CC6.8060306@zytor.com>
Date: Wed, 15 Oct 2008 11:56:06 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: =?UTF-8?B?0JXQstCz0LXQvdC40Lkg0JzQsNC90LDRh9C60LjQvQ==?= 
	<sfstudio@mail.ru>
CC: gorcunov@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: patch to 2.6.27 fix build rpm
References: <20081015172412.GB20222@localhost> <E1KqAJK-000KWz-00.sfstudio-mail-ru@f121.mail.ru>
In-Reply-To: <E1KqAJK-000KWz-00.sfstudio-mail-ru@f121.mail.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Евгений Маначкин wrote:
> 
>  --- linux-2.6.27/scripts/package/mkspec.orig    2008-10-11 00:00:38.000000000 +0700
>  +++ linux-2.6.27/scripts/package/mkspec 2008-10-11 00:39:43.000000000 +0700
>  @@ -64,8 +64,10 @@ fi
>   echo "%install"
>   echo "%ifarch ia64"
>   echo 'mkdir -p $RPM_BUILD_ROOT/boot/efi $RPM_BUILD_ROOT/lib/modules'
>  +echo 'mkdir -p $RPM_BUILD_ROOT/boot/efi $RPM_BUILD_ROOT/lib/firmware'
>   echo "%else"
>   echo 'mkdir -p $RPM_BUILD_ROOT/boot $RPM_BUILD_ROOT/lib/modules'
>  +echo 'mkdir -p $RPM_BUILD_ROOT/boot $RPM_BUILD_ROOT/lib/firmware'
>   echo "%endif"
>  

Wouldn't:

echo 'mkdir -p $RPM_BUILD_ROOT/boot'
echo 'mkdir -p $RPM_BUILD_ROOT/lib/modules'
echo 'mkdir -p $RPM_BUILD_ROOT/lib/firmware'
echo "%ifarch ia64"
echo 'mkdir -p $RPM_BUILD_ROOT/boot/efi'
echo '%endif'

... be better?

	-hpa
