Return-Path: <linux-kernel-owner+w=401wt.eu-S1754165AbZEDJfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165AbZEDJfz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 05:35:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752851AbZEDJfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 05:35:45 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57109 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334AbZEDJfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 05:35:45 -0400
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: compat ioctl32 for /dev/snapshot?
From: Andi Kleen <andi@firstfloor.org>
References: <49FEB572.4010909@msgid.tls.msk.ru>
Date: Mon, 04 May 2009 11:35:43 +0200
In-Reply-To: <49FEB572.4010909@msgid.tls.msk.ru> (Michael Tokarev's message of "Mon, 04 May 2009 13:29:22 +0400")
Message-ID: <87prepgqhc.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Tokarev <mjt@tls.msk.ru> writes:

> Is there any reason why 32-bit uswsusp &Friends does not work
> on 64bits kernel?
>
> For one, 32bits s2disk produces the following when trying to
> suspend:
>
>  ioctl32(s2disk:4134): Unknown cmd fd(4) cmd(400c330d){t:'3';sz:12} arg(ff853554) on /dev/snapshot
>  ioctl32(s2disk:4134): Unknown cmd fd(4) cmd(4004330a){t:'3';sz:4} arg(00000805) on /dev/snapshot
>
> this is coming from:
>
>     error = ioctl(dev, SNAPSHOT_SET_SWAP_AREA, &swap);
>     if (error && !offset)
>             error = ioctl(dev, SNAPSHOT_SET_SWAP_FILE, blkdev);
>
> but I guess (just guess!) that other SNAPSHOT_* operations will
> also fail the same way.
>
> Is there a reason why those are not in compat_ioctl?

It's probably just that nobody has written the code yet. In general all
missing compat_ioctls are bugs.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
