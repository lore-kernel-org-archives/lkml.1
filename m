Return-Path: <linux-kernel-owner+w=401wt.eu-S965274AbXBLS25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965274AbXBLS25 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 13:28:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965270AbXBLS25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 13:28:57 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:33083 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965266AbXBLS24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 13:28:56 -0500
Date: Mon, 12 Feb 2007 19:27:22 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Miklos Szeredi <miklos@szeredi.hu>
cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Szakacsits Szabolcs <szaka@sienet.hu>
Subject: Re: [RFC PATCH] add filesystem subtype support
In-Reply-To: <E1HGZhm-0003eb-00@dorka.pomaz.szeredi.hu>
Message-ID: <Pine.LNX.4.61.0702121923350.26360@yvahk01.tjqt.qr>
References: <E1HGZhm-0003eb-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Feb 12 2007 12:50, Miklos Szeredi wrote:
>Index: linux/fs/filesystems.c
>===================================================================
>--- linux.orig/fs/filesystems.c	2007-02-12 12:42:55.000000000 +0100
>+++ linux/fs/filesystems.c	2007-02-12 12:43:00.000000000 +0100
>@@ -42,11 +42,12 @@ void put_filesystem(struct file_system_t
> 	module_put(fs->owner);
> }
> 
>-static struct file_system_type **find_filesystem(const char *name)
>+static struct file_system_type **find_filesystem(const char *name, unsigned len)
> {
> 	struct file_system_type **p;
> 	for (p=&file_systems; *p; p=&(*p)->next)
>-		if (strcmp((*p)->name,name) == 0)
>+		if (strlen((*p)->name) == len &&
>+		    strncmp((*p)->name, name, len) == 0)
> 			break;
> 	return p;
> }

Question btw, why does this function return a struct file_system_type ** at
all? Would not struct file_system_type * suffice?


I like the idea. Then the "real filesystem type" (e.g. sshfs) pops up in the
fstype field in getmntent, and `df`, for example.


Jan
-- 
ft: http://freshmeat.net/p/chaostables/
