Return-Path: <linux-kernel-owner+w=401wt.eu-S1754887AbYAQPXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887AbYAQPXs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 10:23:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751803AbYAQPXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 10:23:38 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:4692 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbYAQPXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 10:23:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=uKx0DUGIbBzgC4/fSAUNrb7eClyu286kXjxxVhvZk0gt53+RrJH+6S7P2aisZc3QX7VOiPixBZPpm1a/Ww4FAcHyzr1TAoYxKb2ocsFihAAMQaEQECr+QyBFCG6jVOMOikyaQYNKDMDrkWuF9u39t8iz90LuJ/SwBflKsju/M9M=
Message-ID: <478F72F2.6000707@gmail.com>
Date: Thu, 17 Jan 2008 16:23:30 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org,
       Torsten Kaiser <just.for.lkml@googlemail.com>,
       NeilBrown <neilb@suse.de>, mingo@redhat.com, linux-raid@vger.kernel.org
Subject: do_md_run returned -22 [Was: 2.6.24-rc8-mm1]
References: <20080117023514.9df393cf.akpm@linux-foundation.org>
In-Reply-To: <20080117023514.9df393cf.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2008 11:35 AM, Andrew Morton wrote:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc8/2.6.24-rc8-mm1/

still the same md issue (do_md_run returns -22=EINVAL) as in -rc6-mm1 reported 
by Thorsten here:
http://lkml.org/lkml/2007/12/27/45

Is there around any fix for this?

Having 0.90 raid 0 and 1, commenting this out helps:
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 8633bd4..9b8ecc8 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3292,8 +3292,8 @@ static int do_md_run(mddev_t * mddev)
          * Analyze all RAID superblock(s)
          */
         if (!mddev->raid_disks) {
-               if (!mddev->persistent)
-                       return -EINVAL;
+/*             if (!mddev->persistent)
+                       return -EINVAL;*/
                 analyze_sbs(mddev);
         }

The persistency is marked even in analyze_sbs->validate_super, I guess?
