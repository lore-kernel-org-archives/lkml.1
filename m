Return-Path: <linux-kernel-owner+w=401wt.eu-S1756034AbZKIQX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034AbZKIQX0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 11:23:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754930AbZKIQX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 11:23:26 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:60557 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224AbZKIQXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 11:23:25 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 22/23] sysctl arm: Remove binary sysctl support
Date: Mon, 9 Nov 2009 17:23:23 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
References: <m1pr7siqjz.fsf@fess.ebiederm.org> <200911091628.47003.arnd@arndb.de> <20091109154621.GG26740@basil.fritz.box>
In-Reply-To: <20091109154621.GG26740@basil.fritz.box>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911091723.23785.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+hyT8Xe0AkQfww8fD1XH8SyrMReMzeZMIGiqA
 iWYfCN7qDuUivczHtDfIzLINjU5zJzXvZJxGZyYrwJNe9oP5RZ
 S/AKabMnSoD0to4QLRkdQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 November 2009, Andi Kleen wrote:
> > 
> > So? Most users of old glibc are also using old kernels, and they
> 
> How do you know? At least here it's quite common to use new kernels
> with old user land.

If by 'here' you mean kernel developers, sure. Other people I'd
assume typically run whatever comes with the distro, and that
usually includes both a libc and a kernel.
 
> > can still use the  config option for the compatibility code.
> > There wouldn't even be a performance penalty over new glibc with
> > new kernels which already use procfs.
> 
> When he drops the sysctl(2) API completely the old userland will
> be unhappy.

I did not get the impression that this was the plan. Maybe I missed
something, but the work that Eric did seemed to be strategic for
leaving the code around for a really long time without causing any
maintainance pain that the current code does.

It will be years before we can really remove that code, but distros
can start disabling it (or making it modular) earlier than that
when they feel the time has come to stop support for static binaries
using sysctl (there should really be few of those).

> > > I just think you should have two flavours of emulation layer:
> > > full and "common sysctls". This can be probably done with the same
> > > code and some strategic ifdefs.
> > 
> > If it's just about code size, I totally wouldn't bother. Just put the
> > emulation code in loadable module and add a 'printk("Warning, %s is
> > using sysctl %s, wasting %d kb of kernel memory")' to it's module_init
> > function.
> 
> That means non modular kernels can't support old userland.

Well, non-modular kernels are rather rare and they can still have the
code builtin. It's not something I'd put a lot of work optmizing for
though. I'd guess that most uses of non-modular kernels also come with
a pretty much fixed set of supported binaries.

	Arnd <><
