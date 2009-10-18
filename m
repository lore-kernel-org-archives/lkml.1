Return-Path: <linux-kernel-owner+w=401wt.eu-S1752819AbZJRHrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819AbZJRHrr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 03:47:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752678AbZJRHrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 03:47:46 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:47941 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbZJRHrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 03:47:45 -0400
Date: Sun, 18 Oct 2009 09:47:45 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Steven King <sfking@fdwdc.com>
Cc: linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org,
       uclinux-dev@uclinux.org, Greg Ungerer <gerg@snapgear.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [PATCH] Merge m68k and m68knommu
Message-ID: <20091018074745.GA13755@merkur.ravnborg.org>
References: <200910171802.59072.sfking@fdwdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910171802.59072.sfking@fdwdc.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 17, 2009 at 06:02:58PM -0700, Steven King wrote:
> This is a script and patch to merge the m68knommu arch into m68k.
> 
> The script was inspired by the script Sam Ravnborg used to merge the 
> includes from m68knommu. For those files common to both arches but 
> differing in content, the m68k version of the file is renamed to 
> <file>_mm.<ext> and the m68knommu version of the file is moved into the 
> corresponding m68k directory and renamed <file>_no.<ext> and a small 
> wrapper file <file>.<ext> is used to select between the two version. Files 
> that are common to both but don't differ are removed from the m68knommu 
> tree and files and directories that are unique to the m68knommu tree are 
> moved to the m68k tree. Finally, the arch/m68knommu tree is removed.
> 
> To select between the the versions of the files, the wrapper uses
> 
> #ifdef CONFIG_MMU
> #include <file>_mm.<ext>
> #else
> #include <file>_no.<ext>
> #endif
> 
> The patch modifies the toplevel Makefile so that ARCH=m68knommu still works 
> (by setting SRCARCH=m68k) and adds the m68knommu Kconfig and Makefile 
> to the m68k Kconfig and Makefile, using the definition of ARCH to select 
> which values to use.
> 
> Thus when building for either a m68k or an m68knommu target, one still 
> specifies either ARCH=m68k or ARCH=m68knommu and everything should 
> build EXACTLY as it did pre-merge.  (I think).

Hi Steven.

This looks good!
The mechanical method you are using really makes it simple to do
the merge.
And it also nicely highlights which files that really differs.

There is obviously more that can be merged later
but this is the first and biggest step.

> 
> Signed-off-by: Steven King <sfking@fdwdc.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>

	Sam
