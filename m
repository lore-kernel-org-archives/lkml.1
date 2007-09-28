Return-Path: <linux-kernel-owner+w=401wt.eu-S1756150AbXI1VqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150AbXI1VqV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 17:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754677AbXI1VqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 17:46:08 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:30906 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753681AbXI1VqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 17:46:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=OhW4436CsZ/uqPgGbCwCgSBRMhNZ7LkQZ3QU09PBWWZy2zGnhWQqq3+7H+e/QxcNOn/UbPDD3KOVobJMJMxy/mxrl1g4LB+ULN6e3Q5MDHmQqx4sfl+RKlDXF1vSt5jD5xGwB6QZjaKYHgQmBYGmBDIC4tQEtIPSrhBdIxpIUYQ=  ;
X-YMail-OSG: 4QCjowEVM1lWPcJvJu_FheoC_VQeu0yzbLnrCw.u.b9r1Vq8XmFMLMKuLHWSCu5yr37wCWSQJIviVEa6xFeN13R6uM8vM94kVBxaayMrr16Wc3rJOgg-
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: "Sergey Popov" <faijeya@gmail.com>
Subject: Re: General slowness with using 64Gb HIGHMEM option on 32-bit kernel
Date: Fri, 28 Sep 2007 13:22:44 +1000
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <dd4eba420709281015w50bd6b0fj21f72756a962a26b@mail.gmail.com>
In-Reply-To: <dd4eba420709281015w50bd6b0fj21f72756a962a26b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709281322.44864.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 29 September 2007 03:15, Sergey Popov wrote:
> Short description: after recompiling 32-bit kernel with 64Gb highmem
> support and rebooting into it, OS started working very much slower
> then before.
>
> Specifications: Intel Core 2 Duo E6600@2,4Ghz on Intel i965Q-based
> motherboard. 6Gb of DDR2 RAM, 2x1Gb+2x2Gb, dual-channel.
> Vector Linux 5.8 (Slackware Linux 11-based), 2.6.20.3 kernel.
>
> Long description: after recompiling 32-bit 2.6.20.3 kernel with 64Gb
> highmem option and rebooting into it, booting process froze on udevd.
> After booting up from CD and disabling rc.udev, system started, but
> it's work after rc.M script sarted was 5-10 times slower then usual.
> top showed, that processes are taking much more CPU% time then usual.
> I tried downloading the newest stable kernel - 2.6.22.9 - hoping, that
> it would solve the problem. I downloaded it, booted from CD, and
> compiled it with 64Gb highmem support. I felt some speed improvement,
> but if on 2.6.20.3 machine performed like P166, now it is working like
> P2-350.
> I've found a similar problem, described on lkml -
> http://lkml.org/lkml/2007/5/30/5 . But, unfortunately, it is x86_64
> related and contains no clues for me.

It's most likely the MTRR problem that Rik mentioned.


> Moving to 64-bit distro is rather unpleasant - as there is an option
> in 32-bit kernel, it should work ;) .

If you have a gcc that can compile 64-bit code, then I found it was as
simple as doing a 'make ARCH=x86_64' and building the kernel with 32-bit
program support.
