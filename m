Return-Path: <linux-kernel-owner+w=401wt.eu-S1764227AbXIMGHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764227AbXIMGHh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 02:07:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752019AbXIMGHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 02:07:30 -0400
Received: from sacred.ru ([62.205.161.221]:53093 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048AbXIMGH3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 02:07:29 -0400
Message-ID: <46E8D2E0.7040507@openvz.org>
Date: Thu, 13 Sep 2007 10:04:16 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: "J. Bruce Fields" <bfields@fieldses.org>
CC: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: Re: [PATCH] Memory shortage can result in inconsistent flocks state
References: <46E68C35.7040001@openvz.org> <20070912190653.GA13792@fieldses.org>
In-Reply-To: <20070912190653.GA13792@fieldses.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Thu, 13 Sep 2007 10:06:45 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

J. Bruce Fields wrote:
> On Tue, Sep 11, 2007 at 04:38:13PM +0400, Pavel Emelyanov wrote:
>> This is a known feature that such "re-locking" is not atomic,
>> but in the racy case the file should stay locked (although by
>> some other process), but in this case the file will be unlocked.
> 
> That's a little subtle (I assume you've never seen this actually
> happen?), but it makes sense to me.

Well, this situation is hard to notice since usually programs
try to finish up when some error is returned from the kernel,
but I do believe that this could happen in one of the openvz
kernels since we limit the kernel memory usage for "containers"
and thus -ENOMEM is a common error.

>> The proposal is to prepare the lock in advance keeping no chance
>> to fail in the future code.
> 
> And the patch certainly looks correct.
> 
> I can add it to my (trivial) lock patches, if that's helpful--it'll
> get folded into the branch -mm pulls from and I can pass it along to
> Linus for 2.6.24.

Thanks.

> What I don't have that I wish I did is good regression tests for the
> flock or lease code (for posix locks I've been using connectathon,
> though that misses some important things too).
> 
> --b.
> 

