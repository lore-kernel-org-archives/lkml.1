Return-Path: <linux-kernel-owner+w=401wt.eu-S1756423AbYD2WCF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423AbYD2WCF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 18:02:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756589AbYD2WBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 18:01:50 -0400
Received: from el-out-1112.google.com ([209.85.162.181]:51096 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754293AbYD2WBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 18:01:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KV0+QQl/YHIHh0h5KIPKlK527Ln8JDMSdgoZpuYJ09msc030PAM8gamyTHcJXHiZiPU8dOXsdJLFxeX+mtgQCbftowjmumSqhhZphOciN6Vrx3/BO4pqNS1e41dQW6xsEArSks2W2UGCMFCX+ajpkLiXDBIeLRqJMW5kpFB3sVw=
Message-ID: <8bd0f97a0804291501i2751d688h933508df2a4587b4@mail.gmail.com>
Date: Tue, 29 Apr 2008 18:01:47 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [LTP/VFS] fcntl SETLEASE fails on ramfs/tmpfs
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Bryan Wu" <cooloney@kernel.org>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, willy@debian.org,
       viro@zeniv.linux.org.uk, uclinux-dist-devel@blackfin.uclinux.org,
       richterd@citi.umich.edu
In-Reply-To: <20080429214231.GC26468@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <386072610804282042y2dda4b52h927683a8a938ce1f@mail.gmail.com>
	 <20080429135454.efebec8f.akpm@linux-foundation.org>
	 <20080429214231.GC26468@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 5:42 PM, J. Bruce Fields <bfields@fieldses.org> wrote:
>  The one thing I suspect is *not* a really serious problem here is the
>  reported LTP failure, since probably the only user of this is Samba,
>  which probably doesn't do a lot of tmpfs exports, and in any case it can
>  probably soldier on (if with degraded performance--how badly I don't
>  know) without getting the write lease it wants.

i'm not sure i follow.  the reported problem is that file locking does
not work on tmpfs/ramfs storage.  a not terribly uncommon scenario is
to use tmpfs on /tmp (or similar location) and have file locking not
work at all.  so programs that use file locking or scripts that
leverage the flock utility from the util-linux package break.
-mike
