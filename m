Return-Path: <linux-kernel-owner+w=401wt.eu-S932828AbXK2Q2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932828AbXK2Q2y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 11:28:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761079AbXK2Q2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 11:28:44 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:18823 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758562AbXK2Q2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 11:28:43 -0500
Date: Thu, 29 Nov 2007 17:28:33 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>, <linux-kernel@vger.kernel.org>,
       Kay Sievers <kay.sievers@vrfy.org>, Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [RFC] New kobject/kset/ktype documentation and example code
Message-ID: <20071129172833.0203a75b@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <Pine.LNX.4.44L0.0711291042240.4516-100000@iolanthe.rowland.org>
References: <20071129111251.35b3b17d@gondolin.boeblingen.de.ibm.com>
	<Pine.LNX.4.44L0.0711291042240.4516-100000@iolanthe.rowland.org>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2007 10:47:19 -0500 (EST),
Alan Stern <stern@rowland.harvard.edu> wrote:

> On Thu, 29 Nov 2007, Cornelia Huck wrote:
> 
> > > The only problem arises when a child's driver retains a reference to 
> > > the parent kobject.  If things are done properly, this reference should 
> > > involve incrementing the module count -- which would prevent the module 
> > > from being unloaded in the first place.
> > 
> > This still leaves the possibility that random code may grab a reference
> > once the kobject is present in the tree and lookupable. You gave up the
> > control of the number of references to your object once you made it
> > public.
> 
> I don't agree with this argument.  Code should never grab random
> references without insuring that the owner of the referenced object is
> pinned.  This rule applies to everything, not just kobjects.

Of course. You don't necessarily need prevent module unloading, but pin
the module in memory until the last reference is gone.

> Unfortunately kobjects don't have an owner field.  In practice this 
> means that it isn't possible to pin the owner of some random kobject -- 
> you have to know where the kobject came from or what it's embedded in.  
> All users of kobjects need to work this way.

Yeah, that is what the-patchset-I-have-to-dig-around-for does:
Introduce an owner field in the kobject for pinning the module. (IIRC,
you even did some of the patches?)
