Return-Path: <linux-kernel-owner+w=401wt.eu-S1946459AbXBINmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946459AbXBINmi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 08:42:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946460AbXBINmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 08:42:38 -0500
Received: from mail.parknet.jp ([210.171.160.80]:4131 "EHLO parknet.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946459AbXBINmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 08:42:37 -0500
X-AuthUser: hirofumi@parknet.jp
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Direct IO for fat
References: <20070208112808.GA3767@duck.suse.cz>
	<87k5ysfyd5.fsf@duaron.myhome.or.jp>
	<20070208161001.GB3767@duck.suse.cz>
	<87wt2sd2m8.fsf@duaron.myhome.or.jp>
	<20070208173515.GB3780@duck.suse.cz>
	<20070208184104.GA24986@atrey.karlin.mff.cuni.cz>
	<873b5g2zq9.fsf@duaron.myhome.or.jp>
	<20070209071955.GB5433@duck.suse.cz>
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Fri, 09 Feb 2007 22:42:29 +0900
In-Reply-To: <20070209071955.GB5433@duck.suse.cz> (Jan Kara's message of "Fri\, 9 Feb 2007 08\:19\:55 +0100")
Message-ID: <87y7n71m7u.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara <jack@suse.cz> writes:

>> I see. When I wrote this, I thought kernel should use DIO to write if
>> user sets O_DIRECT. Because the wrong alignment request isn't fallback
>> to buffered-write, and it's also returns EINVAL.
>   I understand. It's just that I've got some surprised users who could not
> track why the hell does write() return EINVAL to them when they have
> everything alligned and the same code works for EXT3 :). Of course, nothing
> guarantees that FAT should behave the same way as EXT3 but I can understand
> they were surprised (I had to look in the code too).
>   I also don't have a strong opinion whether we should fallback to buffered
> write automagically or whether we should return EINVAL and let the user fall
> back to the buffered write himself. But I'd slightly prefer the first
> option.

Hm, ok. I'll change EINVAL to zero as soon as possible after test.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
