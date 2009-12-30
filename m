Return-Path: <linux-kernel-owner+w=401wt.eu-S1753215AbZL3SGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215AbZL3SGQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 13:06:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753193AbZL3SGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 13:06:15 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:45112 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147AbZL3SGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 13:06:14 -0500
MIME-Version: 1.0
In-Reply-To: <87my14h9vo.fsf@devron.myhome.or.jp>
References: <20091223194955.GB18101@kroah.com> <1261597963-18323-2-git-send-email-gregkh@suse.de> 
	<87my14h9vo.fsf@devron.myhome.or.jp>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 30 Dec 2009 19:05:58 +0100
Message-ID: <ac3eb2510912301005g4870332cm63ebb497c9faf9da@mail.gmail.com>
Subject: Re: [PATCH 02/10] vfs: get_sb_single() - do not pass options twice
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 27, 2009 at 13:36, OGAWA Hirofumi
<hirofumi@mail.parknet.co.jp> wrote:
>> Filesystem code usually destroys the option buffer while
>> parsing it. This leads to errors when the same buffer is
>> passed twice. In case we fill a new superblock do not call
>> remount.

> This breaks the historical behavior. Several users of get_sb_single() is
> parse data only on ->remount_fs. Well, ok, I like new behavior actually.
> But we need to convert to new behavior such users.
>
> I've listed all possibly affected users up (if I'm not missing). This
> means, using both data on ->fill_super and ->remount_fs is devtmpfs
> only. And capifs, usbfs, devpts would be needed the patch.

Hmm, these filesystem are probably not going to overwrite their own
default options with their own special parameters to parse when they
allocate their superblock. That would be pretty weird, wouldn't it?
Seems they currently don't even pass "data" pointer around at that
time.

It's a bit different with tmpfs as we use it as a generic backend for
a special purpose filesystem.

What's the issue you are seeing, or have in mind?

Thanks,
Kay
