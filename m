Return-Path: <linux-kernel-owner+w=401wt.eu-S1030693AbXCHV4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030693AbXCHV4V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 16:56:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030698AbXCHV4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 16:56:21 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57009 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030693AbXCHV4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 16:56:20 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: swsusp: platform notifications not properly undone in case of error
Date: Thu, 8 Mar 2007 22:58:54 +0100
User-Agent: KMail/1.9.5
Cc: kernel list <linux-kernel@vger.kernel.org>
References: <20070308164143.GA1766@elf.ucw.cz>
In-Reply-To: <20070308164143.GA1766@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703082258.55186.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 8 March 2007 17:41, Pavel Machek wrote:
> Hi!
> 
> 
> Using IPI No-Shortcut mode
> swsusp: Resume From Partition /dev/sda1
> PM: Checking swsusp image.
> swsusp: Signature found, resuming
> PM: Preparing processes for restore.
> Stopping tasks ... done.
> PM: Reading swsusp image.
> Loading image data pages (125285 pages) ...     <3>swsusp: Resume
> mismatch: version
> Read 501140 kbytes in 0.01 seconds (50114.00 MB/s)
> swsusp: Error -1 resuming
> PM: Restore failed, recovering.
> Restarting tasks ... done.
> PM: Resume from disk failed.
> md: Autodetecting RAID arrays.
> 
> ...and machine boots, but moon icon keeps blinking.

Does the appended patch help?

Rafael

---
 kernel/power/disk.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.21-rc3/kernel/power/disk.c
===================================================================
--- linux-2.6.21-rc3.orig/kernel/power/disk.c
+++ linux-2.6.21-rc3/kernel/power/disk.c
@@ -261,6 +261,7 @@ static int software_resume(void)
 	error = swsusp_read();
 	if (error) {
 		swsusp_free();
+		platform_finish();
 		goto Thaw;
 	}
 
