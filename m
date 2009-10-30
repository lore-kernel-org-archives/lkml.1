Return-Path: <linux-kernel-owner+w=401wt.eu-S1756433AbZJ3BWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433AbZJ3BWb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 21:22:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756241AbZJ3BWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 21:22:30 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:54922 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753668AbZJ3BW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 21:22:29 -0400
Date: Thu, 29 Oct 2009 21:22:24 -0400 (EDT)
From: Tim Abbott <tabbott@ksplice.com>
X-X-Sender: tabbott@dr-wily.mit.edu
To: Greg Ungerer <gerg@snapgear.com>
cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH v4 1/7] m68knommu: Don't hardcode the value of PAGE_SIZE
 in the linker script.
In-Reply-To: <4AEA39EB.50601@snapgear.com>
Message-ID: <alpine.DEB.1.10.0910292118390.24830@dr-wily.mit.edu>
References: <alpine.DEB.1.10.0910142041520.6638@dr-wily.mit.edu> <1255886635-17371-1-git-send-email-tabbott@ksplice.com> <4AEA39EB.50601@snapgear.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Oct 2009, Greg Ungerer wrote:

> Hi Tim,
> 
> This one gives me:
> 
> arch/m68knommu/kernel/vmlinux.lds.S:19:1: warning: "BSS" redefined
> In file included from arch/m68knommu/kernel/vmlinux.lds.S:10:
> include/asm-generic/vmlinux.lds.h:495:1: warning: this is the location of the
> previous definition
> 
> A define named "BSS" is already used inside of vmlinux.lds.S.
> No big deal, I just changed that internal one.
> 
> But otherwise no problems with this patch.

This actually wasn't introduced by this patch -- it was introduced when 
the BSS macro was merged into include/asm-generic/vmlinux.lds.h in commit 
ef53dae8658cf0e93d380983824a661067948d87.

Regardless, changing the internal one was the right fix.

	-Tim Abbott
