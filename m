Return-Path: <linux-kernel-owner+w=401wt.eu-S1757415AbYAIBRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757415AbYAIBRU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 20:17:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752225AbYAIBRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 20:17:10 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:56255 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927AbYAIBRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 20:17:08 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Michal Simek <simekm2@fel.cvut.cz>
Subject: Re: New linux arch
Date: Wed, 9 Jan 2008 02:16:55 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org, monstr@monstr.eu
References: <47820D24.3060800@fel.cvut.cz>
In-Reply-To: <47820D24.3060800@fel.cvut.cz>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801090216.55958.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+xTWhF32Q1sgX1A4t65Ir5NBaib5Jb0ftYHO1
 OceZGtHmY5HUGnMe7xkOElMbwEMMzqp7oR7+rUXZw+OCVZE1ZZ
 salmVn8SCyeOFZoLkJ60g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 January 2008, Michal Simek wrote:
> I would like to ask you what is the best way to push these changes to 
> kernel.org.
> 
> I would like to know step by step how to do.
> 

Adding the whole architecture tree will probably be too much for
a single reviewer and almost certainly too much for a the size limit
of mails to lkml.
On the other hand, there is not much point in merging the architecture
code in multiple changesets if there is nothing at all you can do
with part of it. I suggest therefore that you split the code twice:

First, split every device driver into its own git changeset. Often,
these have to go through a different set of mailing lists, e.g.
network drivers go to netdev@vger.kernel.org (see MAINTAINERS for
details), while the actual architecture changeset should not have
device drivers by itself. These are going to be the changesets
that you have in your git tree and merged upstream eventually.

Then, split each of those changesets into reviewer-friendly
chunks of less than 100kb. Don't worry if a patch ends up only having
a few line while others are considerably larger.
For people that like to see a whole changeset, upload it as a combined
patch to an http location that you mention in your patch 00/12 or so,
and have the smaller patches as reply mails to that.
Use either 'quilt mail' or 'git-format-patch' to do that work for you.

I think blackfin is a good example of how an architecture got merged,
and how they resolved the initial problems. Read through the comments
at http://lkml.org/lkml/2006/9/20/404 and related mails to see what
can go wrong in such large projects and how to do it better.

Regarding the code itself, my assumption is that you started out
copying from another architecture (everyone does that) and hacked on
it until you had it working. This is not wrong by itself, but it would
be really nice if we can make it easier for the next person to
add an architecture. My vision is that for each header file you
copied from include/asm-i386 or similar and did not end up rewriting,
you create a version in include/asm-generic and start using that
instead of adding a private copy in your architecture.
One example where this was already done is <asm/errno.h>, an example
where you should do it is <asm/stat.h>.
It's similar for files like arch/microblaze/kernel/sys.c and pci.c:
ideally, you shouldn't have these at all, but be able to just
use completely generic code.

	Arnd <><
