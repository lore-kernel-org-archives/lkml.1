Return-Path: <linux-kernel-owner+w=401wt.eu-S1763367AbYEFR2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763367AbYEFR2z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 13:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757314AbYEFR2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 13:28:44 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:11494 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755634AbYEFR2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 13:28:43 -0400
Message-ID: <48209547.7020807@de.ibm.com>
Date: Tue, 06 May 2008 19:28:39 +0200
From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: ltp-list@lists.sourceforge.net, ltp-coverage@lists.sourceforge.net,
       sam@ravnborg.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 3/6] kbuild: convert include and source paths
References: <481F26AA.4050701@de.ibm.com> <20080505213251.d2025dc8.akpm@linux-foundation.org>
In-Reply-To: <20080505213251.d2025dc8.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 05 May 2008 17:24:26 +0200 Peter Oberparleiter <peter.oberparleiter@de.ibm.com> wrote:
> 
>> From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
>> 
>> Modify kbuild to convert relative include and source paths to absolute
>> form. Also change the module versioning mechanism to alter object file
>> names only after compiling.
>> 
>> Required by the gcov profiling infrastructure: source paths are
>> referenced by the compiled object files. Using relative paths or
>> object file names which are different from the source name would
>> prevent the gcov tool from finding the corresponding source files.

> It doesn't appear to affect __FILE__ in any way (which is good).  But I'm
> unsure what it _does_ affect.  The changelog implies that it will convert
> "liunx/foo.h" into /usr/src/linux/include/foo.h, only it doesn't.
> 
> ho hum.

This patch should convert

	gcc -Idir1 -c a.c -o a.o

to

	gcc -I/path/to/dir1 -c /path/to/a.c -o a.o

As a standalone change this has no visible effect, but when gcc option
-fprofile-arcs is specified (as done in patch 5), the resulting object
files should only contain absolute paths.


Regards,
  Peter
