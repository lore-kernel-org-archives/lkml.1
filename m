Return-Path: <linux-kernel-owner+w=401wt.eu-S1754888Ab0ANDcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888Ab0ANDcx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 22:32:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753653Ab0ANDcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 22:32:52 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:48344 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab0ANDcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 22:32:52 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/2] vfs: Fix refcnt leak with __do_follow_link() in do_filp_open()
References: <87vdf8jxug.fsf@devron.myhome.or.jp>
	<87r5pwjxr2.fsf@devron.myhome.or.jp>
	<20100113195059.GC4673@ZenIV.linux.org.uk>
	<20100113200711.GD19799@ZenIV.linux.org.uk>
Date: Thu, 14 Jan 2010 12:32:49 +0900
In-Reply-To: <20100113200711.GD19799@ZenIV.linux.org.uk> (Al Viro's message of
	"Wed, 13 Jan 2010 20:07:11 +0000")
Message-ID: <87pr5dfjj2.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> writes:

> On Wed, Jan 13, 2010 at 07:51:00PM +0000, Al Viro wrote:
>
>> Point, but... that's not the way I'd do it (again, see #untested for the
>> direction it's heading).  What we ought to do is simply "put ourselves
>> in trust-no-one mode (LOOKUP_REVAL) and restart the entire thing; if
>> we'd already been through that, fail immediately".
>> 
>> And yes, it needs to be pulled in front of queue and go in before .34.
>> Will do shortly.
>
> See commit 1fe1244faf0e862342bd2ae29e341cc957469aee in vfs-2.6.git#for-linus
> (that's going to be rc5 fixes push tonight, after several more things get
> shifted there).

Thanks. I'll see later.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
