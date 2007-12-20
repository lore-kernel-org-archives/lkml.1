Return-Path: <linux-kernel-owner+w=401wt.eu-S932311AbXLTNth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932311AbXLTNth (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 08:49:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758323AbXLTNt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 08:49:28 -0500
Received: from fwstl1-1.wul.qc.ec.gc.ca ([205.211.132.24]:10671 "EHLO
	ecqcmtlbh.quebec.int.ec.gc.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758317AbXLTNt1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 08:49:27 -0500
Subject: Re: 2.6.22.14 oops msg with commvault galaxy ?
From: Vincent Fortier <vincent.fortier1@ec.gc.ca>
Reply-To: vincent.fortier1@ec.gc.ca
To: Greg KH <gregkh@suse.de>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>, maneesh@in.ibm.com
In-Reply-To: <20071214172814.GA14597@suse.de>
References: <1197554397.19869.3.camel@lov.site>
	 <1197558120.4936.34.camel@kayak.wul.qc.ec.gc.ca>
	 <1197562981.19869.5.camel@lov.site> <20071213165059.GC4865@elte.hu>
	 <1197565842.19869.11.camel@lov.site> <20071213202125.GA25130@elte.hu>
	 <20071214162642.GA13898@suse.de> <20071214170739.GA2576@linux.vnet.ibm.com>
	 <20071214172814.GA14597@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Organization: Environnement Canada
Date: Thu, 20 Dec 2007 13:49:04 +0000
Message-Id: <1198158544.7462.3.camel@kayak.wul.qc.ec.gc.ca>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
X-OriginalArrivalTime: 20 Dec 2007 13:49:04.0973 (UTC) FILETIME=[15D23FD0:01C8430F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 14 décembre 2007 à 09:28 -0800, Greg KH a écrit :
> On Fri, Dec 14, 2007 at 10:37:39PM +0530, Dhaval Giani wrote:
> > On Fri, Dec 14, 2007 at 08:26:42AM -0800, Greg KH wrote:
> > > On Thu, Dec 13, 2007 at 09:21:26PM +0100, Ingo Molnar wrote:
> > > > 
> > > > * Kay Sievers <kay.sievers@vrfy.org> wrote:
> > > > 
> > > > > > > > This one also fails to apply properly at the exact same place 
> > > > > > > > has Ingo's previously posted patch.  Would need to backport his 
> > > > > > > > one.
> > > > > > > 
> > > > > > > It depends on a completely reworked sysfs logic, I don't think it 
> > > > > > > makes any sense to backport that.
> > > > > > 
> > > > > > well, if it fixes a live bug in a still supported stable kernel 
> > > > > > release...
> > > > > > 
> > > > > > Vincent, could you try to just get rid of all actual uses of 
> > > > > > se->attr.owner, within fs/sysfs/*.c? Something like the patch below. 
> > > > > > (totally untested - might be fatally broken as well)
> > > > > 
> > > > > How can you think that this is not needed? You can not remove it with 
> > > > > sysfs you are patching. Hope this explains it: 
> > > > > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=0ab66088c855eca68513bdd7442a426c4b374ced
> > > > 
> > > > yeah - as i said it might be fatally broken (in fact it is). Do we 
> > > > understand why Vincent got the crashes with vanilla 2.6.22.14 ?
> > > 
> > > No, and I can't seem to duplicate them here at all.
> > > 
> > > Does anyone have a test case for this that I can work on trying to
> > > duplicate?
> > > 
> > 
> > If you apply CFS without my fix, and try to constantly check cpu_shares
> > for a user who is logging and logging out, you should hit it. (That's
> > what I was doing).
> 
> Hm, how about a "vanilla 2.6.22.14 kernel _without_ any patches".
> That's what I am most worried about :)

Since I was getting the problem with both vanilla & CFS patched kernels
and that, sadly, I don't have the time to do git bisect at the moment I
decided to go ahead and prepare a full migration to 2.6.23 (I was hoping
to skip directly to 2.6.24 but...).

I can confirm at the moment that 2.6.23 works properly with Galaxy (just
has 2.6.20 & 2.6.21 used to...).

Thnx very much everyone for the help but sadly this bug will have to
remain unresolved.

> thanks,

- vin
