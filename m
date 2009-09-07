Return-Path: <linux-kernel-owner+w=401wt.eu-S1752392AbZIGIZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392AbZIGIZu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 04:25:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752349AbZIGIZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 04:25:48 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:39366 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbZIGIZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 04:25:45 -0400
Message-ID: <4AA4C354.4040002@linux.vnet.ibm.com>
Date: Mon, 07 Sep 2009 10:24:52 +0200
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Amerigo Wang <amwang@redhat.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-kbuild@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [RFC Patch 0/5] gcov: integrate gcov into kbuild
References: <20090904012755.3749.69645.sendpatchset@localhost.localdomain>
In-Reply-To: <20090904012755.3749.69645.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amerigo Wang wrote:
> This patchset is mainly to integrate gcov into kbuild system, so that
> we can use "make foo/bar.c.gcov" to get the gcov files.
> Also moves the useful scripts in gcov.txt into tools/gcov/ direcotry.

Interesting approach - this should definitely make it more easy for 
developers to get coverage data for their code. A couple of 
thoughts/observations:

- does not work when compiling with a separate build directory (make O=)

/sys/kernel/debug/gcov//mnt/out//mnt/linux-2.6.gcno:cannot open graph file
make[2]: *** [init/main.c.gcov] Error 1
make[1]: *** [init/main.c.gcov] Error 2
make: *** [sub-make] Error 2

This is most likely due to target_base_name being an absolute path 
(relative to srctree) in case build and source directories are different.

- gcov call should use option -p, otherwise gcov may overwrite .gcov 
files if a .c file includes two .h files from different directories.
- an option to generate .gcov files for all .c files in a subdirectory 
would be nice


Regards,
   Peter Oberparleiter

