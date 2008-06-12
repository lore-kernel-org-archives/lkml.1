Return-Path: <linux-kernel-owner+w=401wt.eu-S1759277AbYFLADl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759277AbYFLADl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 20:03:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753909AbYFLADe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 20:03:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59230 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753902AbYFLADd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 20:03:33 -0400
Date: Wed, 11 Jun 2008 17:01:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, ltp-coverage@lists.sourceforge.net,
       oberparleiter@googlemail.com
Subject: Re: [PATCH 6/6] gcov: architecture specific compile flag
 adjustments
Message-Id: <20080611170127.46b46d28.akpm@linux-foundation.org>
In-Reply-To: <4843F6F7.9020000@de.ibm.com>
References: <4843F6F7.9020000@de.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Jun 2008 15:34:47 +0200
Peter Oberparleiter <peter.oberparleiter@de.ibm.com> wrote:

> Exclude code from profiling which is not linked to the main kernel or
> which is running in a context not compatible with the assumptions made
> by gcc's profiling code.

powerpc allmodconfig fails with

Error: External symbol '__gcov_init' referenced from prom_init.c
Error: External symbol '__gcov_merge_add' referenced from prom_init.c

This:

--- a/arch/powerpc/kernel/Makefile~a
+++ a/arch/powerpc/kernel/Makefile
@@ -12,6 +12,10 @@ CFLAGS_prom_init.o      += -fPIC
 CFLAGS_btext.o         += -fPIC
 endif
 
+ifdef CONFIG_GCOV_PROFILE
+CFLAGS_prom_init.o     += -fno-profile-arcs -fno-test-coverage
+endif
+

didn't fix it so I gave up.
