Return-Path: <linux-kernel-owner+w=401wt.eu-S932546AbZDBSPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932546AbZDBSPB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 14:15:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752533AbZDBSOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 14:14:51 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:26926 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759494AbZDBSOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 14:14:50 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Dvb4jdJkxpbaIVwIOFF4Np2cjhvWdd3voLG0sNSbNtj9joLxaRIrsBFNIxt4HZ2QoLk1v3/om6kgaY9M+fYG9A3gXWHTLKw6yzNowYOytS0dLkCE3POpmSVef6Qzj7dxv+EzsNGCbWAjb8MGlYF8LmVbsZw4KjADv6cx4TW1RXc=  ;
X-YMail-OSG: GzestpUVM1nWY4kSBhqtDwgm2SIjRzio2z9OAiZi.1TsrJf3MB.L9b0ZHGWYHYNjJzLlLg3ILo.bbgP8u_KbRrOMj2GepDzWNgag11e46xM5hY_UcwdU6BA0J3Z23_.xkn86zzSa_k3iK1sDuyKxUddad73KUoVRAut7.TC6jf1d_YX6.X0rRgXDq4wgMBCIU8WY6aQW2OxAlTDuChGgaNOTUt.qweTj7SROzGLF7sJFFxF911Qls752AnFhDFgo3yYFBBYODUBKSWk0gQ.N31YFwsQvOAtqL8uLhucmLwyXNfhPW96srkei8MlJYkKJTnKd1Wc0OYrRAPglxdR3c9uVbw--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 06/43] FS-Cache: Recruit a couple of page flags for cache management [ver #46]
Date: Fri, 3 Apr 2009 05:14:42 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: viro@zeniv.linux.org.uk, nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
References: <200904030431.04079.nickpiggin@yahoo.com.au> <7249.1238692155@redhat.com> <7516.1238694057@redhat.com>
In-Reply-To: <7516.1238694057@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904030514.42687.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 April 2009 04:40:57 David Howells wrote:
> Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> 
> > Well in theory I still think it would be cleanest to modify buffer to
> > play more nicely with it. But maybe that ends up being harder to
> > distinguish the 3 cases of attached metadata on the page. I don't know,
> > you haven't posted any isofs code so either way it is inappropriate to
> > use up this extra page flag here.
> > 
> > Is isofs cache worth a page flag?
> 
> Well, isofs was something I wanted at the time.

It can't be done with FUSE?


> Besides, as I said NFS uses PG_private for its own purposes, and entangling
> the two wasn't the most fun I've had.  Trond didn't like it either.

IMO that is quite OK to make them go through the pain of that if it
avoids resulting in a new page flag that is probably unusable to most
other filesystems.

But... I guess I won't get hung up on it. If you avoid at least one of
these flags it would be a good start.
