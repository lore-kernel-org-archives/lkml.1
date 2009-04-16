Return-Path: <linux-kernel-owner+w=401wt.eu-S1753030AbZDPFBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030AbZDPFBs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 01:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751413AbZDPFBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 01:01:36 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:61760 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbZDPFBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 01:01:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rcydT3uIkUP1W44gllUoCeFpyLHFYzaXsYB8Eg0lZY7ilw5KXybOlSvCsAH/qvRUuQ
         6V1VF/nUSBeHd+ibMLHIWgpvbQP1/TuhKlpB31rnKQFPdwDKe4GMuoctzYuW7jN+Yu04
         6EeAtH6jp6pfFAKZviPgOEFsIO+oEm8iYbM0Q=
Date: Thu, 16 Apr 2009 14:01:29 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, wli@holomorphy.com, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] hugetlbfs: return negative error code for bad mount
	option
Message-ID: <20090416050129.GA4083@localhost.localdomain>
References: <20090413035623.GA4156@localhost.localdomain> <20090415145910.22910363.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090415145910.22910363.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 15, 2009 at 02:59:10PM -0700, Andrew Morton wrote:
> On Mon, 13 Apr 2009 12:56:23 +0900
> Akinobu Mita <akinobu.mita@gmail.com> wrote:
> 
> > This fixes the following BUG:
> > 
> > # mount -o size=MM -t hugetlbfs none /huge
> > hugetlbfs: Bad value 'MM' for mount option 'size=MM'
> > ------------[ cut here ]------------
> > kernel BUG at fs/super.c:996!
> 
> I can't tell where this BUG (or WARN?) is happening unless I know
> exactly which kernel version was tested.

Oh, sorry.

> I assume that it is BUG_ON(!mnt->mnt_sb); in vfs_kern_mount()?

Yes. In vfs_kern_mount(), type->get_sb() returns 1 then BUG_ON(!mnt->mnt_sb);
