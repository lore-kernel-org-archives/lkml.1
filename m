Return-Path: <linux-kernel-owner+w=401wt.eu-S1755053AbZA2FPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053AbZA2FPA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 00:15:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751358AbZA2FOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 00:14:48 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53923 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbZA2FOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 00:14:48 -0500
Date: Thu, 29 Jan 2009 14:13:38 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Greg KH <greg@kroah.com>
Cc: mtk.manpages@gmail.com, linux-man@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: open(2) says O_DIRECT works on 512 byte boundries?
Message-Id: <20090129141338.34e44a1f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090128213322.GA15789@kroah.com>
References: <20090128213322.GA15789@kroah.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jan 2009 13:33:22 -0800
Greg KH <greg@kroah.com> wrote:

> In looking at open(2), it says that O_DIRECT works on 512 byte boundries
> with the 2.6 kernel release:
> 	Under Linux 2.4, transfer sizes, and the alignment of the user
> 	buffer and  the file offset must all be multiples of the logical
> 	block size of the file system.  Under Linux 2.6, alignment  to
> 	512-byte  boundaries suffices.
> 
> However if you try to access an O_DIRECT opened file with a buffer that
> is PAGE_SIZE aligned + 512 bytes, it fails in a bad way (wrong data is
> read.)
> 

IIUC, it's not related to 512bytes boundary. Just a race between
direct-io v.s. copy-on-write. Copy-on-Write while reading a page via DIO
is a problem.

Maybe it's true that if buffer is aligned to page size, no copy-on-write will
happen in usual program. But assuming HugeTLB page, which does Copy-on-Write,
data corruption will happen again. HugeTLB aligned buffer is nonsense.

Thanks,
-Kame


> Is this just a mistake in the documentation?  Or am I reading it
> incorrectly?
> 
> I have a test program that shows this if anyone wants it.
> 
> thanks,
> 
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

