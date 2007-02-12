Return-Path: <linux-kernel-owner+w=401wt.eu-S1030211AbXBLW1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030211AbXBLW1a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 17:27:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030213AbXBLW13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 17:27:29 -0500
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:56936 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030211AbXBLW12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 17:27:28 -0500
To: jengelh@linux01.gwdg.de
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       szaka@sienet.hu
In-reply-to: <Pine.LNX.4.61.0702121923350.26360@yvahk01.tjqt.qr> (message from
	Jan Engelhardt on Mon, 12 Feb 2007 19:27:22 +0100 (MET))
Subject: Re: [RFC PATCH] add filesystem subtype support
References: <E1HGZhm-0003eb-00@dorka.pomaz.szeredi.hu> <Pine.LNX.4.61.0702121923350.26360@yvahk01.tjqt.qr>
Message-Id: <E1HGjdh-0004h3-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 12 Feb 2007 23:27:13 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >-static struct file_system_type **find_filesystem(const char *name)
> >+static struct file_system_type **find_filesystem(const char *name, unsigned len)
> > {
> > 	struct file_system_type **p;
> > 	for (p=&file_systems; *p; p=&(*p)->next)
> >-		if (strcmp((*p)->name,name) == 0)
> >+		if (strlen((*p)->name) == len &&
> >+		    strncmp((*p)->name, name, len) == 0)
> > 			break;
> > 	return p;
> > }
> 
> Question btw, why does this function return a struct file_system_type ** at
> all? Would not struct file_system_type * suffice?

It's used in register_filesystem() to get the end of the list pointer.

Miklos
