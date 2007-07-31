Return-Path: <linux-kernel-owner+w=401wt.eu-S932842AbXGaRyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932842AbXGaRyA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 13:54:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753936AbXGaRxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 13:53:50 -0400
Received: from ppsw-4.csi.cam.ac.uk ([131.111.8.134]:39594 "EHLO
	ppsw-4.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488AbXGaRxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 13:53:48 -0400
X-Greylist: delayed 3020 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 Jul 2007 13:53:48 EDT
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Mark Williamson <mark.williamson@cl.cam.ac.uk>
To: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Subject: Re: [RFC 12/26] ext2 white-out support
Date: Tue, 31 Jul 2007 18:03:06 +0100
User-Agent: KMail/1.9.6
Cc: Jan Blunck <jblunck@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Bharata B Rao <bharata@linux.vnet.ibm.com>
References: <20070730161323.100048969@weierstrass.suse.de> <20070730161324.261652101@weierstrass.suse.de> <20070731163656.GC22350@filer.fsl.cs.sunysb.edu>
In-Reply-To: <20070731163656.GC22350@filer.fsl.cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707311803.08698.mark.williamson@cl.cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Really the only sane way of keeping track of whiteouts seems some external
> store. We did an experiment with Unionfs, and moving the whiteout handling
> to effectively a "library" that did all the dirty work cleaned up the code
> considerably [2,3].

What about keeping track of whiteouts in a special file (or files) in the top 
level filesystem of the union?  For instance, having a /.whiteouts file at 
the root of the top FS in the stack, instead of storing union-specific data 
in the flags / inode numbers of the lower levels.

This file could also e.g. store the UUID of the lower level FS (if 
appropriate) so that in subsequent mounts (which might attempt a union with a 
different lower level branch) you can tell if the whiteouts have meaning.  
The whiteout history could be flushed by directly mounting the FS and doing 
rm .whiteouts.

This might avoid requiring a store external to the stack of filesystems and I 
believe it would solve the problem with shared branches and arbitrary 
stacking that you described?

I guess a rather similar effect could be had by somehow storing loopback 
mountable ODF filesystems in the top layer of a union somewhere (e.g. with 
the default path /.odf) and allowing the user to specify an alternate 
location at mount time if necessary.  So maybe these approaches are quite 
similar after all...

Cheers,
Mark

-- 
Dave: Just a question. What use is a unicyle with no seat?  And no pedals!
Mark: To answer a question with a question: What use is a skateboard?
Dave: Skateboards have wheels.
Mark: My wheel has a wheel!
