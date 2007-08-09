Return-Path: <linux-kernel-owner+w=401wt.eu-S1759315AbXHISSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759315AbXHISSm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 14:18:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754526AbXHISSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 14:18:30 -0400
Received: from wx-out-0506.google.com ([66.249.82.229]:19903 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754256AbXHISS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 14:18:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pl6DJ3eGGIJ/Z58aiTxp2vSKBIRbODRRNnyK86jpFAE3d3V+gm6QuqzaVH72iyYgArbOp8Ef8xI5ZcxwYi6hMpfx1kC/fbja3kbSqC+iEYuUKIzKONO/FfjqBkktJWbjTrVN9Exodt2rSY8nfY7uMW/hC6Tub0rCEqKz78Ub2ZM=
Message-ID: <a52a95e30708091118k1aa962d8u214a7f0624df78e3@mail.gmail.com>
Date: Thu, 9 Aug 2007 11:18:27 -0700
From: "Tom Mortensen" <tmmlkml@gmail.com>
To: "Jeff Mahoney" <jeffm@suse.com>
Subject: Re: reiserfs fs/reiserfs/bitmap.c:1287
Cc: tony@tvortex.net, linux-kernel@vger.kernel.org,
       "ReiserFS Mailing List" <reiserfs-devel@vger.kernel.org>
In-Reply-To: <46BA57AC.2040306@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <15366.199.125.14.2.1184261266.squirrel@localmail-dr.mcsimons.com>
	 <46967D7D.5090204@suse.com>
	 <a52a95e30708081529i7cee02ddq61471378c2a12ffa@mail.gmail.com>
	 <46BA57AC.2040306@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Using mkreiserfs version 3.6.19.  But file system is less than 80GB.

On 8/8/07, Jeff Mahoney <jeffm@suse.com> wrote:

> In any event, something is corrupting your bitmaps and that needs to get
> tracked down. The size of the file system is important. I've been seeing
> reports of users hitting similar problems with file systems larger than
> 8 TiB. The cause is that the s_bmap_nr field in the superblock is 16
> bit, and the file system assumes it's correct. mkreiserfs < 3.6.20 will
> happily create those file systems with a value that has wrapped, while
> mkreiserfs >= 3.6.20 will zero the value out, causing a mount failure
> unless the kernel has been patched to support the full size and to
> interpret s_bmap_nr == 0 as "value has overflowed."
