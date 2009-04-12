Return-Path: <linux-kernel-owner+w=401wt.eu-S1753468AbZDLS5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468AbZDLS5V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 14:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751449AbZDLS5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 14:57:08 -0400
Received: from mail2.shareable.org ([80.68.89.115]:35936 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbZDLS5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 14:57:06 -0400
Date: Sun, 12 Apr 2009 19:56:59 +0100
From: Jamie Lokier <jamie@shareable.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
       Hugh Dickins <hugh@veritas.com>, Tejun Heo <tj@kernel.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [RFC][PATCH 8/9] vfs: Implement generic revoked file operations
Message-ID: <20090412185659.GE4394@shareable.org>
References: <m1skkf761y.fsf@fess.ebiederm.org> <m1prfj5qxp.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1prfj5qxp.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> revoked_file_ops return 0 from reads (aka EOF). Tell poll the file is
> always ready for I/O and return -EIO from all other operations.

I think read should return -EIO too.  If a program is reading from a
/proc file (say), and the thing it's reading suddenly disappears, EOF
gives the false impression that it's read to the end of formatted data
from that file and it can process the data as if it's complete, which
is wrong.

-- Jamie
