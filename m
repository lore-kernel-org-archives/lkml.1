Return-Path: <linux-kernel-owner+w=401wt.eu-S966101AbXHaSgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966101AbXHaSgV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 14:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965734AbXHaSgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 14:36:08 -0400
Received: from empbedex1.empirix.com ([12.38.203.54]:13781 "EHLO
	empbedex1.empirix.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965619AbXHaSgG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 14:36:06 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: Follow up to: NFS/RPC Hangs after updating time...
Date: Fri, 31 Aug 2007 14:35:19 -0400
Message-ID: <BD261180E6D35F4D9D32F3E44FD3D901091DE759@EMPBEDEX.empirix.com>
In-Reply-To: <20070822202639.GL20946@fieldses.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Follow up to: NFS/RPC Hangs after updating time...
Thread-Index: Acfk+tMISbPbALZYTfi+nRzPwHiwEgHAjsNA
References: <BD261180E6D35F4D9D32F3E44FD3D90108F975FB@EMPBEDEX.empirix.com> <20070822202639.GL20946@fieldses.org>
From: "Morrison, Tom" <tmorrison@empirix.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: <nfs@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 31 Aug 2007 18:36:03.0540 (UTC) FILETIME=[C908D140:01C7EBFD]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a follow-up...

After a huge pain in the rear upgrading from a 
2.6.11++ to a 2.6.23-rc3 (I'll give the powerpc
folks a 'piece' of my mind on that front) - the 
NFS hang problem that I was experiencing on the 
older kernel is NOT occurring on this new version.

Now what do I do?

Is the net/sunrpc net/nfsx pieces isolated enough 
from the rest of the kernel that I could fork-lift 
it back to the 2.6.11 (or is that really a lost cause).

Thanks for any/all feedback on this front!


-----Original Message-----
From: J. Bruce Fields [mailto:bfields@fieldses.org] 
Sent: Wednesday, August 22, 2007 4:27 PM
To: Morrison, Tom
Cc: nfs@lists.sourceforge.net; linux-kernel@vger.kernel.org; Rushton,
Matt
Subject: Re: NFS/RPC Hangs after updating time...

On Wed, Aug 22, 2007 at 02:37:22PM -0400, Morrison, Tom wrote:
> I am working with a 2.6.11++ kernel on an embedded 
> server platform that is NFS serving Linux rootfs 
> for other embedded NFS Client boards.
> 
> Everything works fine when the system time on the 
> server board is relatively synchronized with the real-time. 
> 
> It hangs after attempting to update the time from a 
> nonsensical time (e.g.: 2 months ago) - the most significant
> part of it is that it only hangs IFF it has started 
> serving its NFS client boards before I attempt to 
> update the time.
> 
> 
> The most significant output (when turning on 
> RPC debugging) is from:
> 
>   linux/net/sunrpc/cache.c (cache_check) - line 90:
> 
>          >> Want update, refage=1800, age=4288285
> 
> It continually loops through this method - and the cache
> never gets updated...even thought with some additional
> sleuthing (aka: additional debug printks - it thinks 
> that there is an cache update pending).

Can you reproduce the problem with the current kernel? (Say 2.6.22 or
later?)

--b.
