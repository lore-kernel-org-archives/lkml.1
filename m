Return-Path: <linux-kernel-owner+w=401wt.eu-S1754063AbZHPKSL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063AbZHPKSL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 06:18:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752448AbZHPKSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 06:18:11 -0400
Received: from mail-fx0-f215.google.com ([209.85.220.215]:57064 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbZHPKSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 06:18:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=QzvXtJIzDOExq7bbu4vwGcSzOlst+PryJXT1UWMJCk1itb6S4YbehhYZq8AccPKRQX
         y+d2kgoKKjK9s8hORlsC6yDLgD6wUpZD/NLAANT2SehHK1LyAQjDnjL/p/0iGJRAqGfg
         vZQypq8B8/IxU5ZdGS49LKq/LA8COEdGaB7wA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: mm/ipw2200 regression (was: Re: linux-next: Tree for August 6)
Date: Sun, 16 Aug 2009 12:17:12 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc1; KDE/4.2.4; i686; ; )
Cc: linux-mm@kvack.org, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
References: <20090806192209.513abec7.sfr@canb.auug.org.au> <200908151856.48596.bzolnier@gmail.com> <20090816173101.6e47b702.sfr@canb.auug.org.au>
In-Reply-To: <20090816173101.6e47b702.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200908161217.12963.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Sunday 16 August 2009 09:31:01 Stephen Rothwell wrote:
> Hi Bart,
> 
> On Sat, 15 Aug 2009 18:56:48 +0200 Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> >
> > The bug managed to slip into Linus' tree..
> > 
> > ipw2200: Firmware error detected.  Restarting.
> > ipw2200/0: page allocation failure. order:6, mode:0x8020
> > Pid: 945, comm: ipw2200/0 Not tainted 2.6.31-rc6-dirty #69
>                                                    ^^^^^
> So, this is rc6 plus what?  (just in case it is relevant).

In this case plus upcoming staging/rt{286,287,307}0 patches (irrelevant,
they are not used on this machine and the problem happened many times
with vanilla -next kernels in the past)..

After going through mm commits in Linus' tree I think that the bug came
the other way around, from akpm's tree to Linus' tree and then to -next
(page allocator changes seem to match "the suspect's profile")..
