Return-Path: <linux-kernel-owner+w=401wt.eu-S1755670AbYAAR1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670AbYAAR1r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 12:27:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754128AbYAAR1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 12:27:40 -0500
Received: from sandeen.net ([209.173.210.139]:14628 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753940AbYAAR1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 12:27:39 -0500
X-Greylist: delayed 1004 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Jan 2008 12:27:39 EST
Message-ID: <477A7809.5000106@sandeen.net>
Date: Tue, 01 Jan 2008 11:27:37 -0600
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: xfs-masters@oss.sgi.com
CC: LKML <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kbuild@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       viro@zeniv.linux.org.uk
Subject: Re: [xfs-masters] [Patch 7/8] FS: Remove 'TOPDIR' from Makefiles
References: <20080101071311.GA2496@hacking> <20080101074105.GH2496@hacking>
In-Reply-To: <20080101074105.GH2496@hacking>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WANG Cong wrote:
> TOPDIR is obsolete, use objtree instead.
> This patch removes TOPDIR from all fs/ Makefiles.

> diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> index 49e3e7e..d1d3d49 100644
> --- a/fs/xfs/Makefile
> +++ b/fs/xfs/Makefile
> @@ -1 +1 @@
> -include $(TOPDIR)/fs/xfs/Makefile-linux-$(VERSION).$(PATCHLEVEL)
> +include $(objtree)/fs/xfs/Makefile-linux-$(VERSION).$(PATCHLEVEL)

FWIW $(TOPDIR) is already banished from the latest xfs build code:

http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/Makefile

and the patch is in -mm too via git:

http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc6/2.6.24-rc6-mm1/broken-out/git-xfs.patch

Thanks,

-Eric

p.s. what is $(objtree) exactly?  I don't see it mentioned in
Documentation/kbuild except as one line in an example... I thought
$(obj) and $(src) should be used outside of the core kbuild
infrastructure, and in this case wouldn't it be $(src) anyway?

