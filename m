Return-Path: <linux-kernel-owner+w=401wt.eu-S1758028AbZBLJGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028AbZBLJGR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 04:06:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754158AbZBLJF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 04:05:28 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:34781 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbZBLJFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 04:05:25 -0500
MIME-Version: 1.0
In-Reply-To: <20090212070210.GB6916@ldl.fc.hp.com>
References: <20090211202601.GC3402@ldl.fc.hp.com>
	 <20090211223903.GA21100@suse.de> <20090212025655.GA6916@ldl.fc.hp.com>
	 <20090212030227.GA4859@suse.de> <20090212070210.GB6916@ldl.fc.hp.com>
Date: Thu, 12 Feb 2009 10:05:23 +0100
Message-ID: <ac3eb2510902120105u17f5a0f9q13a228b9ff6ff3d4@mail.gmail.com>
Subject: Re: [PATCH] sysfs: sysfs_add_one tells you _where_ the duplicate file 
	is
From: Kay Sievers <kay.sievers@vrfy.org>
To: Alex Chiang <achiang@hp.com>, Greg KH <gregkh@suse.de>,
       alex.williamson@hp.com, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 12, 2009 at 08:02, Alex Chiang <achiang@hp.com> wrote:

> sysfs: sysfs_add_one WARNs with full path to duplicate filename
>
> As a debugging aid, it can be useful to know the full path to a
> duplicate file being created in sysfs.

>        ret = __sysfs_add_one(acxt, sd);
> -       WARN(ret == -EEXIST, KERN_WARNING "sysfs: duplicate filename '%s' "
> -                      "can not be created\n", sd->s_name);
> +       if (ret == -EEXIST) {
> +               char path[PATH_MAX];

Isn't that 4k on the stack, and a bit large to put there?

Thanks,
Kay
