Return-Path: <linux-kernel-owner+w=401wt.eu-S1752011AbZH0LzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011AbZH0LzS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 07:55:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751818AbZH0LzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 07:55:18 -0400
Received: from verein.lst.de ([213.95.11.210]:49602 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751791AbZH0LzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 07:55:17 -0400
Date: Thu, 27 Aug 2009 13:54:12 +0200
From: Christoph Hellwig <hch@lst.de>
To: Fernando Luis V?zquez Cao <fernando@oss.ntt.co.jp>
Cc: Christoph Hellwig <hch@lst.de>, t-sato@yk.jp.nec.com,
       m-hamaguchi@ys.jp.nec.com, Al Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Sandeen <sandeen@redhat.com>
Subject: Re: [RFC, PATCH] filesystem freeze: fix sys_umount induced perpetual freeze
Message-ID: <20090827115412.GA8326@lst.de>
References: <4A94C151.8020900@oss.ntt.co.jp> <20090826173839.GA20175@lst.de> <4A965BD1.205@oss.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A965BD1.205@oss.ntt.co.jp>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 27, 2009 at 07:11:29PM +0900, Fernando Luis V?zquez Cao wrote:
> Thank you for the pointers. I gave those patches a spin, but it seems
> the umount case is not being tackled. I suggest rejecting the umount
> for frozen filesystems. What do you think?
> 
> I will be replying to this email with a forward port of your patches
> along with my own patches that fix the locking for umount and add a
> new ioctl to check the freeze state of the filesystem (this is helpful
> to create clean resource agents for HA solutions).

I think we should just reject the umount for a forzen filesystem with
-EBUSY like I do for remount in those patches.  I somehow thought I did
this but didn't.  Is that good for your use case?

