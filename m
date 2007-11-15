Return-Path: <linux-kernel-owner+w=401wt.eu-S1762788AbXKOH1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762788AbXKOH1Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 02:27:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752586AbXKOH1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 02:27:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37216 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507AbXKOH1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 02:27:07 -0500
Message-ID: <473BF4C5.4080909@zytor.com>
Date: Wed, 14 Nov 2007 23:27:01 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 16/19] x86 setup: handle boot loaders which set up the
 stack incorrectly
References: <20071115054813.977066477@mini.kroah.org> <20071115061513.GQ7980@kroah.com>
In-Reply-To: <20071115061513.GQ7980@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> -stable review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> From: H. Peter Anvin <hpa@zytor.com>
> 
> patch 6b6815c6d5d1dc209701d1661a7a0e09a295db2f in mainline.
> 
> Apparently some specific versions of LILO enter the kernel with a
> stack pointer that doesn't match the rest of the segments.  Make our
> best attempt at untangling the resulting mess.
> 
> Signed-off-by: H. Peter Anvin <hpa@zytor.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

Just FYI:

It has been reported that while this patch fixes old LILO, and possibly 
some other boot loaders (unknown), it has also broken older versions of 
SYSLINUX: they still boot, but the command line is truncated (exactly 
how much depends on the BIOS, but typical values are around 130 bytes.)

This is definitely traceable to a bug in SYSLINUX that was already fixed 
in release 3.50 (the current version of SYSLINUX is 3.52).

I have chosen to leave the patch in mainline, rather than trying yet 
another recipe and hope it doesn't break on some other random 
combination of bootloaders, since:

a) SYSLINUX is generally easily updated, compared to other bootloaders;
b) The failure mode is less severe (it still boots.)

... however, you may choose to call differently.

	-hpa
