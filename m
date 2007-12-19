Return-Path: <linux-kernel-owner+w=401wt.eu-S1757991AbXLSCqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757991AbXLSCqj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 21:46:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751672AbXLSCqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 21:46:32 -0500
Received: from hs-out-0708.google.com ([64.233.178.251]:10291 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751135AbXLSCqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 21:46:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YKoJiL3tGrtMoEEHz2H/qUiNcSCn1QcHab1X1KD3y1VktA/3PP4eH+y3xU1STODuZqHmWV65uPDVv53Z1WA/1p8QkuznSufuEXRGIuELC0Jbu+XpraQwKwwgISrY+lVRdp8TJEtSEBf0tmmUETyMhmt4ax1bbUhgFMmC/Frg2Os=
Message-ID: <dda83e780712181846w5549fe0bs7589d67b9d86c666@mail.gmail.com>
Date: Tue, 18 Dec 2007 18:46:30 -0800
From: "Bret Towe" <magnade@gmail.com>
To: "Christoph Hellwig" <hch@infradead.org>
Subject: Re: xfs mknod regression
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
In-Reply-To: <20071218173642.GA7338@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dda83e780712172048n4d40cfcbw4a4d3106fc99f02e@mail.gmail.com>
	 <20071218173642.GA7338@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 18, 2007 9:36 AM, Christoph Hellwig <hch@infradead.org> wrote:
>
> This was broken by my '[XFS] simplify xfs_create/mknod/symlink prototype',
> which assigned the re-shuffled ondisk dev_t back to the rdev variable in
> xfs_vn_mknod.  Because of that i_rdev is set to the ondisk dev_t instead
> of the linux dev_t later down the function.
>
> Fortunately the fix for it is trivial:  we can just remove the
> assignment because xfs_revalidate_inode has done the proper job before
> unlocking the inode.
>
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

tested the patch on 2 machines and works fine for me

Thanks
