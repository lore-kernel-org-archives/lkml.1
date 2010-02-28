Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031970Ab0B1T7k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 14:59:40 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52541 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031960Ab0B1T7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 14:59:39 -0500
Date: Sun, 28 Feb 2010 20:59:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Matthew Garrett <mjg@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: tip: origin tree build failure
Message-ID: <20100228195911.GA4184@elte.hu>
References: <1267197527-18062-1-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267197527-18062-1-git-send-email-mjg@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Matthew Garrett <mjg@redhat.com> wrote:

>       dell-laptop: Use buffer with 32-bit physical address

Hi, this commit introduced an allyesconfig build bug - fixed via the patch 
below.

Thanks,

	Ingo

------------------>
>From 03894dc8462f82c145ec1c3aced9b0718ae4e9ed Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Sun, 28 Feb 2010 20:55:41 +0100
Subject: [PATCH] dell-laptop: Fix build error by making buffer_mutex static

The following build bug (x86, allyesconfig):

  arch/x86/oprofile/built-in.o:(.data+0x250): multiple definition of `buffer_mutex'

Was triggered in -tip testing, caused by this upstream commit:

  116ee77: dell-laptop: Use buffer with 32-bit physical address

There's multiple buffer_mutex's in the kernel. Make this new one
static.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/platform/x86/dell-laptop.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/dell-laptop.c b/drivers/platform/x86/dell-laptop.c
index b7f4d27..29d96a4 100644
--- a/drivers/platform/x86/dell-laptop.c
+++ b/drivers/platform/x86/dell-laptop.c
@@ -132,8 +132,8 @@ static struct dmi_system_id __devinitdata dell_blacklist[] = {
 };
 
 static struct calling_interface_buffer *buffer;
-struct page *bufferpage;
-DEFINE_MUTEX(buffer_mutex);
+static struct page *bufferpage;
+static DEFINE_MUTEX(buffer_mutex);
 
 static int hwswitch_state;
 
