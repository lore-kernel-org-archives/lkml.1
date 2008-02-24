Return-Path: <linux-kernel-owner+w=401wt.eu-S1757927AbYBXS3D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757927AbYBXS3D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 13:29:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753115AbYBXS2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 13:28:51 -0500
Received: from 1wt.eu ([62.212.114.60]:2110 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752912AbYBXS2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 13:28:50 -0500
Date: Sun, 24 Feb 2008 19:28:39 +0100
From: Willy Tarreau <w@1wt.eu>
To: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Cc: Unknown <borg@uu3.net>, linux-kernel@vger.kernel.org,
       dann frazier <dannf@debian.org>
Subject: Re: PROBLEM: 2.4.36.1 hangs.
Message-ID: <20080224182839.GA31199@1wt.eu>
References: <Pine.LNX.4.64.0802221452350.5082@cube> <20080223083044.GA24136@1wt.eu> <47C1B374.6030502@plouf.fr.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47C1B374.6030502@plouf.fr.eu.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 24, 2008 at 07:12:04PM +0100, Pascal Hambourg wrote:
> Hello,
> 
> Willy Tarreau wrote :
> >
> >On Fri, Feb 22, 2008 at 03:08:30PM +0100, Unknown wrote:
> >
> >>2) 2.4.36.1 hangs during compilation of lighttpd-1.4.18.
> >>  It is probably during ext2_readdir() but I cannot confirm that..
> >>  Currently it only happens during compilation of lighttpd-1.4.18, always
> >>  in the same place. [...]
> 
> I experience the same problem when executing "ls /etc".
> 
> >OK, could you please try to revert the attached patch (patch -Rp1) to see 
> >if
> >this fixes the problem for you ? Please keep Dann and me in CC as it's not
> >easy to spot 2.4-related threads on LKML these days!
> >
> >----
> >
> >commit c30306fb287323591c854a0982d9fa5351859b45
> >Author: dann frazier <dannf@debian.org>
> >Date:   Mon Jan 21 17:13:06 2008 -0700
> >
> >    ext2_readdir() filp->f_pos fix
> 
> The patch didn't revert cleanly because of the two subsequent 
> ext2-related patches, so I had to revert the three of them. It fixed the 
> problem. Then I applied only the "ext2_readdir() filp->f_pos fix" patch 
> again and the problem came back. HTH.

OK thanks very much Pascal.

I'm reverting the patch for the moment and will release 2.4.36.2 without
it.

Dann, it looks like the backport of the fix causes more trouble than it
attempts to fix :-/

(Un)fortunately I had no problem here, so I think it's not that easy to
reproduce the issue. If the fix is too hard to get right and the risk
of vulnerability very low, don't you think we should simply leave it
unfixed, at least until we really understand the nature of the problem ?

Thanks,
Willy

