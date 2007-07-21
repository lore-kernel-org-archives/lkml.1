Return-Path: <linux-kernel-owner+w=401wt.eu-S1751855AbXGUWZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855AbXGUWZ4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 18:25:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752736AbXGUWZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 18:25:47 -0400
Received: from barikada.upol.cz ([158.194.242.200]:41596 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbXGUWZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 18:25:46 -0400
Date: Sun, 22 Jul 2007 00:39:22 +0200
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Mike Frysinger <vapier.adi@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       kbuild-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: More effective processing (Re: [PATCH 25/33] kbuild: use POSIX BRE in headers install target)
Message-ID: <20070721223922.GO475@flower.upol.cz>
References: <118468134441-git-send-email-sam@ravnborg.org> <11846813441741-git-send-email-sam@ravnborg.org> <1184681344376-git-send-email-sam@ravnborg.org> <E1ICAEU-0005an-5F@flower> <8bd0f97a0707210127m565f9b2cnc7a8a203f671e948@mail.gmail.com> <20070721100422.GK475@flower.upol.cz> <8bd0f97a0707211221l2c7fedeoea8612876350db6d@mail.gmail.com> <20070721203916.GA2912@uranus.ravnborg.org> <20070721221627.GN475@flower.upol.cz> <20070721221326.GC2912@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070721221326.GC2912@uranus.ravnborg.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 22, 2007 at 12:13:26AM +0200, Sam Ravnborg wrote:
> On Sun, Jul 22, 2007 at 12:16:27AM +0200, Oleg Verych wrote:
> > 
> > What do you think about this one? I want to propose to remove
> > scripts/unifdef.c but to make clear policy about how to mark __KERNEL__
> > sections in header files. We know how obfuscated C can be, and this also
> > applies to preprocessing. There's known CodingStyle about some points.
> > The thing is to specify rules, that will be easy for `sed` to do cleaup
> > job.
> > 
> > ./linux/soundcard.h:#if (!defined(__KERNEL__) && !defined(KERNEL) && !defined(INKERNEL)
> >                       && !defined(_KERNEL)) || defined(USE_SEQ_MACROS)
> > ./linux/stat.h:#if defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2)
> > 
> > Split __KERNEL__ check, make only positive, i.e.
> > 
> > #if defined(__KERNEL__)
> > #ifdef __KERNEL__
> > 
> > ./linux/stat.h:#ifdef __KERNEL__
> > 
> > No `#else` and ending part to contain comment:
> > 
> > ./linux/smb_fs_sb.h:#endif /* __KERNEL__ */
> > 
> > Simple enough:
> > 
> > sed '/^#if[^_]*__KERNEL__/,/^#end[^_]*__KERNEL__/d'
> 
> What are you trying to say with the above?
> Sorry but I lost track of part of the discussion but you seems to havea point here?

I want to suggest more easy and tools-friendly way of processing header
files in the headrer_install target. One line above, one paragraph in
CodingStyle, one tree revision from KJ group.
____
