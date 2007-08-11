Return-Path: <linux-kernel-owner+w=401wt.eu-S1756825AbXHKQHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825AbXHKQHW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 12:07:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751035AbXHKQHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 12:07:09 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50967 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbXHKQHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 12:07:08 -0400
Date: Sat, 11 Aug 2007 17:07:04 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Mark Cannon <random.bits@rogers.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Use of directories to hold root?
Message-ID: <20070811160704.GA21089@ftp.linux.org.uk>
References: <200708101724.26724.random.bits@rogers.com> <Pine.LNX.4.64.0708102332580.3054@fbirervta.pbzchgretzou.qr> <46BCFE01.2040703@zytor.com> <Pine.LNX.4.64.0708111753510.3101@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708111753510.3101@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 11, 2007 at 05:55:37PM +0200, Jan Engelhardt wrote:
> 
> On Aug 10 2007 17:08, H. Peter Anvin wrote:
> >Jan Engelhardt wrote:
> >> On Aug 10 2007 17:24, Mark Cannon wrote:
> >>> You pass the kernel the root option to specify the root partition.
> >>> Is there a way to identify a directory in that partition that holds the
> >>> root or something equivalent to this?
> >> 
> >> No, but you can use pivot_root.
> >
> >Or better yet, use an initramfs with MS_MOVE; same as you would with the
> >"normal" use of initramfs.
> 
> mount --move /foo /
> => error

mount("foo", "foo", NULL, MS_BIND, 0);
chdir("foo");
mount(".", "/", NULL, MS_MOVE, 0);
chroot(".");
