Return-Path: <linux-kernel-owner+w=401wt.eu-S1757266AbXJ0R5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266AbXJ0R5V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 13:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752267AbXJ0R5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 13:57:11 -0400
Received: from ppsw-6.csi.cam.ac.uk ([131.111.8.136]:58813 "EHLO
	ppsw-6.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbXJ0R5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 13:57:09 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Anton Altaparmakov <aia21@cam.ac.uk>
To: Mike Waychison <mikew@google.com>
In-Reply-To: <20071026233732.568575496@crlf.corp.google.com>
Subject: Re: [patch 0/6][RFC] Cleanup FIBMAP
References: <20071026233732.568575496@crlf.corp.google.com>
Message-Id: <E579083F-FED3-4990-8E24-275ED38E9E3B@cam.ac.uk>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v912)
Date: Sat, 27 Oct 2007 18:57:06 +0100
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
X-Mailer: Apple Mail (2.912)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

->bmap is ugly and horrible!  If you have to do this at the very least  
please cause ->bmap64 to be able to return error values in case the  
file system failed to get the information or indeed such information  
does not exist as is the case for compressed and encrypted files for  
example and also for small files that are inside the on-disk inode  
(NTFS resident files and reiserfs packed tails are examples of this).

And another of my pet peeves with ->bmap is that it uses 0 to mean  
"sparse" which causes a conflict on NTFS at least as block zero is  
part of the $Boot system file so it is a real, valid block...  NTFS  
uses -1 to denote sparse blocks internally.

Best regards,

	Anton

On 27 Oct 2007, at 00:37, Mike Waychison wrote:

> The following series is meant to clean up FIBMAP paths with the  
> eventual goal of allowing users to be able to FIBMAP their data.
>
> I'm sending this as an RFC as I've only tested this on a x86_64  
> kernel with a 32bit binary on ext2 and I've noticed a couple  
> ext2_warnings already.
>
> I'm unsure of the locking in [4/6] fix_race_with_truncate.patch.   
> Any help here would greatly be appreciated.
>
> The last patch, [6/6] drop_cap_sys_rawio_for_fibmap.patch, is of  
> course, not to be applied until any remaining issues are fixed :)
>
> Thanks,
>
> Mike Waychison


-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/

