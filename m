Return-Path: <linux-kernel-owner+w=401wt.eu-S1753195AbZAVVgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195AbZAVVgf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 16:36:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752676AbZAVVgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 16:36:25 -0500
Received: from www84.your-server.de ([213.133.104.84]:38572 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527AbZAVVgY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 16:36:24 -0500
Subject: Re: Detailed Stack Information Patch [0/3]
From: Stefani Seibold <stefani@seibold.net>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20090122194126.GA5352@logfs.org>
References: <1232446597.784.15.camel@matrix>
	 <20090122194126.GA5352@logfs.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 22 Jan 2009 22:39:28 +0100
Message-Id: <1232660368.9652.18.camel@matrix>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 8BIT
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First, i had explained what is the reason for the patch.

Second, the number of #ifdef is not more or less than other features
which extends the task_struct on demand.

There is no way to do this without #ifdef's, only if i add this feature
without a CONFIG_.... option.

I think the main reason why i get low responses is, because i posted it
to the wrong mail list. kernel-mm would be a better place for this.

So i will wait until 2.6.29 is out, then move my patch to this version,
enhance it, add a diffstat and try it again which are more detailed
reason why this patch should be included.

But this patch did nit solve a problem, it is a feature like
PROC_PAGE_MONITOR or similar. It will help to figure out, how much stack
will be consumed by a particular process or thread.

It also not a patch which cares Joe Kernelhacker, it cares Jane
Userlandhacker!

Thnx,
Steffi

Am Donnerstag, den 22.01.2009, 20:41 +0100 schrieb Jörn Engel:
> On Tue, 20 January 2009 11:16:37 +0100, Stefani Seibold wrote:
> > 
> > this is a patch which give you a better overview of the userland
> > application stack usage, especially for embedded linux.
> > 
> > Currently you are only able to dump the main process/thread stack usage
> > which is showed in proc/pid/status by the "VmStk" Value. But you get no
> > information about the consumed stack memory of the the threads.
> >
> > [...]
> > 
> > This patch is against 2.6.28.1. The patch is cpu independent, so it
> > should work on all linux supported architectures, it was tested under
> > x86 and powerpc. Also there is not dependency a library: glibc, uclibc
> > and all other should work.
> > 
> > I hope you like it and want ask what is necessary for inclusion into the
> > main stream kernel or linux-next? If you have ideas how to do things in
> > a better way, please let me know.
> 
> First goal would be to get people interested.  Why would Joe
> Kernelhacker care about this, what problem would it solve for him?  Next
> goal is to prove to akpm that the solved problems are worth the
> maintenance burden this code brings.
> 
> It would be nice to have diffstat added to each patch to give people
> a quick overview.  More importantly, the number of #ifdef's in the
> patches may raise a red flag.  You should try to remove them from common
> code and have a single one in the headers:
> 
> #ifdef CONFIG_NEW_FEATURE
> 
> void handle_this(int foo, long bar);
> 
> #else
> 
> static inline void handle_this(int foo, long bar)
> {
> }
> #endif
> 
> Not sure what else to say.  I'm still wondering whether it will solve a
> problem for me.
> 
> Jörn
> 

