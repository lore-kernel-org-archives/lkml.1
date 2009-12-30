Return-Path: <linux-kernel-owner+w=401wt.eu-S1753071AbZL3TaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071AbZL3TaW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 14:30:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752807AbZL3TaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 14:30:21 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:57696 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574AbZL3TaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 14:30:21 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 02/10] vfs: get_sb_single() - do not pass options twice
References: <20091223194955.GB18101@kroah.com>
	<1261597963-18323-2-git-send-email-gregkh@suse.de>
	<87my14h9vo.fsf@devron.myhome.or.jp>
	<ac3eb2510912301005g4870332cm63ebb497c9faf9da@mail.gmail.com>
Date: Thu, 31 Dec 2009 04:30:11 +0900
In-Reply-To: <ac3eb2510912301005g4870332cm63ebb497c9faf9da@mail.gmail.com>
	(Kay Sievers's message of "Wed, 30 Dec 2009 19:05:58 +0100")
Message-ID: <87hbr8w98c.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers <kay.sievers@vrfy.org> writes:

> On Sun, Dec 27, 2009 at 13:36, OGAWA Hirofumi
> <hirofumi@mail.parknet.co.jp> wrote:
>>> Filesystem code usually destroys the option buffer while
>>> parsing it. This leads to errors when the same buffer is
>>> passed twice. In case we fill a new superblock do not call
>>> remount.
>
>> This breaks the historical behavior. Several users of get_sb_single() is
>> parse data only on ->remount_fs. Well, ok, I like new behavior actually.
>> But we need to convert to new behavior such users.
>>
>> I've listed all possibly affected users up (if I'm not missing). This
>> means, using both data on ->fill_super and ->remount_fs is devtmpfs
>> only. And capifs, usbfs, devpts would be needed the patch.
>
> Hmm, these filesystem are probably not going to overwrite their own
> default options with their own special parameters to parse when they
> allocate their superblock. That would be pretty weird, wouldn't it?
> Seems they currently don't even pass "data" pointer around at that
> time.

Oops, I was missing that those all fs was using kern_mount(). Sorry for
noise.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
