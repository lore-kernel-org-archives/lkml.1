Return-Path: <linux-kernel-owner+w=401wt.eu-S1751428AbZLFFOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751428AbZLFFOr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 00:14:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751204AbZLFFOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 00:14:41 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:32794 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbZLFFOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 00:14:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=JUtLI+YMy0rJPcosJyPB3AdwrZ18v1Ia/wyz6J7I6vpmb4ZNvlfAiF6EbNBMhKadaA
         VE8hVknEdBqFUSHbUTqP8rm4pHksvQBf7a0cmt4qepGfVX4ALe+Dbxs0SisVRx5xM2WR
         0i2Wlwg9oZM0Fo2ScFORn1vtWRvEA/Jyj8u4w=
MIME-Version: 1.0
Date: Sun, 6 Dec 2009 08:14:46 +0300
Message-ID: <b6fcc0a0912052114v790f04c9h9a7367ff74d12426@mail.gmail.com>
Subject: Re: [PATCH 28/31] Constify struct super_operations for 2.6.32 v1
From: Alexey Dobriyan <adobriyan@gmail.com>
To: re.emese@gmail.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -   	struct inode *(*alloc_inode)(struct super_block *sb);
> +   	struct inode *(* const alloc_inode)(struct super_block *sb);

Good rule is if adding const doesn't move object from one section
to another, it isn't worth it.

I suggest we stick to it or risk another wave of jumbo patches.
