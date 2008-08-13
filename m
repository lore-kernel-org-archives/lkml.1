Return-Path: <linux-kernel-owner+w=401wt.eu-S1754015AbYHMWFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbYHMWFz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 18:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752133AbYHMWFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 18:05:47 -0400
Received: from ishtar.tlinx.org ([64.81.245.74]:36014 "EHLO ishtar.tlinx.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751702AbYHMWFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 18:05:47 -0400
Message-ID: <48A35A99.1080300@tlinx.org>
Date: Wed, 13 Aug 2008 15:05:13 -0700
From: Linda Walsh <xfs@tlinx.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>, xfs-oss <xfs@oss.sgi.com>
CC: LKML <linux-kernel@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>
Subject: Re: XFS Lock debugging noise or real problem?
References: <48A093A7.40606@tlinx.org> <48A09CA9.9080705@sandeen.net> <48A0F686.2090700@tlinx.org> <48A0F9FC.1070805@sandeen.net> <48A20E9E.9090100@tlinx.org> <20080813005852.GW6119@disturbed>
In-Reply-To: <20080813005852.GW6119@disturbed>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner wrote:
> Once again,
> "a problem with the generic code inverting the normal lock order".
>
> This one cannot deadlock, though, because by definition
> any inode on the unused list is, well, unused and hence we can't be
> holding a reference to it...
----

	This is great, maybe...but what do you mean by "generic"?

	Is this generic in the FS layer such that we'd see
this with all FS types?  Or is it generic "XFS" code that only
happens with various, "application", (user) coded applications that
use locking in a correct, but non-standard order?  Some of these
messages come out of utilities that I wouldn't think would be using
kernel-locking, 'explicitly', at all (gnu-sort).

	If the generic code didn't invert lock orders from the "norm",
could these errors be deleted?  Is it code that all resides in the
kernel and could be made consistent or is it also user-level (or glibc)
apps that are using locks in strange, but correct ways?

I'd *like* to keep lock provability 'on' -- but I don't want
to waste people's time chasing after non-problems and so far I've
seen at least 3 different locking sequences that all appear to be
harmless.

	The problem with false positives is that it will either force
the user to ignore (or turn off) the validation code, or generate
periodic noise when these things arise...

	Isn't it generally considered pretty 'bad' to generate so many
false positives -- or is lock-proving only for for "lock debugging" --
and not to be used except on development or test systems?

