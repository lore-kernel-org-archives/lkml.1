Return-Path: <linux-kernel-owner+w=401wt.eu-S1754221AbXJ1KkH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221AbXJ1KkH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 06:40:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751136AbXJ1Kjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 06:39:52 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44250 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbXJ1Kjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 06:39:51 -0400
Date: Sun, 28 Oct 2007 10:34:15 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Joe Perches <joe@perches.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, akpm@osdl.org, torvalds@osdl.org,
       viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH] proc_fs.h redux
Message-ID: <20071028103415.GA12554@flint.arm.linux.org.uk>
Mail-Followup-To: Joe Perches <joe@perches.com>,
	Alexey Dobriyan <adobriyan@gmail.com>, akpm@osdl.org,
	torvalds@osdl.org, viro@zeniv.linux.org.uk,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	linux-arch@vger.kernel.org
References: <20071027194758.GD9816@martell.zuzino.mipt.ru> <1193524804.26695.103.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1193524804.26695.103.camel@localhost>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 27, 2007 at 03:40:04PM -0700, Joe Perches wrote:
> and forward declarations of
> 
> struct proc_dir_entry;
> struct file_operations;
> 
> As a general rule, I think it better to use includes
> than use naked forward declarations.

If you go down that route, you end up with _lots_ of circular
dependencies - header file X needs Y needs Z which needs X.  We've
been there, several times.  It very quickly becomes quite
unmaintainable - you end up with hard to predict behaviour from
include files.

The only realistic solution is to use forward declarations.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
