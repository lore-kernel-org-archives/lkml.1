Return-Path: <linux-kernel-owner+w=401wt.eu-S1752488AbZJWUos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488AbZJWUos (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 16:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752039AbZJWUos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 16:44:48 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:19313 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbZJWUor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 16:44:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vqiDoYzEO6nvCbH6DwMRKi4pmdKk9AAg7H1ByvnJMtQ0wjDyWRzOgvGRwlQZN3O6z4
         FQ0xamkBuO76R/bJ8of8BTGBBkkpxUsd7LeZ/yf1a9dRLzuzaAomBXUCEDsxdImJ9x7q
         wl8E/+d6ohWWg+cs6znDkYe9vQwVuJdgZU2ME=
Date: Fri, 23 Oct 2009 22:44:44 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: NiTRo <nitroml@ntd.homelinux.org>
Cc: linux-kernel@vger.kernel.org, cve@mitre.org, Pavel Machek <pavel@ucw.cz>,
       Jamie Lokier <jamie@shareable.org>
Subject: Re: SECURITY PROBLEM: filesystem permiossion bypass on FD already
 opened
Message-ID: <20091023204442.GA7332@joi.lan>
References: <4AE20B6F.4060606@ntd.homelinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AE20B6F.4060606@ntd.homelinux.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 23, 2009 at 10:00:47PM +0200, NiTRo wrote:
> Hi to all,
>     Sorry for my bad english.
>     Just discovered this security problem on my Suse 11 (Linux xxxx

You did not.
http://lkml.org/lkml/2009/10/23/159

> 2.6.25.18-0.2-pae #1 SMP 2008-10-21 16:30:26 +0200 i686 i686 i386
> GNU/Linux) and my Slackware 10.1.0 (Linux xxxx 2.4.29-ow1 #1 Wed Feb 2
> 00:05:42 CET 2005 i586 unknown unknown GNU/Linux) with OpenWall patch.
> If a FD is opened on a allowed file and then the permission is changed
> the file is still redeable starting from the already read position to
> the EOF.
> 
> This is the scenario:
> 
> <root> creates a file /tmp/aaaa with 666 permission an with the "test"
> string inside it
>         xxx:/tmp # echo test > /tmp/aaaa
>         xxx:/tmp # chmod 666 /tmp/aaaa
> <sb> opens this file hooking it in a shell as FD number 3
>         sb@xxx:~> bash 3< /tmp/aaaa
> <sb> read and prints it
>         sb@xxx:~> read a <&3
>         sb@xxx:~> echo $a
>         test
>         sb@xxx:~>
> ...anythig as expected...
> <root> changes the permissions on file to 600 and changes its content
> into "test o.o I cannot believe it..."
>         xxx:/tmp # chmod 600 /tmp/aaaa
>         xxx:/tmp # echo "test o.o I cannot believe it..." > /tmp/aaaa
> <sb> continue to try reading the file
>         sb@xxx:~> read a <&3
>         sb@xxx:~> echo $a
>         o.o I cannot believe it...
>         sb@test:~>
> ... and this is not expected...
> 
> Writing control seems to be working fine... "bash: echo: write error:
> Bad file descriptor"
> 
> Hope this can help...
> 
> Thanks to all
> Alessandro Soraruf
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
