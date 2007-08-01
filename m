Return-Path: <linux-kernel-owner+w=401wt.eu-S1755982AbXHAWYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982AbXHAWYa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 18:24:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753611AbXHAWYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 18:24:23 -0400
Received: from cantor.suse.de ([195.135.220.2]:60511 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753453AbXHAWYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 18:24:22 -0400
Date: Wed, 1 Aug 2007 15:25:23 -0700
From: Greg KH <gregkh@suse.de>
To: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: debugfs helper for decimal challenged
Message-ID: <20070801222523.GA26289@suse.de>
References: <200708011752.58481.rgetz@blackfin.uclinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708011752.58481.rgetz@blackfin.uclinux.org>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2007 at 05:52:58PM -0400, Robin Getz wrote:
> Greg:
> 
> For those of us who forget that when bits 21 and bit 31 in a hardware 
> register exposed with debugfs, I should see 2149580800 when I cat it (vs
> 0x80200000), any objections to providing a hex output interface to the 
> debugfs?
> 
> Since the input side already takes decimal & hex, I don't think this is a big
> change:
> 
> DEFINE_SIMPLE_ATTRIBUTE(fops_x16, debugfs_u16_get, debugfs_u16_set, "0x%04llx\n");
> 
> struct dentry *debugfs_create_x16(const char *name, mode_t mode,
>                                   struct dentry *parent, u16 *value)
> {
>         return debugfs_create_file(name, mode, parent, value, &fops_x16);
> }
> 
> DEFINE_SIMPLE_ATTRIBUTE(fops_x32, debugfs_u32_get, debugfs_u32_set, "0x%08llx\n");
> 
> struct dentry *debugfs_create_x32(const char *name, mode_t mode,
>                                   struct dentry *parent, u32 *value)
> {
>         return debugfs_create_file(name, mode, parent, value, &fops_x32);
> }
> 
> If this is OK - I will send a real patch.

That sounds good to me, feel free to send a real patch.

thanks,

greg k-h
