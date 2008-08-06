Return-Path: <linux-kernel-owner+w=401wt.eu-S1762984AbYHFClT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762984AbYHFClT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 22:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756345AbYHFCfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 22:35:30 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33141 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754492AbYHFCf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 22:35:29 -0400
To: Eric Paris <eparis@redhat.com>
Cc: malware-list@lists.printk.net, linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/5] [TALPA] Intro to a linux interface for on access scanning
From: Andi Kleen <andi@firstfloor.org>
References: <1217883616.27684.19.camel@localhost.localdomain>
Date: Wed, 06 Aug 2008 04:35:27 +0200
In-Reply-To: <1217883616.27684.19.camel@localhost.localdomain> (Eric Paris's message of "Mon, 04 Aug 2008 17:00:16 -0400")
Message-ID: <874p5y7tw0.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Paris <eparis@redhat.com> writes:

> 5. Fine-grained caching
> -----------------------
> It is necessary to select which filesystems can be safely cached and
> which must not be. For example it is not a good idea to allow caching of
> network filesystems because their content can be changed invisibly. Disk
> based and some virtual filesystems can be cached safely on the other
> hand.

Actually local disk file systems can be changed invisibly to the VFS too by 
directly writing to the block device. This does not change the
page cache, but the on disk copy and when a page is pruned from
RAM and reloaded VFS will see the new contents without knowing
about any change. How would you stop that in your
proposal? I assume you could always require a special LKM that
forbids block writes for anything mounted, but that has other problems 
too and one wuld need to be extremly careful of holes in
such a protection scheme (e.g. overlapping partitions) 

[haven't read the rest of the proposal]

-Andi

