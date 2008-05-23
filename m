Return-Path: <linux-kernel-owner+w=401wt.eu-S1761334AbYEWDTJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761334AbYEWDTJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 23:19:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759083AbYEWDSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 23:18:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41926 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755986AbYEWDSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 23:18:20 -0400
Date: Thu, 22 May 2008 20:17:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, ltp-coverage@lists.sourceforge.net,
       Sam Ravnborg <sam@ravnborg.org>,
       Peter Oberparleiter <oberparleiter@googlemail.com>
Subject: Re: [PATCH 6/7] kbuild: make source and include paths absolute
Message-Id: <20080522201724.cf4bd471.akpm@linux-foundation.org>
In-Reply-To: <48313E08.8070904@de.ibm.com>
References: <48313E08.8070904@de.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2008 10:44:56 +0200 Peter Oberparleiter <peter.oberparleiter@de.ibm.com> wrote:

> From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
> 
> Change all source and include paths to absolute form when
> CONFIG_GCOV_PROFILE is enabled.
> 
> Example:
> 
>   gcc -Idir1 -c a.c -o a.o
> 
> will become
> 
>   gcc -I/path/to/dir1 -c /path/to/a.c -o a.o
> 
> Required by the gcov profiling infrastructure: when compiling with
> option -fprofile-arcs, gcc stores file names inside object files.
> Relative paths prevent the gcov tool from finding corresponding source
> files.

I don't like this.  It converts the compiler error messages from
relative paths to absolute paths which is rather obnoxious when
all kernel developent is (or should be) base-directory-agnostic.


