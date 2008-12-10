Return-Path: <linux-kernel-owner+w=401wt.eu-S1755221AbYLJNI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221AbYLJNI4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 08:08:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753232AbYLJNIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 08:08:38 -0500
Received: from mga03.intel.com ([143.182.124.21]:41611 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752879AbYLJNIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 08:08:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,747,1220252400"; 
   d="scan'208";a="88594438"
Date: Wed, 10 Dec 2008 20:58:46 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Laurent Pinchart <laurent.pinchart@skynet.be>
Cc: Oliver Neukum <oliver@neukum.org>, LKML <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] usb: make printk messges more searchable
Message-ID: <20081210125846.GC6772@localhost>
References: <20081210072921.GA18142@localhost> <200812101042.17530.laurent.pinchart@skynet.be> <200812101056.15457.oliver@neukum.org> <200812101059.01068.laurent.pinchart@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812101059.01068.laurent.pinchart@skynet.be>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2008 at 11:59:00AM +0200, Laurent Pinchart wrote:
> On Wednesday 10 December 2008, Oliver Neukum wrote:
> > Am Mittwoch, 10. Dezember 2008 10:42:17 schrieb Laurent Pinchart:
> > > Hi Wu,
> > >
> > > On Wednesday 10 December 2008, Wu Fengguang wrote:
> > > > Make USB printk messages long and straightforward.  One of these
> > > > decorated USB error messages cost me some smart efforts to locate.
> > >
> > > That would make the code break the 80 columns limit.
> > >
> > > From "Documentation/CodingStyle":
> > >
> > > "The limit on the length of lines is 80 columns and this is a strongly
> > > preferred limit."
> >
> > Too rigid an application is bad. The kernel must be greppable.
> 
> I've also been bitten by split strings when grepping kernel source code. A 
> cgrep that would unsplit strings before searching them would be nice :-)

Such printk will sure bite more people.  And it's amazing that the CodingStyle
document uses printk as an 80-column example:

 80 The limit on the length of lines is 80 columns and this is a strongly
 81 preferred limit.
 82 
 83 Statements longer than 80 columns will be broken into sensible chunks.
 84 Descendants are always substantially shorter than the parent and are placed
 85 substantially to the right. The same applies to function headers with a long
 86 argument list. Long strings are as well broken into shorter strings. The
 87 only exception to this is where exceeding 80 columns significantly increases
 88 readability and does not hide information.
 89 
 90 void fun(int a, int b, int c)
 91 {
 92         if (condition)
 93                 printk(KERN_WARNING "Warning this is a long printk with "
 94                                                 "3 parameters a: %u b: %u "
 95                                                 "c: %u \n", a, b, c);
 96         else
 97                 next_statement;
 98 }

