Return-Path: <linux-kernel-owner+w=401wt.eu-S1759248AbZFQSvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759248AbZFQSvs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 14:51:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756371AbZFQSvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 14:51:40 -0400
Received: from mail.fieldses.org ([141.211.133.115]:41608 "EHLO
	pickle.fieldses.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756295AbZFQSvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 14:51:39 -0400
Date: Wed, 17 Jun 2009 14:51:39 -0400
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.29.1: nfsd: page allocation failure - nfsd or kernel
	problem?
Message-ID: <20090617185139.GF24040@fieldses.org>
References: <alpine.DEB.2.00.0906161203160.27742@p34.internal.lan> <alpine.DEB.2.00.0906161205260.27742@p34.internal.lan> <4A37FE48.6070306@msgid.tls.msk.ru> <4A38ACC0.3060501@msgid.tls.msk.ru> <alpine.DEB.2.00.0906170542170.3600@p34.internal.lan> <4A38C7CA.7040005@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A38C7CA.7040005@msgid.tls.msk.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 17, 2009 at 02:39:06PM +0400, Michael Tokarev wrote:
> Justin Piszcz wrote:
>>
>>
>> On Wed, 17 Jun 2009, Michael Tokarev wrote:
>>
>>> Michael Tokarev wrote:
>>>> Justin Piszcz wrote:
>>> ...
>>>
>>> Justin, by the way, what's the underlying filesystem on the server?
>>>
>>> I've seen this error on 2 machines already (both running 2.6.29.x  
>>> x86-64),
>>> and in both cases the filesystem on the server was xfs.  May this be
>>> related somehow to http://bugzilla.kernel.org/show_bug.cgi?id=13375 ?
>>> That one is different, but also about xfs and nfs.  I'm trying to
>>> reproduce the problem on different filesystem...
>>
>> Hello, I am also running XFS on 2.6.29.x x86-64.
>>
>> For me, the error happened when I was running an XFSDUMP from a client  
>> (and dumping) the stream over NFS to the XFS server/filesystem.  This 
>> is typically when the error occurs or during heavy I/O.
>
> Very similar load was here -- not xfsdump but tar and dump of an ext3
> filesystems.
>
> And no, it's NOT xfs-related: I can trigger the same issue easily on
> ext4 as well.  About 20 minutes of running 'dump' of another fs
> to the nfs mount and voila, nfs server reports the same page allocation
> failure.  Note that all file operations are still working, i.e. it
> produces good (not corrupted) files on the server.

There's a possibly related report for 2.6.30 here:

	http://bugzilla.kernel.org/show_bug.cgi?id=13518

--b.
