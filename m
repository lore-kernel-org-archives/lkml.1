Return-Path: <linux-kernel-owner+w=401wt.eu-S1760459AbYDNIMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760459AbYDNIMp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 04:12:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760226AbYDNIMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 04:12:03 -0400
Received: from ppsw-5.csi.cam.ac.uk ([131.111.8.135]:55627 "EHLO
	ppsw-5.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759766AbYDNIL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 04:11:58 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Anton Altaparmakov <aia21@cam.ac.uk>
To: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080414004909.1b21b738.akpm@linux-foundation.org>
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
References: <1208041121-26787-1-git-send-email-me@bobcopeland.com> <20080412170304.54f139e2.akpm@linux-foundation.org> <20080413033344.GA27494@hash.localnet> <20080412205544.5e12a7d4.akpm@linux-foundation.org> <20080413080130.GA9622@infradead.org> <20080413012001.8d7967f4.akpm@linux-foundation.org> <20080413082815.GA20108@infradead.org> <E1JkzaV-0003Lm-NB@pomaz-ex.szeredi.hu> <1208121358.2700.4.camel@shinybook.infradead.org> <E1JlJ4U-0004xa-Sf@pomaz-ex.szeredi.hu> <20080414004909.1b21b738.akpm@linux-foundation.org>
Message-Id: <FEE6C6C4-7F19-4769-B674-FFFCA764EDD3@cam.ac.uk>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Date: Mon, 14 Apr 2008 09:11:35 +0100
Cc: Miklos Szeredi <miklos@szeredi.hu>, dwmw2@infradead.org, hch@infradead.org,
       me@bobcopeland.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
X-Mailer: Apple Mail (2.919.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 14 Apr 2008, at 08:49, Andrew Morton wrote:
> On Mon, 14 Apr 2008 09:25:46 +0200 Miklos Szeredi  
> <miklos@szeredi.hu> wrote:
>
>> And I didn't advocate moving
>> ntfs to fuse, still that was done and the resulting filesystem at the
>> moment happens to outperform the kernel one in every respect ;)
>
> Gad.  Why?

Miklos has the wrong end of the stick.  No-one has "moved" ntfs to  
fuse.  And the fuse implementation doesn't outperform the kernel  
implementation in anything at all.  However the kernel one as  
available in the kernel source tree doesn't have many write-features,  
it can only overwrite files, it cannot create/delete files, etc.  So I  
guess if you define "performance" to mean "features" then sure  
ntfsmount/ntfs-3g have more features than the public kernel driver.   
If you define "performance" to mean "speed" then no ntfsmount/ntfs-3g  
can't compare to the kernel except in very limited and meaningless  
benchmarks...

btw. even comparing features, the fuse solutions lag behind in some  
respects, e.g. no-one can "kill -9" the kernel driver leaving a  
corrupt file system on the volume (and under no-one I include the OOM  
killer for example!) and another example is that the fuse solutions  
require large amounts of ram whereas the kernel driver can happily  
function in 1MiB ram and less even as everything is in the page cache  
so it will just cause heavy paging whilst the fuse solutions just blow  
up / OOM the machine when they find a large directory and the user has  
only 32MiB ram for example...  At least I have seen reports of this on  
the mailing lists, not that I have ever cared to try.

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/

