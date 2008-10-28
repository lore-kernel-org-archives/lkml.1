Return-Path: <linux-kernel-owner+w=401wt.eu-S1753250AbYJ1JMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250AbYJ1JMW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 05:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751883AbYJ1JMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 05:12:14 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:46442 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751495AbYJ1JMM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 05:12:12 -0400
Date: Tue, 28 Oct 2008 18:11:36 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Nobuhiro Iwamatsu <iwamatsu@nigauri.org>, linux-kernel@vger.kernel.org,
       Linux-sh <linux-sh@vger.kernel.org>
Subject: Re: [PATCH] gdrom: Fix compile error
Message-ID: <20081028091136.GB24850@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Nobuhiro Iwamatsu <iwamatsu@nigauri.org>,
	linux-kernel@vger.kernel.org, Linux-sh <linux-sh@vger.kernel.org>
References: <29ab51dc0810261932n7580e87aua85103f8b1dcc5a5@mail.gmail.com> <20081027040814.GQ28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081027040814.GQ28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2008 at 04:08:15AM +0000, Al Viro wrote:
> On Mon, Oct 27, 2008 at 11:32:27AM +0900, Nobuhiro Iwamatsu wrote:
> > Return value and argument of block_device_operations.release of gdrom
> > was changed.
> > This patch fix this problem.
> 
> Serves me right for snide comments about the benefits of compile-testing ;-)
> ACKed-by: Al Viro <viro@zeniv.linux.org.uk>
> 
Thanks, applied.

> FWIW, sh/sh64 is the only cross-toolchain needed for the kernel I hadn't
> managed to build - 4.3.0 gcc manages to trigger internal error in sh64 as(1)
> (2.18.50.0.6) and AFAICS the same should happen with any binutils up to
> -HEAD (the minimal testcase is
>         .text
> .LFB2:
>         .section        .eh_frame,"a",@progbits
>         .quad   .LFB2-.
> and sh64 gcc4.3 routinely produces such things in its output).  gcc trunk
> seems to have arseloads of changes in gcc/config/sh and I hadn't got around
> to attempting a backport ;-/
> 
The sh64 gcc is very volatile, finding a combination that works reliably
tends to take a fair bit of effort and random guesswork. The most recent
working one that has been tested is a combination of GCC 4.1.2 and
binutils 2.17. Gentoo's crossdev is capable of building this combination
out of the box.

> Are there any public sh/sh64 toolchains based on not too heavily hacked
> gcc/binutils, ideally for more or less recent variants of both?

I've placed a couple of binary toolchains on userweb:

	http://userweb.kernel.org/~lethal/toolchains/

http://userweb.kernel.org/~lethal/toolchains/gnush4_linux_v0801-test-1-1.i386.tar.gz
in particular is what is most widely used for sh at present, and is a gcc
4.2.1 and binutils 2.17.50 combination. There are not too many deviations
from mainline there however, so most recent combinations should be
buildable. I don't believe anyone has looked at gcc 4.3.0 yet though.
