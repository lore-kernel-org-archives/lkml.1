Return-Path: <linux-kernel-owner+w=401wt.eu-S1761156AbYFCUsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761156AbYFCUsu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 16:48:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754440AbYFCUqC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 16:46:02 -0400
Received: from fk-out-0910.google.com ([209.85.128.186]:58232 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760557AbYFCUp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 16:45:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lzLcbVhLU2QR/GB8rP8UwgvpXN+1X/DWGKiZtq+7pcSmR3rBzVjrstuRLGdq+Ews699CVyCTdUXpLrzYuLN7gRcZl60pso+KTB9q0FsZ07zjJ9r/c09QjvLiO07OsjaYO8miJzooKLrSH9xq+S/FLXXhh6Eb6Jd5ezTe88GuYSg=
Message-ID: <21d7e9970806031345u4e7838fdp60bbedadd65b5f2a@mail.gmail.com>
Date: Wed, 4 Jun 2008 06:45:57 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Mikael Pettersson" <mikpe@it.uu.se>
Subject: Re: [BUG] 2.6.26-rc1 broke X on SPARC Ultra5
Cc: "David Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <18501.39659.952880.727014@alkaid.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <18500.62552.958244.633204@harpo.it.uu.se>
	 <20080603.062253.17158135.davem@davemloft.net>
	 <18501.39659.952880.727014@alkaid.it.uu.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  >
>  > > Fatal server error:
>  > > xf86MapPciMem: Could not mmap PCI memory [base=0xe2000000,hostbase=0xe2000000,size=2000] (No such file or directory)
>  > >
>  > > I'll start digging through 2.6.25->2.6.26-rc1 later today,
>  > > meanwhile I've put Xorg.0.log, Xorg strace, dmesg, and .config
>  > > files for 2.6.25 (working) and 2.6.26-rc4 (failing) in
>  > > <http://user.it.uu.se/~mikpe/linux/sparc64-2.6.26-rcN-xorg-bug/>.
>  >
>  > It's likely this change below.  Unfortunately older versions of X
>  > seemingly cannot cope with a lack of PCI host controller in the PCI
>  > hierarchy exported by the kernel.
>  >
>  > That's really a bug in X, current libpciaccess based X servers work
>  > fine, and the bug fixed by this changeset is not solvable in any other
>  > reasonable way.  So unfortunately older X verions will stay not
>  > working.  Sorry.
>  >
>  > commit c26d3c0138970778fabe114df99dffb34a04b1d7
>  > Author: David S. Miller <davem@davemloft.net>
>  > Date:   Thu May 1 01:12:40 2008 -0700
>
> Confirmed. Reverting this patch from 2.6.26-rc1 made my Xorg-7.1.1 work again.
>
> It's a shame though that a bug fix needs to have such draconian consequences.
>

Wow thats a major userspace regression to ship, we'd never get away
with doing that on x86 platforms.

Dave.
