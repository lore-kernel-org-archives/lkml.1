Return-Path: <linux-kernel-owner+w=401wt.eu-S1751360AbZHXDwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751360AbZHXDwv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 23:52:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751276AbZHXDwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 23:52:50 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:62765 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbZHXDwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 23:52:50 -0400
Date: Sun, 23 Aug 2009 20:52:05 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Amerigo Wang <xiyou.wangcong@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, torvalds@linux-foundation.org,
       bunk@kernel.org
Subject: Re: [PATCH] scripts/ver_linux
In-Reply-To: <alpine.DEB.2.01.0908162250450.30417@bogon.housecafe.de>
Message-ID: <alpine.DEB.2.01.0908232044190.5744@bogon.housecafe.de>
References: <alpine.DEB.2.01.0908132251000.30417@bogon.housecafe.de> <20090817054732.GK5039@cr0.nay.redhat.com> <alpine.DEB.2.01.0908162250450.30417@bogon.housecafe.de>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX19is8NLdqYZ8VnoehJyLgH8PQS3H8ZiFe3S3nv
 QXHRsjRnM/TPdLMR8ZT5XHEVEZmvr4RAJIwkU4uQLDIPztxKnb
 /A/7aW15ORP7ndyAmFJvg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Aug 2009 at 22:54, Christian Kujau wrote:
> On Mon, 17 Aug 2009 at 13:47, Amerigo Wang wrote:
> > Hmm, so probably you are also using a Red Hat distribution?
> > AFAIK, only some Fedora and RHEL don't have /sbin and /usr/sbin in $PATH.
> 
> No, Debian Linux - but as a mere user I never have sbin directories in my 
> PATH. And since it is a headless system, I removed the console-* packages, 
> that's why I did not have the "loadkeys" command installed. No big deal, 
> but the ver_linux output looked weird....

Hm, looking at the changelog of scripts/ver_linux again I see:

 > commit 48a61569bb5396415c5dad0e81e1cfeb87c0aca3
 > Author: Adrian Bunk <bunk@kernel.org>
 > Date:   Wed Jul 23 22:50:45 2008 +0300
 > 
 >  kbuild: scripts/ver_linux: don't set PATH
 >
 >  It would have saved both a bug submitter and me a few hours if
 >  scripts/ver_linux had picked the same gcc as the build.
 >
 >  Since I can't see any reason why it fiddles with PATH at all this 
 > patch therefore removes the PATH setting.

I'm still a bit confused, Amerigo, why you thought not having /sbin
directories in PATH was distribution specific - I don't recall any 
distribution where mere users had /sbin:/usr/sbin in their PATH.
I was tempted to specify the whole path in ver_linux, but that'll break 
for sure. 

Adrian, what do you think - this patch puts the sbin paths *after*
PATH, so that should not lead to such conflicts your commit once fixed, 
right?

Christian.

--- linux-2.6-git/scripts/ver_linux.orig	2009-08-14 07:47:12.185695350 +0200
+++ linux-2.6-git/scripts/ver_linux	2009-08-14 07:47:23.642348227 +0200
@@ -4,6 +4,7 @@
 # /bin /sbin /usr/bin /usr/sbin /usr/local/bin, but it may
 # differ on your system.
 #
+PATH="$PATH":/sbin:/usr/sbin
 echo 'If some fields are empty or look unusual you may have an old version.'
 echo 'Compare to the current minimal requirements in Documentation/Changes.'
 echo ' '
@@ -76,7 +77,7 @@ ifconfig --version 2>&1 | grep tools | a
 
 # Kbd needs 'loadkeys -h',
 loadkeys -h 2>&1 | awk \
-'(NR==1 && ($3 !~ /option/)) {print "Kbd                   ", $3}'
+'(NR==1 && ($1 = /^loadkeys/)) {print "Kbd                   ", $3}'
 
 # while console-tools needs 'loadkeys -V'.
 loadkeys -V 2>&1 | awk \
-- 
BOFH excuse #75:

There isn't any problem
