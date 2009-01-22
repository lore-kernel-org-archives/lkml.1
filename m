Return-Path: <linux-kernel-owner+w=401wt.eu-S1758519AbZAVTlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758519AbZAVTlq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 14:41:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752527AbZAVTlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 14:41:35 -0500
Received: from lazybastard.de ([212.112.238.170]:48470 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406AbZAVTlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 14:41:35 -0500
Date: Thu, 22 Jan 2009 20:41:26 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Detailed Stack Information Patch [0/3]
Message-ID: <20090122194126.GA5352@logfs.org>
References: <1232446597.784.15.camel@matrix>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1232446597.784.15.camel@matrix>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 January 2009 11:16:37 +0100, Stefani Seibold wrote:
> 
> this is a patch which give you a better overview of the userland
> application stack usage, especially for embedded linux.
> 
> Currently you are only able to dump the main process/thread stack usage
> which is showed in proc/pid/status by the "VmStk" Value. But you get no
> information about the consumed stack memory of the the threads.
>
> [...]
> 
> This patch is against 2.6.28.1. The patch is cpu independent, so it
> should work on all linux supported architectures, it was tested under
> x86 and powerpc. Also there is not dependency a library: glibc, uclibc
> and all other should work.
> 
> I hope you like it and want ask what is necessary for inclusion into the
> main stream kernel or linux-next? If you have ideas how to do things in
> a better way, please let me know.

First goal would be to get people interested.  Why would Joe
Kernelhacker care about this, what problem would it solve for him?  Next
goal is to prove to akpm that the solved problems are worth the
maintenance burden this code brings.

It would be nice to have diffstat added to each patch to give people
a quick overview.  More importantly, the number of #ifdef's in the
patches may raise a red flag.  You should try to remove them from common
code and have a single one in the headers:

#ifdef CONFIG_NEW_FEATURE

void handle_this(int foo, long bar);

#else

static inline void handle_this(int foo, long bar)
{
}
#endif

Not sure what else to say.  I'm still wondering whether it will solve a
problem for me.

Jörn

-- 
Joern's library part 4:
http://www.paulgraham.com/spam.html
