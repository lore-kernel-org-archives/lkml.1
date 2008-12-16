Return-Path: <linux-kernel-owner+w=401wt.eu-S1753553AbYLPEDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553AbYLPEDU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 23:03:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751332AbYLPEDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 23:03:10 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49292 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbYLPEDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 23:03:09 -0500
Message-ID: <4947282F.1020608@cn.fujitsu.com>
Date: Tue, 16 Dec 2008 12:01:51 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: linux-kernel@vger.kernel.org, akpm <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: mmotm 2008-12-15-16-45 uploaded (build errors)
References: <200812160046.mBG0k0YV024823@imap1.linux-foundation.org> <494726DE.6000100@oracle.com>
In-Reply-To: <494726DE.6000100@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Nick Piggin <nickpiggin@yahoo.com.au>

Randy Dunlap wrote:
> akpm@linux-foundation.org wrote:
>> The mm-of-the-moment snapshot 2008-12-15-16-45 has been uploaded to
>>
>>    http://userweb.kernel.org/~akpm/mmotm/
>>
>> It contains the following patches against 2.6.28-rc8:
> 
> 
> Summary of build errors:
> 
> i386
> =====
> build-r7178.out:/local/linsrc/tmp/mmotm-2008-1215-1645/mm/vmscan.c:1397: error: too few arguments to function 'mem_cgroup_inactive_anon_is_low'
> build-r7178.out:make[2]: *** [mm/vmscan.o] Error 1

> build-r7178.out:/local/linsrc/tmp/mmotm-2008-1215-1645/fs/fuse/file.c:792: error : implicit declaration of function '__grab_cache_page'

I got this compile error too:

This patch removed __grab_cache_page():
	fs-symlink-write_begin-allocation-context-fix.patch

But mainline has 2 __grab_cache_page() in fuse.c, and the above patch seems just remove 1 of them.

And this patch adds another use of __grab_cache_page():
	reiser4-adjust-to-the-new-aops.patch()


> build-r7178.out:make[3]: *** [fs/fuse/file.o] Error 1
> 7188	same
> 7190	same
> 7195	same
> 
> build-r7179.out:/local/linsrc/tmp/mmotm-2008-1215-1645/fs/fuse/file.c:792: error : implicit declaration of function '__grab_cache_page'
> build-r7179.out:make[3]: *** [fs/fuse/file.o] Error 1
> 7180	same
> 
> build-r7181.out:/local/linsrc/tmp/mmotm-2008-1215-1645/fs/reiser4/plugin/file/file_conversion.c:689: error: implicit declaration of function '__grab_cache_page'
> build-r7181.out:make[3]: *** [fs/reiser4/plugin/file/file_conversion.o] Error 1
> 
> 
> x86_64
> =====
> build-r7182.out:/local/linsrc/tmp/mmotm-2008-1215-1645/mm/vmscan.c:1397: error: too few arguments to function 'mem_cgroup_inactive_anon_is_low'
> build-r7182.out:make[2]: *** [mm/vmscan.o] Error 1
> build-r7182.out:/local/linsrc/tmp/mmotm-2008-1215-1645/fs/fuse/file.c:792: error : implicit declaration of function '__grab_cache_page'
> build-r7182.out:make[3]: *** [fs/fuse/file.o] Error 1
> 7185	same
> 7189	same
> 7191	same
> 
> build-r7183.out:/local/linsrc/tmp/mmotm-2008-1215-1645/mm/vmscan.c:1397: error: too few arguments to function 'mem_cgroup_inactive_anon_is_low'
> build-r7183.out:make[2]: *** [mm/vmscan.o] Error 1
> build-r7183.out:/local/linsrc/tmp/mmotm-2008-1215-1645/fs/reiser4/plugin/file/fi le_conversion.c:689: error: implicit declaration of function '__grab_cache_page'
> build-r7183.out:make[3]: *** [fs/reiser4/plugin/file/file_conversion.o] Error 1
> 
> build-r7184.out:/local/linsrc/tmp/mmotm-2008-1215-1645/fs/ubifs/file.c:251: error: 'flags' undeclared (first use in this function)
> build-r7184.out:make[3]: *** [fs/ubifs/file.o] Error 1
> 
> 
> ~Randy
> (need .config files?)
