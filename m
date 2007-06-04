Return-Path: <linux-kernel-owner+w=401wt.eu-S1756028AbXFDOj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028AbXFDOj3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 10:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754619AbXFDOjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 10:39:22 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:16998 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486AbXFDOjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 10:39:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cI1JKtOUFR0kXJCCtjmcK+n9QS+Xz6PIQm1Bq0uIdV6mQntOEu4xDQjjp1WlZA3Qw0/ELpaCyocPQN/bsmj7CpTQkipN1rZmgXAy58pTPD0tjcSwVatfPRMFtIuoyED21wJjk/O0bnWZLoEMgfSB3AibrPimJob7NiR+SFTypyk=
Message-ID: <e7ca40f70706040739n72ba34e5v61555bd2cb8eddd1@mail.gmail.com>
Date: Mon, 4 Jun 2007 10:39:20 -0400
From: "Aaron Wiebe" <epiphani@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: slow open() calls and o_nonblock
In-Reply-To: <e7ca40f70706031152q4e9630aq3c29623bd56fe0e5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e7ca40f70706031152q4e9630aq3c29623bd56fe0e5@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the unthreaded responses, I wasn't cc'd here, so I'm
replying to these based on mailing list archives....

Al Viro wrote:

> BTW, why close these suckers all the time? It's not that kernel would
> be unable to hold thousands of open descriptors for your process...
> Hash descriptors by pathname and be done with that; don't bother with
> close unless you decide that you've got too many of them (e.g. when you
> get a hash conflict).

A valid point - I currently keep a pool of 4000 descriptors open and
cycle them out based on inactivity.  I hadn't seriously considered
just keeping them all open, because I simply wasn't sure how well
things would go with 100,000 files open.  Would my backend storage
keep up... would the kernel mind maintaining 100,000 files open over
NFS?

The majority of the files would simply be idle - I would be keeping
file handles open for no reason.  Pooling allows me to substantially
drop the number of opens I require, but I am hesitant to blow the pool
size to substantially higher numbers.  Can anyone shed light on any
issues that may come up with a massive pool size, such as 128k?

-Aaron
