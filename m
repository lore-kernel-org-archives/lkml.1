Return-Path: <linux-kernel-owner+w=401wt.eu-S1753392AbYK0KKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392AbYK0KKo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 05:10:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752434AbYK0KKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 05:10:33 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:55146 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbYK0KKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 05:10:32 -0500
Date: Thu, 27 Nov 2008 05:10:23 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 6/6] fs: Introduce kern_mount_special() to mount
	special vfs
Message-ID: <20081127101023.GA1454@infradead.org>
References: <49267694.1030506@cosmosbay.com> <20081121.010508.40225532.davem@davemloft.net> <4926AEDB.10007@cosmosbay.com> <4926D022.5060008@cosmosbay.com> <20081121152148.GA20388@elte.hu> <4926D39D.9050603@cosmosbay.com> <20081121153453.GA23713@elte.hu> <492DDCAB.1070204@cosmosbay.com> <20081127095321.GE13860@infradead.org> <492E70B6.70108@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <492E70B6.70108@cosmosbay.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2008 at 11:04:38AM +0100, Eric Dumazet wrote:
> Hum.. we have a superblock flag already, but testing it in mntput()/mntget()
> is going to be a litle bit expensive if we add a derefence ?
>
> if (mnt && mnt->mnt_sb->s_flags & MS_SPECIAL) {
>   ...
> }

Well, run a benchmark to see if it makes any difference.  And when it
does please always set the mount flag from the common mount code when
it's set on the superblock, and document that this is the only valid way
to set it.

