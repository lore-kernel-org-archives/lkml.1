Return-Path: <linux-kernel-owner+w=401wt.eu-S1760949AbXEUOcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760949AbXEUOcs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 10:32:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755714AbXEUOck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 10:32:40 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:15039 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755326AbXEUOcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 10:32:39 -0400
X-IronPort-AV: i="4.14,561,1170651600"; 
   d="scan'208"; a="30532644:sNHT26271651"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Bryan Wu" <bryan.wu@analog.com>
Subject: Re: [PATCH 00/32] Blackfin update for 2.6.22-rc2
Date: Mon, 21 May 2007 10:35:08 -0400
User-Agent: KMail/1.9.5
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
References: <1179742180228-git-send-email-bryan.wu@analog.com>
In-Reply-To: <1179742180228-git-send-email-bryan.wu@analog.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705211035.08380.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 21 May 2007 14:32:37.0462 (UTC) FILETIME=[E0FFAF60:01C79BB4]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 21 May 2007 06:09, Bryan Wu pondered:
> Lots of update for 2.6.22-rc2 and tested on STAMP537 board.
>

One of the things I noticed when trying out 2.6.22-rc1, on blackfin was:

 CALL    scripts/checksyscalls.sh
<stdin>:96:2: warning: #warning syscall restart_syscall not implemented
<stdin>:216:2: warning: #warning syscall utime not implemented
<stdin>:424:2: warning: #warning syscall select not implemented
<stdin>:440:2: warning: #warning syscall uselib not implemented
<stdin>:444:2: warning: #warning syscall swapon not implemented
<stdin>:456:2: warning: #warning syscall mmap not implemented
<stdin>:556:2: warning: #warning syscall swapoff not implemented
<stdin>:636:2: warning: #warning syscall sysfs not implemented
<stdin>:672:2: warning: #warning syscall msync not implemented
<stdin>:696:2: warning: #warning syscall mlock not implemented
<stdin>:700:2: warning: #warning syscall munlock not implemented
<stdin>:704:2: warning: #warning syscall mlockall not implemented
<stdin>:708:2: warning: #warning syscall munlockall not implemented
<stdin>:748:2: warning: #warning syscall mremap not implemented
<stdin>:768:2: warning: #warning syscall poll not implemented
<stdin>:772:2: warning: #warning syscall nfsservctl not implemented
<stdin>:816:2: warning: #warning syscall pread64 not implemented
<stdin>:820:2: warning: #warning syscall pwrite64 not implemented
<stdin>:968:2: warning: #warning syscall mincore not implemented
<stdin>:972:2: warning: #warning syscall madvise not implemented
<stdin>:992:2: warning: #warning syscall readahead not implemented
<stdin>:1092:2: warning: #warning syscall fadvise64 not implemented
<stdin>:1116:2: warning: #warning syscall remap_file_pages not implemented
<stdin>:1184:2: warning: #warning syscall mbind not implemented
<stdin>:1188:2: warning: #warning syscall get_mempolicy not implemented
<stdin>:1192:2: warning: #warning syscall set_mempolicy not implemented
<stdin>:1220:2: warning: #warning syscall kexec_load not implemented
<stdin>:1260:2: warning: #warning syscall migrate_pages not implemented
<stdin>:1328:2: warning: #warning syscall set_robust_list not implemented
<stdin>:1332:2: warning: #warning syscall get_robust_list not implemented
<stdin>:1336:2: warning: #warning syscall splice not implemented
<stdin>:1340:2: warning: #warning syscall sync_file_range not implemented
<stdin>:1344:2: warning: #warning syscall tee not implemented
<stdin>:1348:2: warning: #warning syscall vmsplice not implemented
<stdin>:1352:2: warning: #warning syscall move_pages not implemented
<stdin>:1356:2: warning: #warning syscall getcpu not implemented
<stdin>:1360:2: warning: #warning syscall epoll_pwait not implemented
<stdin>:1364:2: warning: #warning syscall utimensat not implemented
<stdin>:1368:2: warning: #warning syscall signalfd not implemented
<stdin>:1372:2: warning: #warning syscall timerfd not implemented
<stdin>:1376:2: warning: #warning syscall eventfd not implemented

since there is noMMU, are we better:
 - putting stubs (return ENOSYS - give runtime errors), or 
 - just ignore the errors - and give compile errors? (Is there any way to put 
something into the syscall table, as not to get the warnings?)

Thanks
 - Robin
