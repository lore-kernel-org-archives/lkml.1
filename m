Return-Path: <linux-kernel-owner+w=401wt.eu-S1752028AbZL2Q5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028AbZL2Q5R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 11:57:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751624AbZL2Q5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 11:57:16 -0500
Received: from THUNK.ORG ([69.25.196.29]:37205 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469AbZL2Q5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 11:57:15 -0500
Date: Tue, 29 Dec 2009 11:57:12 -0500
From: tytso@mit.edu
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Gene Heskett <gene.heskett@verizon.net>, okias <d.okias@gmail.com>
Subject: Re: [Bug #14936] kernel BUG at fs/ext4/inode.c:1063 if attempted
 to use non-ext4 partition with ext4
Message-ID: <20091229165712.GH4429@thunk.org>
Mail-Followup-To: tytso@mit.edu, "Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Gene Heskett <gene.heskett@verizon.net>, okias <d.okias@gmail.com>
References: <LptzGUUXbTK.A.MSF.ymhOLB@chimera>
 <NJVdobuNFNK.A.-nG.JnhOLB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <NJVdobuNFNK.A.-nG.JnhOLB@chimera>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 29, 2009 at 04:10:01PM +0100, Rafael J. Wysocki wrote:
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14936
> Subject		: kernel BUG at fs/ext4/inode.c:1063 if attempted to use non-ext4 partition with ext4
> Submitter	: Gene Heskett <gene.heskett@verizon.net>
> Date		: 2009-12-26 14:13 (4 days old)
> References	: http://marc.info/?l=linux-kernel&m=126183682330809&w=4
> 		  http://marc.info/?l=linux-kernel&m=126169372613898&w=4

Bisected to commit d21cd8, and reverting this commit seems to fix the
problem.  The problem appeared between -rc1 and -rc2.  It was a fix
that was pushed as part of a quota/ext4 fixes.  For more information:

http://marc.info/?l=linux-ext4&m=126197233225936&w=2

I will take a look at this to see if I can find an easy fix;
otherwise, we'll probably want to revert commit d21cd8 before -rc3.

	   	 	       	  	 - Ted
