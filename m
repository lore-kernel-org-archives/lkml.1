Return-Path: <linux-kernel-owner+w=401wt.eu-S1760087AbYEUSgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760087AbYEUSgu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 14:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755059AbYEUSgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 14:36:40 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:59147 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755162AbYEUSgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 14:36:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=ViewqTO1Dx9dAIV8CYHT7RNazhMiWciMHce1k2SNQ3ALGJyx3AO7wUuoWwfbtsFpUuyEEtbpwlN6o4zcjVmsn6+QC4swSL7cOWai2poEeccMiCrn7aixBTx1bkptzO1KuDtJ/4wkeF7DeDR9EzxLysO9IVazQzmFmoirynQ3MDE=
Message-ID: <48346BA3.2050806@googlemail.com>
Date: Wed, 21 May 2008 20:36:19 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Linux Kernel list <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] scripts/ver_linux use 'gcc -dumpversion'
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


These magic greps and hacks in ver_linux to get the gcc version always break after some gcc releases.

Since now gcc >4.3 allows compiling with '--with-pkgversion' ( which can be everything 'My Cool Gcc' or something )
ver_linux will report random junk for these.

Simply use 'gcc -dumpversion' to get the gcc version which should always work.

Signed-off-by: Gabriel C <nix.or.die@googlemail.com>
---

Andrew sorry to bug you about that but
I have no clue how is maintaining scripts/*

 scripts/ver_linux |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/scripts/ver_linux b/scripts/ver_linux
index ab69ece..7ac0e30 100755
--- a/scripts/ver_linux
+++ b/scripts/ver_linux
@@ -12,12 +12,9 @@ echo ' '
 uname -a
 echo ' '
 
-gcc --version 2>&1| head -n 1 | grep -v gcc | awk \
+gcc -dumpversion 2>&1| awk \
 'NR==1{print "Gnu C                 ", $1}'
 
-gcc --version 2>&1| grep gcc | awk \
-'NR==1{print "Gnu C                 ", $3}'
-
 make --version 2>&1 | awk -F, '{print $1}' | awk \
       '/GNU Make/{print "Gnu make              ",$NF}'
 



