Return-Path: <linux-kernel-owner+w=401wt.eu-S1753803AbYAUUDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803AbYAUUDT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 15:03:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752132AbYAUUDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 15:03:07 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:39273 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbYAUUDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 15:03:06 -0500
Date: Mon, 21 Jan 2008 12:09:23 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: [PATCH] x86_32: trim memory by updating e820 v2
In-reply-to: <alpine.DEB.0.999999.0801211413350.10066@p34.internal.lan>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Jesse Barnes <jesse.barnes@intel.com>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Message-id: <200801211209.23901.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200801192045.17291.yinghai.lu@sun.com>
 <200801210830.22322.jesse.barnes@intel.com>
 <alpine.DEB.0.999999.0801211413350.10066@p34.internal.lan>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 January 2008 11:14:02 am Justin Piszcz wrote:
> 
> On Mon, 21 Jan 2008, Jesse Barnes wrote:
> 
> > On Sunday, January 20, 2008 10:56 pm Yinghai Lu wrote:
> >> [PATCH] x86_32: trim memory by updating e820 v2
> >>
> >> when mtrr is not covering all e820 table, need to trim the ram, need to
> >> update e820
> >>
> >> reuse some code for x86_64
> >>
> >> here need to add early_identify_cpu for x86_32, and move mtrr_bp_init early
> >>
> >> compiled test only, need someone test it
> >
> > I like this approach too.  So as long as the E820 modification method works
> > (i.e. we have some testers, maybe Justin can give it a try), you can add
> >
> > Signed-off-by:  Jesse Barnes <jesse.barnes@intel.com>
> >
> > or
> >
> > Acked-by:  Jesse Barnes <jesse.barnes@intel.com>
> >
> > as appropriate too.
> >
> > Thanks,
> > Jesse
> >
> 
> Subject: Re: [PATCH] x86_32: trim memory by updating e820 v2
>                           ^^
> 
> I run x86_64 btw-- if there is a kernel.patch for x86_64 please let me 
> know and I can test, thanks.

please get x86.git

  git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
  cd linux-2.6
  #--------------{ x86.git instructions }---------->
  # Add Linus's tree as a remote
  git remote add linus git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git

  # Add Ingo's tree as a remote
  git remote add x86 git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git

  # With that setup, just run the following to get any changes you
  # don't have.  It will also notice any new branches Ingo/Linus
  # add to their repo.  Look in .git/config afterwards, the format
  # to add new remotes is easy to figure out.
  git remote update
  #-------------------------
  git merge x86/master
  git merge x86/mm

and apply

[PATCH] x86_64: check if Tom2 is enabled
http://lkml.org/lkml/2008/1/21/20
[PATCH] x86_64: update e820 instead of updating end_pfn v3
http://lkml.org/lkml/2008/1/21/19
[PATCH] x86_32: trim memory by updating e820 v2
http://lkml.org/lkml/2008/1/21/18

YH
