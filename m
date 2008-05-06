Return-Path: <linux-kernel-owner+w=401wt.eu-S1755543AbYEFEcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543AbYEFEcv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 00:32:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751138AbYEFEcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 00:32:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35484 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751091AbYEFEck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 00:32:40 -0400
Date: Mon, 5 May 2008 21:30:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, ltp-list@lists.sourceforge.net,
       ltp-coverage@lists.sourceforge.net
Subject: Re: [RFC PATCH 5/6] gcov: add gcov profiling infrastructure
Message-Id: <20080505213052.b1022c42.akpm@linux-foundation.org>
In-Reply-To: <481F26BE.2060706@de.ibm.com>
References: <481F26BE.2060706@de.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 May 2008 17:24:46 +0200 Peter Oberparleiter <peter.oberparleiter@de.ibm.com> wrote:

> +config GCOV_PROFILE
> +	bool "Activate gcov-based profiling"
> +	depends on DEBUG_FS
> +	---help---
> +	This option enables gcov-based code profiling (e.g. for code coverage
> +	measurements).
> +
> +	If unsure, say N.
> +
> +	Additionally specify CONFIG_GCOV_PROFILE_ALL=y to get profiling data
> +	for the entire kernel. To enable profiling for specific files or
> +	directories, add a line similar to the following to the respective
> +	Makefile:
> +
> +	For a single file (e.g. main.o):
> +	        GCOV_main.o := y
> +
> +	For all files in one directory:
> +	        GCOV := y
> +
> +	To exclude files from being profiled even when CONFIG_GCOV_PROFILE_ALL
> +	is specified, use:
> +
> +	        GCOV_main.o := n
> +	and:
> +	        GCOV := n
> +
> +	Note that the debugfs filesystem has to be mounted to access
> +	profiling data.
> +
> +config GCOV_PROFILE_ALL
> +	bool "Profile entire Kernel"
> +	depends on GCOV_PROFILE
> +	---help---
> +	This options activates profiling for the entire kernel.
> +
> +	If unsure, say Y.
> +
> +	Note that a kernel compiled with profiling flags will be larger and
> +	slower. Also be sure to exclude files from profiling which are not
> +	linked to the kernel image to prevent linker errors.

umm....  I think the Kconfig help should include the text "makes your
kernel three times larger".
