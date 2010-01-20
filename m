Return-Path: <linux-kernel-owner+w=401wt.eu-S1754865Ab0ATD0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865Ab0ATD0y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 22:26:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754814Ab0ATD0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 22:26:53 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:64618 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708Ab0ATD0w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 22:26:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DvmealXbKIadbbQ2rGAr2XVABx+gotGmcWL7ikps9ZZl7BJ4w2Y0LzzpYsbURILfSB
         sP2pZWaLj3SCBGm7IIQQ6ruiI8jVYo0q+lzNj406PZWaQgHGkYls03K7qqvLHYx3mfur
         HLFcd7pkFLmRZDHIoOHXHYPmAxvF208Jb4XH4=
MIME-Version: 1.0
In-Reply-To: <d65b1b151001191029o66794c24t228177a8ca544e44@mail.gmail.com>
References: <d65b1b151001191029o66794c24t228177a8ca544e44@mail.gmail.com>
Date: Wed, 20 Jan 2010 11:26:51 +0800
Message-ID: <2375c9f91001191926hc80dc50mb264f757295c1337@mail.gmail.com>
Subject: Re: [PATCH] Use full path to dnsdomainname and domainname in 
	scripts/mkcompile_h
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Glenn Sommer <glemsom@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 20, 2010 at 2:29 AM, Glenn Sommer <glemsom@gmail.com> wrote:
> With reference to: http://bugzilla.kernel.org/show_bug.cgi?id=14920
> I'll post my suggestion here.
>
> Currently scripts/mkcompile_h checks for "/bin/dnsdomainname" and
> "/bin/domainname" when trying to find the DNS name.
> Though, when running the executable - the full path isn't used!
>
> IMO if we check for "/bin/dnsdomainname", we should also use
> "/bin/dnsdomainname" - and not blindly trust /bin is the first directory in
> $PATH  which contains a executable named "dnsdomainname"
>
>
> I propose to use the full path, that we know is valid. Here's my proposed patch:
>
>
> --- scripts/mkcompile_h.orig    2009-12-28 23:02:34.000000000 +0100
> +++ scripts/mkcompile_h 2009-12-28 23:03:12.000000000 +0100
> @@ -66,9 +66,9 @@
>   echo \#define LINUX_COMPILE_HOST \"`hostname | $UTS_TRUNCATE`\"
>
>   if [ -x /bin/dnsdomainname ]; then
> -    echo \#define LINUX_COMPILE_DOMAIN \"`dnsdomainname | $UTS_TRUNCATE`\"
> +    echo \#define LINUX_COMPILE_DOMAIN \"`/bin/dnsdomainname | $UTS_TRUNCATE`\"
>   elif [ -x /bin/domainname ]; then
> -    echo \#define LINUX_COMPILE_DOMAIN \"`domainname | $UTS_TRUNCATE`\"
> +    echo \#define LINUX_COMPILE_DOMAIN \"`/bin/domainname | $UTS_TRUNCATE`\"
>   else
>     echo \#define LINUX_COMPILE_DOMAIN
>   fi
>
>
> Signed-off-by: Glenn Sommer <glemsom@gmail.com>

Makes sense, but is that possible we have 'domainname' installed in two
different directories?
