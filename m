Return-Path: <linux-kernel-owner+w=401wt.eu-S1755108AbYK3Ncm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108AbYK3Ncm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 08:32:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751402AbYK3Ncd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 08:32:33 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:53075 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbYK3Ncc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 08:32:32 -0500
Date: Sun, 30 Nov 2008 13:32:29 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, gregkh@suse.de,
       petero2@telia.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix pktcdvd breakage from commit
	e105b8bfc769b0545b6f0f395179d1e43cbee822
Message-ID: <20081130133229.GZ28946@ZenIV.linux.org.uk>
References: <20081130121909.GV28946@ZenIV.linux.org.uk> <ac3eb2510811300441m2a551cc7nec0374bb7a707bb8@mail.gmail.com> <20081130132118.GY28946@ZenIV.linux.org.uk> <ac3eb2510811300525n2e47ccap65e897ac1c4adab5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac3eb2510811300525n2e47ccap65e897ac1c4adab5@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 30, 2008 at 02:25:43PM +0100, Kay Sievers wrote:

> Pktcdvd creates char _and_ block device nodes at the same time, while
> the char nodes are not allocated, but created and conflict in
> /sys/dev/ with properly allocated ones from other subsystems. Your
> patch just papers over this bug.

Where the hell is it creating any char device nodes?  Show me.
And note that device_create() is not creating *any* device nodes,
char or block.  It creates a directory in some place in sysfs,
associated with struct device (which has arseloads of uses unrelated
to block *or* char devices) and, if dev_t argument is non-zero,
dumps its value into one of the attributes.

These days it might also dump a symlink into /sys/dev/*.

Which part of the above constitutes a creation of char device node?
