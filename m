Return-Path: <linux-kernel-owner+w=401wt.eu-S1752055AbYHILuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055AbYHILuc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 07:50:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751809AbYHILt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 07:49:59 -0400
Received: from lazybastard.de ([212.112.238.170]:50779 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbYHILt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 07:49:58 -0400
Date: Sat, 9 Aug 2008 13:16:54 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: LogFS: confused with using s64 and u64
Message-ID: <20080809111653.GB30358@logfs.org>
References: <20080808211236.GB5093@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080808211236.GB5093@orion>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 August 2008 01:12:36 +0400, Alexander Beregalov wrote:
> 
> I am a bit confused with mixing signed and unsigned types here:
> 
> 
> static inline u64 dev_ofs(struct super_block *sb, u32 segno, u32 ofs)
> {
> 	return ((u64)segno << logfs_super(sb)->s_segshift) + ofs;
> }
> 
> static s64 logfs_get_free_bytes(struct logfs_area *area, size_t bytes)
> {
> 	s32 ofs;
> 	...
> 	ofs = area->a_used_bytes;
> 	...
> 	return dev_ofs(area->a_sb, area->a_segno, ofs);
> }
> 
> Can you please explain why do you use s64 for function which returns u64?

Sloppiness.  Until the 64bit limit actually gets close, I prefer to use
negative return values to indicate errors.  It would be possible to have
a seperate return value, as jffs2 does.  But functions with two return
values are just icky.  So many functions return s64

Functions that never return errors tend to use u64 instead.  And I mix
them fairly liberally, "knowing" (as a programmer) that u64 will never
overflow into a negative s64.

Some sort of cleanup in that area surely wouldn't hurt.

Jörn

-- 
Don't patch bad code, rewrite it.
-- Kernigham and Pike, according to Rusty
