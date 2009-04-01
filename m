Return-Path: <linux-kernel-owner+w=401wt.eu-S1755449AbZDADVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449AbZDADVm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 23:21:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754782AbZDADVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 23:21:30 -0400
Received: from n10.bullet.mail.mud.yahoo.com ([209.191.125.208]:42286 "HELO
	n10.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754651AbZDADV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 23:21:29 -0400
X-Yahoo-Newman-Id: 154603.34562.bm@omp416.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=jdG8SaaneAVjUy9igiXw3rDiwgR8kiv/b4UujcjfdgQyAVZNBgAQIEIUIfHMPzxHYUlBgZc+o1M/ZBvZQFToKosSRt/qMqqq4gKhig5s/Zn7aOkjJI+Mm1ZvpPvvMFayrtBPoRk1kMDNEii6ulrxS3dNAtR+XzMH2lisbMW/3h8=  ;
X-YMail-OSG: Q30URqcVM1l5DJ.78XU3WSus_HjlHxCuDGIcSvYhokiA427MMj9AHlFBEDgSu2MFSD41tONPLrGIN8Tpr52yrjUSQ8OVX0i7.CPrY.5P4F_A43UfwSZZP0twU6c.IIPS5warPABA0BdIyMz50Eb8maSpamGjICmdfLboztkPyC9nlacxli6nuYTBDT3PZoznamc4g.NUFfkFF_e5d4.Xg.0UMKdaDiuSAaJW645gzECVGU82ZtfvsxpZjHq39xyMT2EDGtU6.Tv_VrCyjutoelT_8tJjqn7Fel7S6_nI8AWFj4Dhh4hrGQMP2qFappLA5Lw_KRGRWBmUi9GL.2J_M57bb4Q-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Kevin Cernekee <kpc.mtd@gmail.com>
Subject: Re: [patch/rfc 2.6.29 1/2] MTD: driver model updates
Date: Tue, 31 Mar 2009 20:21:25 -0700
User-Agent: KMail/1.9.10
Cc: Linux MTD <linux-mtd@lists.infradead.org>,
       Kay Sievers <kay.sievers@vrfy.org>, LKML <linux-kernel@vger.kernel.org>
References: <200903260042.42091.david-b@pacbell.net> <200903311418.53772.david-b@pacbell.net> <a95a62fe0903311817i76f9f6d8qf7470fd14a62b912@mail.gmail.com>
In-Reply-To: <a95a62fe0903311817i76f9f6d8qf7470fd14a62b912@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903312021.25165.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 31 March 2009, Kevin Cernekee wrote:
> On Tue, Mar 31, 2009 at 2:18 PM, David Brownell <david-b@pacbell.net> wrote:
> > Hmm, no comments?  I had understood there was interest over on
> > the MTD side of things in exposing more information through
> > sysfs, to help avoid the need to add Even More Ioctls as part
> > of support for things like NAND chips with 4KB pages, or which
> > handle more than 4GBytes ...
> 
> Based on this post:
> http://lists.infradead.org/pipermail/linux-mtd/2009-March/025060.html
> 
> I am inferring that the following attributes are wanted in the MTD
> sysfs interface:
> 
> 1) mtd_info_user fields - type, flags, size, erasesize, writesize,
> oobsize.  So far we have "type," but it should be easy to add the
> rest.

Yes, easy to add those.  As noted in the $SUBJECT patch, the set
consisting of just "type" is a "starter set".  :)

For procfs elimination, a name/label would be needed too; that can
be an input to, or output from, cmdlinepart.

My question about the $SUBJECT patch is whether there's any reason
not to use that as the start of such driver model enhancements.
I'm thinking the answer to that seems to be "no", and that someone
more involved in *using* those sysfs attributes would be a better
choice for growing that set of attributes.


> 2) region_info_user fields?  Not really sure how this would work.
> Maybe a separate subdirectory for each region?

I'm not sure I've ever had reason to care about a "region" (whatever
that is!) with MTD hardware.

I suspect that a lot of interesting questions could come up in
the context of enhancing mtd-utils to work with sysfs and bigger
NAND chips.  Some might relate to "regions".

- Dave

