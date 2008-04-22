Return-Path: <linux-kernel-owner+w=401wt.eu-S1762494AbYDVOIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762494AbYDVOIe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 10:08:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751907AbYDVOI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 10:08:26 -0400
Received: from sandeen.net ([209.173.210.139]:29986 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462AbYDVOIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 10:08:25 -0400
Message-ID: <480DF158.60909@sandeen.net>
Date: Tue, 22 Apr 2008 09:08:24 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: Denys Vlasenko <vda.linux@googlemail.com>
CC: David Chinner <dgc@sgi.com>, Adrian Bunk <bunk@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xfs: expose no-op xfs_put_perag()
References: <20080419142329.GA5339@elte.hu> <200804221532.22701.vda.linux@googlemail.com> <200804221540.12382.vda.linux@googlemail.com> <200804221546.58136.vda.linux@googlemail.com>
In-Reply-To: <200804221546.58136.vda.linux@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Denys Vlasenko wrote:
> Hi David,
> 
> Inline function xfs_put_perag() in fs/xfs/xfs_mount.h is a no-op.
> 
> This patch converts it to no-op macro.
> 
> As a result, gcc will emit warning about unused variables,
> parameters and so on not in this function, but in its callers,
> which is more useful.
> 
> This patch, together with previous ones, has already resulted
> in more unused params discovered and warned about by gcc.
> 
> There is no object code size difference from this change.

Denys, thanks for going through all this; I didn't mean to discount the
work with the stackcheck reports.  I've done a lot of similar xfs
pruning in the past, and every little bit helps.  It is still hard to
find significant reductions in the critical callchains though!

If the xfs codebase gets to the point where things are fairly well
cleaned up it might be nice to add the gcc warning to the makefiles, add
unused attributes to the vfs ops vectors as needed, and keep it clean
from this point on...

Thanks,

-Eric
