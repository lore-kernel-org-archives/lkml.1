Return-Path: <linux-kernel-owner+w=401wt.eu-S932233AbZGRGQN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932233AbZGRGQN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 02:16:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751594AbZGRGQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 02:16:08 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53097 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbZGRGQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 02:16:07 -0400
To: device-mapper development <dm-devel@redhat.com>
Cc: Neil Brown <neilb@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: How to handle >16TB devices on 32 bit hosts ??
From: Andi Kleen <andi@firstfloor.org>
References: <19041.4714.686158.130252@notabene.brown>
	<20090718043155.GI4231@webber.adilger.int>
Date: Sat, 18 Jul 2009 08:16:05 +0200
In-Reply-To: <20090718043155.GI4231@webber.adilger.int> (Andreas Dilger's message of "Sat, 18 Jul 2009 00:31:55 -0400")
Message-ID: <871voewm6y.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Dilger <adilger@sun.com> writes:
>
> I think the point is that for those people who want to use > 16TB
> devices on 32-bit platforms (e.g. embedded/appliance systems) the
> choice is between "completely non-functional" and "uses a bit more
> memory per page", and the answer is pretty obvious.

It's not just more memory per page, but also worse code all over the
VM. long long 32bit code is generally rather bad, especially on
register constrained x86.

But I think the fsck problem is a show stopper here anyways.
Enabling a setup that cannot handle IO errors wouldn't 
be really a good idea.

In fact this problem already hits before 16TB on 32bit.

Unless people rewrite fsck to use /dev/shm >4GB swapping
(or perhaps use JFS which iirc had a way to use the file system
itself as fsck scratch space)

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
