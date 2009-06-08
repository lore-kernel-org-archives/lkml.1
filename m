Return-Path: <linux-kernel-owner+w=401wt.eu-S1753561AbZFHJlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561AbZFHJlx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 05:41:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752992AbZFHJlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 05:41:44 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:50412 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbZFHJln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 05:41:43 -0400
To: viro@ZenIV.linux.org.uk
CC: ebiederm@xmission.com, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, hugh@veritas.com, tj@kernel.org,
       adobriyan@gmail.com, torvalds@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, gregkh@suse.de, npiggin@suse.de,
       akpm@linux-foundation.org, hch@infradead.org
In-reply-to: <20090606080334.GA15204@ZenIV.linux.org.uk> (message from Al Viro
	on Sat, 6 Jun 2009 09:03:34 +0100)
Subject: Re: [PATCH 0/23] File descriptor hot-unplug support v2
References: <m1skkf761y.fsf@fess.ebiederm.org> <m1oct739xu.fsf@fess.ebiederm.org> <20090606080334.GA15204@ZenIV.linux.org.uk>
Message-Id: <E1MDbLz-0003wm-Db@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 08 Jun 2009 11:41:19 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Jun 2009, Al Viro wrote:
> Frankly, I very much suspect that force-umount is another case like that;
> we'll need a *lot* of interesting cooperation from fs for that to work and
> to be useful.  I'd be delighted to be proven incorrect on that one, so
> if you have anything serious in that direction, please share the details.

Umm, not sure why we'd need cooperation from the fs.  Simply wait for
the operation to exit the filesystem or driver.  If it's a blocking
operation, send a signal to interrupt it.

Sure, filesystems and drivers have lots of state, but we don't need to
care about that, just like we don't need to care about it for
remounting read-only.

Thanks,
Miklos
