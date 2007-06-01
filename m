Return-Path: <linux-kernel-owner+w=401wt.eu-S1762903AbXFATuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762903AbXFATuh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 15:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763631AbXFATuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 15:50:24 -0400
Received: from winds.org ([68.75.195.9]:47546 "EHLO winds.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762410AbXFATuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 15:50:23 -0400
X-Greylist: delayed 1998 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Jun 2007 15:50:22 EDT
Date: Fri, 1 Jun 2007 15:17:03 -0400 (EDT)
From: Byron Stanoszek <bstanoszek@comtime.com>
X-X-Sender: gandalf@winds.org
To: Kyle McMartin <kyle@parisc-linux.org>
cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Ulrich Drepper <drepper@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, torvalds@linux-foundation.org,
       Chris Zankel <chris@zankel.net>, parisc-linux@lists.parisc-linux.org
Subject: Re: [PATCH] Introduce O_CLOEXEC (take >2)
In-Reply-To: <20070601030754.GB14217@fattire.cabal.ca>
Message-ID: <Pine.LNX.4.64.0706011510220.26938@winds.org>
References: <200705311809.l4VI9F9X009556@devserv.devel.redhat.com>
 <20070531162021.4cd4e91a.akpm@linux-foundation.org>
 <20070601113840.813463db.sfr@canb.auug.org.au> <20070601030754.GB14217@fattire.cabal.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 May 2007, Kyle McMartin wrote:

> On Fri, Jun 01, 2007 at 11:38:40AM +1000, Stephen Rothwell wrote:
>> This also breaks Alpha (which uses 02000000 for O_DIRECT) and parisc
>> (which uses 02000000 for O_RSYNC).  So you ether need to choose a
>> different value or define O_CLOEXEC for those two architectures.
>>
>
> That's easy enough to fix...
>
> Signed-off-by: Kyle McMartin <kyle@parisc-linux.org>
>
> diff --git a/include/asm-parisc/fcntl.h b/include/asm-parisc/fcntl.h
> index 317851f..4ca0fb0 100644
> --- a/include/asm-parisc/fcntl.h
> +++ b/include/asm-parisc/fcntl.h
> @@ -14,6 +14,7 @@
> #define O_DSYNC		01000000 /* HPUX only */
> #define O_RSYNC		02000000 /* HPUX only */
> #define O_NOATIME	04000000
> +#define O_CLOEXEC	08000000 /* set close_on_exec */
>
> #define O_DIRECTORY	00010000 /* must be a directory */
> #define O_NOFOLLOW	00000200 /* don't follow links */

These are octal values, so you really want to use 010000000 instead of
08000000. :-)

While looking at that file further, I noticed these two flags share the same
value. I don't know DMAPI/XDSM, but could they potentially conflict?

#define O_NOATIME       04000000
#define O_INVISIBLE     04000000 /* invisible I/O, for DMAPI/XDSM */

Regards,
  -Byron

--
Byron Stanoszek                         Ph: (330) 644-3059
Systems Programmer                      Fax: (330) 644-8110
Commercial Timesharing Inc.             Email: byron@comtime.com
