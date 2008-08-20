Return-Path: <linux-kernel-owner+w=401wt.eu-S1754912AbYHTOpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912AbYHTOpk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 10:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751772AbYHTOpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 10:45:31 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58377 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764AbYHTOpb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 10:45:31 -0400
Subject: Re: distributed shared memory / mmap
From: Steven Whitehouse <swhiteho@redhat.com>
To: Martin Uecker <muecker@gwdg.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1219238336.8097.29.camel@localhost>
References: <1219238336.8097.29.camel@localhost>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Wed, 20 Aug 2008 15:43:24 +0100
Message-Id: <1219243404.20622.156.camel@quoit>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 2008-08-20 at 15:18 +0200, Martin Uecker wrote:
> 
> Hi!
> 
> Is there any easy way to get shared memory between to
> processes on different machines? It seems possible using mmap
> on a file system like GFS on top of a distributed block device.
> 
> 
> Sincerly,
> Martin Uecker
> 
Yes, you can do it using GFS/GFS2 and it should work. On the other hand,
don't do it. Its probably not what you want and unlikely to give you
good performance since the locking is "per inode" and thus you'll
generate a lot of cache flushing if there is any appreciable amount of
writing to the shared region. If you have a read mostly (or only)
workload, then it will work much better.

There are often better solutions though, depending on the application in
question,

Steve.



