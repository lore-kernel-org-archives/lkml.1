Return-Path: <linux-kernel-owner+w=401wt.eu-S1756130AbZALOBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130AbZALOBU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 09:01:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754907AbZALNzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 08:55:15 -0500
Received: from p02c12o141.mxlogic.net ([208.65.145.74]:42364 "EHLO
	p02c12o141.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241AbZALNzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 08:55:13 -0500
Message-ID: <496B4BBE.5040701@steeleye.com>
Date: Mon, 12 Jan 2009 08:55:10 -0500
From: Paul Clements <paul.clements@steeleye.com>
User-Agent: Swiftdove 2.0.0.9 (X11/20071116)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: kernel list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Subject: Re: do not allow two nbd-clients at same time
References: <20081208213542.GA10134@elf.ucw.cz> <20081208225758.GA2872@elf.ucw.cz> <20090112110322.GA2001@elf.ucw.cz>
In-Reply-To: <20090112110322.GA2001@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Jan 2009 13:55:11.0116 (UTC) FILETIME=[62BFFCC0:01C974BD]
X-Spam: [F=0.2000000000; S=0.200(2008120801)]
X-MAIL-FROM: <paul.clements@steeleye.com>
X-SOURCE-IP: [207.43.68.209]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Two nbd-clients at same time are bad idea, and cause WARN_ON from nbd
> in 2.6.28-rc7 from sysfs_add_one. This simply prevents that from
> happening.

Thanks for this. But I think we also need the following:

--- drivers/block/nbd.c        2008-12-24 18:26:37.000000000 -0500
+++ drivers/block/nbd.c 2009-01-12 08:50:17.000000000 -0500
@@ -406,6 +406,7 @@ static int nbd_do_it(struct nbd_device *
         ret = sysfs_create_file(&disk_to_dev(lo->disk)->kobj, 
&pid_attr.attr);
         if (ret) {
                 printk(KERN_ERR "nbd: sysfs_create_file failed!");
+               lo->pid = 0;
                 return ret;
         }


To zero out pid in the error case. Otherwise, it looks good.

Thanks,
Paul

