Return-Path: <linux-kernel-owner+w=401wt.eu-S1761988AbZAVR5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761988AbZAVR5a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 12:57:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759057AbZAVRzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 12:55:04 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:42963 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761369AbZAVRzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 12:55:01 -0500
Date: Thu, 22 Jan 2009 18:56:45 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andrew Walrond <andrew@walrond.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.28 headers break kbd and net-tools userspace builds
Message-ID: <20090122175645.GA14178@uranus.ravnborg.org>
References: <49786A59.6040706@walrond.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49786A59.6040706@walrond.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2009 at 12:45:13PM +0000, Andrew Walrond wrote:
> Breaks kbd like this:
> 
>  /usr/include/linux/serial.h:164: error: expected 
> specifier-qualifier-list before '__u32'

This is know and fixed. The fix is to include linux/types.h
in serial.h.

> 
> and net-tools like this:
> 
>  In file included from /usr/include/linux/if_tunnel.h:5,
>                   from iptunnel.c:39:
>  /usr/include/linux/ip.h:85: error: redefinition of 'struct iphdr'
> 
> Both build fine with 2.6.27.10 headers.

Herbert added an include of ip.h in commit:

commit c19e654ddbe3831252f61e76a74d661e1a755530
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Thu Oct 9 11:59:55 2008 -0700

    gre: Add netlink interface

    This patch adds a netlink interface that will eventually displace
    the existing ioctl interface.  It utilises the elegant rtnl_link_ops
    mechanism.

This causes struct iphdr to be redefined.
But there is noting wrong in including ip.h in if_tunnel.h.

I checked the include guards and they are correct.

Could you please investige where it picks up the first definition
of struct iphdr.

> Hope that's useful.

Anything that can improve the exported user headers are useful - thanks.

	Sam
