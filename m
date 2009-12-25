Return-Path: <linux-kernel-owner+w=401wt.eu-S1757345AbZLYXhH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345AbZLYXhH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 18:37:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756530AbZLYXhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 18:37:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57424 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756484AbZLYXhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 18:37:01 -0500
Message-ID: <4B354C70.1060109@zytor.com>
Date: Fri, 25 Dec 2009 15:36:16 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Sergei Trofimovich <slyich@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
       Sergei Trofimovich <slyfox@inbox.ru>
Subject: Re: [PATCH] Kbuild: set LC_MESSAGES=C (as LC_CTYPE=C is)
References: <1261761235-9431-1-git-send-email-slyfox@inbox.ru>
In-Reply-To: <1261761235-9431-1-git-send-email-slyfox@inbox.ru>
Content-Type: multipart/mixed;
 boundary="------------090309000308030403020208"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090309000308030403020208
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/25/2009 09:13 AM, Sergei Trofimovich wrote:
> We restricted LC_CTYPE to ASCII recently but not messages from, say,
> gcc. So instead of nice warnings I get '???? ??????? ???????'
> (ru_RU.UTF-8 locale) as a gcc warning, which is not nice. So, set
> LC_MESSAGES=C too.

The whole reason with only setting some LC_* to C was to be able to
leave LC_MESSAGES intact, but it seems it breaks on too many real-life
systems.

As such, I suggest we should set LC_ALL=C and get rid of the rest of it:

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


--------------090309000308030403020208
Content-Type: text/x-patch;
 name="0001-Makefile-Set-LC_ALL-C.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-Makefile-Set-LC_ALL-C.patch"

>From 633dcb9167582064ec5d2d832450e93768cfe376 Mon Sep 17 00:00:00 2001
From: H. Peter Anvin <hpa@zytor.com>
Date: Fri, 25 Dec 2009 15:34:33 -0800
Subject: [PATCH] Makefile: Set LC_ALL=C

We were setting LC_CTYPE, LC_COLLATE and LC_NUMERIC to the C locale,
with the intent that LC_MESSAGES would still be localized.
Unfortunately, that doesn't seem to actually work in real life, so
just be done with it and set LC_ALL=C.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 Makefile |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/Makefile b/Makefile
index c628a5c..a801d1d 100644
--- a/Makefile
+++ b/Makefile
@@ -17,11 +17,8 @@ NAME = Man-Eating Seals of Antiquity
 MAKEFLAGS += -rR --no-print-directory
 
 # Avoid funny character set dependencies
-unexport LC_ALL
-LC_CTYPE=C
-LC_COLLATE=C
-LC_NUMERIC=C
-export LC_CTYPE LC_COLLATE LC_NUMERIC
+LC_ALL=C
+export LC_ALL
 
 # We are using a recursive build, so we need to do a little thinking
 # to get the ordering right.
-- 
1.6.2.5


--------------090309000308030403020208--
