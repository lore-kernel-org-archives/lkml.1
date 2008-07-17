Return-Path: <linux-kernel-owner+w=401wt.eu-S1759530AbYGQQxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759530AbYGQQxY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 12:53:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756825AbYGQQxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 12:53:15 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:59792 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756789AbYGQQxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 12:53:14 -0400
Subject: Re: [PATCH] systemtap: fix up on_each_cpu() for kernels 2.6.26+
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: systemtap@sourceware.org
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1216313476.5515.16.camel@localhost.localdomain>
References: <1216313476.5515.16.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 17 Jul 2008 11:53:11 -0500
Message-Id: <1216313591.5515.19.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-17 at 11:51 -0500, James Bottomley wrote:
> In kernel 2.6.26, this patch
> 
> commit 15c8b6c1aaaf1c4edd67e2f02e4d8e1bd1a51c0d
> Author: Jens Axboe <jens.axboe@oracle.com>
> Date:   Fri May 9 09:39:44 2008 +0200
> 
>     on_each_cpu(): kill unused 'retry' parameter
> 
> means that runtime/time.c is now using the wrong calling conventions.
> Fix this up and surround it by kernel versioning #ifdefs.

By the way, this is a classic illustration of the fragility problem in
holding the systemtap runtime outside of the kernel.  If it had been
in-kernel, all this would be fixed up and running and no-one would even
have noticed.

At least with changes in argument numbers, the compile breaks ... it
would have been a lot nastier if one of the variables simply changed
meaning ...

James


