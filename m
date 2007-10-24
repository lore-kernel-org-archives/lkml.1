Return-Path: <linux-kernel-owner+w=401wt.eu-S1756438AbXJXFI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438AbXJXFI5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 01:08:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754030AbXJXFIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 01:08:50 -0400
Received: from gw.goop.org ([64.81.55.164]:49886 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753987AbXJXFIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 01:08:49 -0400
Message-ID: <471ED35F.3020605@goop.org>
Date: Tue, 23 Oct 2007 22:08:47 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: David Chinner <dgc@sgi.com>
CC: Andi Kleen <andi@firstfloor.org>, dean gaudet <dean@arctic.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Xen-devel <xen-devel@lists.xensource.com>, Morten@suse.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       =?ISO-8859-1?Q?B=F8geskov?= <xen-users@morten.bogeskov.dk>,
       xfs@oss.sgi.com, xfs-masters@oss.sgi.com,
       Mark Williamson <mark.williamson@cl.cam.ac.uk>
Subject: Re: [PATCH] Allow lazy unmapping by taking extra page references
 V2
References: <alpine.DEB.0.9999.0710212015430.2320@twinlark.arctic.org> <471C1A61.1010001@goop.org> <p73sl439s7k.fsf@bingen.suse.de> <471CEEB4.9040807@goop.org> <20071022190740.GA1695@one.firstfloor.org> <20071022223224.GC995458@sgi.com> <20071022233514.GA9057@one.firstfloor.org> <20071023003641.GF995458@sgi.com> <20071023070414.GM66820511@sgi.com> <20071023093035.GB24536@one.firstfloor.org> <20071024043619.GE66820511@sgi.com>
In-Reply-To: <20071024043619.GE66820511@sgi.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Chinner wrote:
> Allow lazy unmapping of vmap()d regions be taking a reference
> on each page in the region being vmap()ed. The page references
> get released after the region is vunmap()ed, thereby ensuring
> we don't leave stray mappings on freed pages that could lead to
> problems pages being reallocated with incorrect mappings
> associated with them.
>
> Tested with XFS filesystems with 64k directory blocks with
> dirstress and XFSQA.
>
> Version 2:
>   - drop the release function stuff and just call put_page()
>     as it falls down to the same code in all calling cases.
>   

This doesn't apply cleanly to the current git tree.

    J

