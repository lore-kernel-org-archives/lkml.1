Return-Path: <linux-kernel-owner+w=401wt.eu-S1759794AbZFJOv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759794AbZFJOv7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 10:51:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758081AbZFJOvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 10:51:52 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:48682 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756886AbZFJOvw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 10:51:52 -0400
MIME-Version: 1.0
In-Reply-To: <1244644064-32737-1-git-send-email-tom.leiming@gmail.com>
References: <1244644064-32737-1-git-send-email-tom.leiming@gmail.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 10 Jun 2009 16:51:19 +0200
Message-ID: <ac3eb2510906100751s39768c87wb2a0b54544f66046@mail.gmail.com>
Subject: Re: [PATCH 1/2] driver core: introduce devtmpfs_wait_for_dev()
To: tom.leiming@gmail.com
Cc: greg@kroah.com, linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 10, 2009 at 16:27, <tom.leiming@gmail.com> wrote:

> This patch introduces devtmpfs_wait_for_dev(), which is based on devtmpfs
> and can be used to remove polling for root device before mounting rootfs.

> +       nodename = dev_path + 5;

I guess this is to strip "/dev/". Devtmpfs has no clue where it is
mounted, it is just a simple superblock.

I guess, the caller would better pass a relative path to it, to keep
all the implicit lookup magic with root=/dev/* in one place where the
commandline parsing and mounting happens? For the same reason
devtmpfs_mount() accepts a path instead of just assuming "/dev".

> +       if (strncmp(dev_path, "/dev/", 5) != 0)
> +               return -1;

Same here.

Thanks,
Kay
