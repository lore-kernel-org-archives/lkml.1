Return-Path: <linux-kernel-owner+w=401wt.eu-S1760777AbXLUMFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760777AbXLUMFo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 07:05:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754420AbXLUMFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 07:05:37 -0500
Received: from ppsw-7.csi.cam.ac.uk ([131.111.8.137]:40930 "EHLO
	ppsw-7.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbXLUMFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 07:05:36 -0500
X-Greylist: delayed 1975 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Dec 2007 07:05:36 EST
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Anton Altaparmakov <aia21@cam.ac.uk>
To: Atro Tossavainen <atro.tossavainen@helsinki.fi>
In-Reply-To: <200712211101.lBLB15Wk015090@ruuvi.it.helsinki.fi>
Subject: Re: ncpfs unlink() handling question
References: <200712211101.lBLB15Wk015090@ruuvi.it.helsinki.fi>
Message-Id: <2991F4CC-5D61-4E5D-A908-50B42FDD4A12@cam.ac.uk>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v915)
Date: Fri, 21 Dec 2007 11:32:38 +0000
Cc: linux-kernel@vger.kernel.org
X-Mailer: Apple Mail (2.915)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 21 Dec 2007, at 11:01, Atro Tossavainen wrote:
> I've just noticed that ncpfs (or rather, NetWare) doesn't implement
> POSIX semantics w.r.t. unlink().  Specifically, any operation that
> expects, according to POSIX, that the contents of an open but  
> unlink()ed
> file should remain available to the application that has it open, such
> as
>
> perl -pi -e 's/a/b/;' a_file
>
> on a ncpfs mounted volume causes the contents of the file to be lost,
> as unlink() on ncpfs disposes of the file properly right away and the
> new file that is written is a 's/a/b/;' of an empty file, hence  
> another
> empty file.

Correct.  You can use an extension (i.e. instead of in-place use  
a .orig or whatever) to get around this.

> I don't know whether there is any (sensible) way to fix this, but I
> would like to initiate a discussion on what would be the correct way
> for ncpfs to deal with this.

Of course there is.  Implement POSIX unlink semantics in the ncpfs  
kernel module by using the same method as the NFS kernel module uses,  
i.e. open files are renamed instead of unlinked, so effectively  
simulating the above method of using an extension.  Just look at the  
NFS source code (linux-2.6/fs/nfs/dir.c), search for "silly" (the  
feature is called "silly rename")...

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/

