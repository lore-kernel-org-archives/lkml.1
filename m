Return-Path: <linux-kernel-owner+w=401wt.eu-S1765299AbYDVPNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765299AbYDVPNa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 11:13:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756805AbYDVPNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 11:13:10 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:32490 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765188AbYDVPNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 11:13:07 -0400
Date: Tue, 22 Apr 2008 08:12:11 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Will Newton" <will.newton@gmail.com>
Cc: "Linux Kernel list" <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org
Subject: Re: [RFC] Introduce __ARCH_WANT_SYS_SYSFS
Message-Id: <20080422081211.e85989ec.randy.dunlap@oracle.com>
In-Reply-To: <87a5b0800804220513t75690ceao938a288596b5ad0c@mail.gmail.com>
References: <87a5b0800804220513t75690ceao938a288596b5ad0c@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Apr 2008 13:13:39 +0100 Will Newton wrote:

> Hi,
> 
> This patch introduces a __ARCH_WANT_SYS_SYSFS #define for
> architectures that support the sysfs(2) system call. At the moment
> that's everybody but blackfin, but future architectures may want to
> save the (admittedly small) code size that it adds to the kernel as
> well.
> 
> (patch attached as well as inline because gmail seems to mangle my whitespace)
> 
> ---
> >From d0746366e8ccb5fbaa6c9945540cecbe0c421222 Mon Sep 17 00:00:00 2001
> From: Will Newton <will.newton@imgtec.com>
> Date: Tue, 22 Apr 2008 12:57:03 +0100
> Subject: [PATCH] Introduce __ARCH_WANT_SYS_SYSFS.
> 
> Signed-off-by: Will Newton <will.newton@imgtec.com>
> 
> All arches that want the sysfs(2) system call should define this symbol.
> Arches such as blackfin that do not implement the system call don't compile
> the code and save some small amount of space.

Is there any reason that this couldn't (and shouldn't) be done
in the Kconfig space and done as documented in
Documentation/kbuild/kconfig-language.txt ?

<quote:>
Adding common features and make the usage configurable
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
It is a common idiom to implement a feature/functionality that are
relevant for some architectures but not all.
The recommended way to do so is to use a config variable named HAVE_*
that is defined in a common Kconfig file and selected by the relevant
architectures.
An example is the generic IOMAP functionality.

We would in lib/Kconfig see:

# Generic IOMAP is used to ...
config HAVE_GENERIC_IOMAP

config GENERIC_IOMAP
	depends on HAVE_GENERIC_IOMAP && FOO

And in lib/Makefile we would see:
obj-$(CONFIG_GENERIC_IOMAP) += iomap.o

For each architecture using the generic IOMAP functionality we would see:

config X86
	select ...
	select HAVE_GENERIC_IOMAP
	select ...



---
~Randy
