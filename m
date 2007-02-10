Return-Path: <linux-kernel-owner+w=401wt.eu-S1946806AbXBJAaJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946806AbXBJAaJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 19:30:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946807AbXBJAaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 19:30:09 -0500
Received: from ppsw-0.csi.cam.ac.uk ([131.111.8.130]:41043 "EHLO
	ppsw-0.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946806AbXBJAaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 19:30:08 -0500
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
In-Reply-To: <20070209152219.fa61d152.akpm@linux-foundation.org>
References: <20070209225329.27619A62@localhost.localdomain> <20070209225344.93A75D35@localhost.localdomain> <20070209152219.fa61d152.akpm@linux-foundation.org>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <413B65F6-2730-450A-9CD7-B7FE7A8ED961@cam.ac.uk>
Cc: Dave Hansen <hansendc@us.ibm.com>, linux-kernel@vger.kernel.org,
       hch@infradead.org
Content-Transfer-Encoding: 7bit
From: Anton Altaparmakov <aia21@cam.ac.uk>
Subject: Re: [PATCH 21/22] honor r/w changes at do_remount() time
Date: Sat, 10 Feb 2007 00:29:40 +0000
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 Feb 2007, at 23:22, Andrew Morton wrote:
> On Fri, 09 Feb 2007 14:53:44 -0800
> Dave Hansen <hansendc@us.ibm.com> wrote:
>
>> This is the core of the read-only bind mount patch set.
>
> Who wants read-only bind mounts, and for what reason?

On our local mirror server (mirrors just under 3TiB worth of stuff)  
we hold all data on r/w mounted storage in a private location in the  
file tree.  (Note the server runs Solaris 10 not Linux or the  
following would not be possible at present...)

We then bind mount (i.e. loopback mount on Solaris) various  
directories from inside the private paths to various other locations  
so for example we create /export/ftp/pub/* where "*" are directories  
we want to export via FTP and we do all of those as read-only bind  
mounts.  This gives us that little bit of extra confidence that no- 
one from the outside can cause any writes to happen to our mirrored  
data.  We do similar for NFS by creating lots of read-only bind  
mounts in /* that again point into the private locations.

It would be nice if the Linux box that we have that is a copy/backup  
of the Solaris box could do the same rather than have all the bind  
mounts be read-write because we need the storage in the private  
locations to be writable.

Best regards,

	Anton
