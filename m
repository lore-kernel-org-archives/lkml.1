Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111Ab0CHHxt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 02:53:49 -0500
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:57658 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab0CHHxq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 02:53:46 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
Organization: IBM
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: defrag deployment status (was Re: [PATCH] ext4: allow defrag (EXT4_IOC_MOVE_EXT) in 32bit compat mode)
Date: Mon, 8 Mar 2010 08:53:42 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-self-05680-gb8fa057-dirty; KDE/4.3.4; x86_64; ; )
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       Akira Fujita <a-fujita@rs.jp.nec.com>
References: <201003072132.10579.borntraeger@de.ibm.com> <4B94367E.9080506@garzik.org>
In-Reply-To: <4B94367E.9080506@garzik.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201003080853.42978.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 08 März 2010 00:27:58 schrieb Jeff Garzik:
> I'm curious, what is the overall deployment status of ext4 defragging? 
> I actually worked on this problem years ago[1], and am hopeful that I 
> will see defragging in a Linux distribution sometime in my lifetime!  ;-)

I had to make the following patch. (There was the same patch already on the
e2fsprogs mailing list, but I cannot find that at the moment. Would be good
if this patch can make it into the next version).

--- a/misc/e4defrag.c
+++ b/misc/e4defrag.c
@@ -1605,7 +1605,7 @@ static int file_defrag(const char *file, const struct stat64 *buf,
                return 0;
        }

-       fd = open64(file, O_RDONLY);
+       fd = open64(file, O_RDWR);
        if (fd < 0) {
                if (mode_flag & DETAIL) {
                        PRINT_FILE_NAME(file);


I did use it on two machines and it does not seem to break anything. 
Some bigger things are missing in the e4defrag tool:
- make the indirect to extend change for old files - e.g. converted ext3
  file systems. Adding the MIGRATE ioctl does not look very hard, but who knows?
- defragging directories (and also remove deleted entries)
- free space optimization is only done as a side effect
- overall layout considerations (e.g. putting files close to its directory or
  use the atime to move often used files to the beginning of a disk etc.)
