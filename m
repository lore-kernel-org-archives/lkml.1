Return-Path: <linux-kernel-owner+w=401wt.eu-S1765545AbXKOQn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765545AbXKOQn1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 11:43:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759045AbXKOQnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 11:43:08 -0500
Received: from ns.suse.de ([195.135.220.2]:40096 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758758AbXKOQnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 11:43:06 -0500
Date: Thu, 15 Nov 2007 08:42:14 -0800
From: Greg KH <gregkh@suse.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 16/19] x86 setup: handle boot loaders which set up the
	stack incorrectly
Message-ID: <20071115164214.GF24087@suse.de>
References: <20071115054813.977066477@mini.kroah.org> <20071115061513.GQ7980@kroah.com> <473BF4C5.4080909@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <473BF4C5.4080909@zytor.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2007 at 11:27:01PM -0800, H. Peter Anvin wrote:
> Greg KH wrote:
>> -stable review patch.  If anyone has any objections, please let us know.
>> ------------------
>> From: H. Peter Anvin <hpa@zytor.com>
>> patch 6b6815c6d5d1dc209701d1661a7a0e09a295db2f in mainline.
>> Apparently some specific versions of LILO enter the kernel with a
>> stack pointer that doesn't match the rest of the segments.  Make our
>> best attempt at untangling the resulting mess.
>> Signed-off-by: H. Peter Anvin <hpa@zytor.com>
>> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>
> Just FYI:
>
> It has been reported that while this patch fixes old LILO, and possibly 
> some other boot loaders (unknown), it has also broken older versions of 
> SYSLINUX: they still boot, but the command line is truncated (exactly how 
> much depends on the BIOS, but typical values are around 130 bytes.)
>
> This is definitely traceable to a bug in SYSLINUX that was already fixed in 
> release 3.50 (the current version of SYSLINUX is 3.52).
>
> I have chosen to leave the patch in mainline, rather than trying yet 
> another recipe and hope it doesn't break on some other random combination 
> of bootloaders, since:
>
> a) SYSLINUX is generally easily updated, compared to other bootloaders;
> b) The failure mode is less severe (it still boots.)
>
> ... however, you may choose to call differently.

I have no objection to keeping this patch in the tree, as it fixes a
real problem, and matches the upstream kernel version.

thanks,

greg k-h
