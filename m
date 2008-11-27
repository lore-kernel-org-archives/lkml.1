Return-Path: <linux-kernel-owner+w=401wt.eu-S1752779AbYK0RGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779AbYK0RGm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 12:06:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754515AbYK0RG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 12:06:27 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:42642 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754489AbYK0RG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 12:06:26 -0500
Date: Thu, 27 Nov 2008 12:06:15 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Matthew Garrett <mjg@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, mingo@redhat.com, val.henson@gmail.com,
       matthew@wil.cx
Subject: Re: [PATCH v3] relatime: Make relatime smarter
Message-ID: <20081127170615.GB14991@infradead.org>
References: <20081126195457.GA3541@srcf.ucam.org> <20081126195824.GB3541@srcf.ucam.org> <492DD035.5020705@oracle.com> <20081127150126.GA20941@srcf.ucam.org> <20081127150341.GB20941@srcf.ucam.org> <20081127163535.775729bf@lxorguk.ukuu.org.uk> <20081127164754.GC22963@srcf.ucam.org> <20081127165929.GA23366@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081127165929.GA23366@srcf.ucam.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2008 at 04:59:29PM +0000, Matthew Garrett wrote:
> Make relatime smarter
>     
> Allow atime to be updated once per day even with relatime. This lets
> utilities like tmpreaper (which delete files based on last access time)
> continue working. The time between atime updates can be configured at boot
> with the relatime_interval kernel argument, or at runtime through /proc

Technically it's sysctl which just happens to be exposed in /proc..

> +	if (mnt->mnt_flags & MNT_RELATIME)
> +		if (!relatime_need_update(inode, now))
> +			goto out;
>  	if (timespec_equal(&inode->i_atime, &now))

Maybe rename relatime_need_update to atime_need_update and factor
this check into it?

Except for this nitpicks this seems extremly useful
