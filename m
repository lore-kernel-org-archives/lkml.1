Return-Path: <linux-kernel-owner+w=401wt.eu-S1761232AbXK2Pr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761232AbXK2Pr2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 10:47:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756598AbXK2PrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 10:47:20 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:50909 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755115AbXK2PrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 10:47:20 -0500
Date: Thu, 29 Nov 2007 10:47:19 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Cornelia Huck <cornelia.huck@de.ibm.com>
cc: Greg KH <greg@kroah.com>, <linux-kernel@vger.kernel.org>,
       Kay Sievers <kay.sievers@vrfy.org>, Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [RFC] New kobject/kset/ktype documentation and example code
In-Reply-To: <20071129111251.35b3b17d@gondolin.boeblingen.de.ibm.com>
Message-ID: <Pine.LNX.4.44L0.0711291042240.4516-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2007, Cornelia Huck wrote:

> > The only problem arises when a child's driver retains a reference to 
> > the parent kobject.  If things are done properly, this reference should 
> > involve incrementing the module count -- which would prevent the module 
> > from being unloaded in the first place.
> 
> This still leaves the possibility that random code may grab a reference
> once the kobject is present in the tree and lookupable. You gave up the
> control of the number of references to your object once you made it
> public.

I don't agree with this argument.  Code should never grab random
references without insuring that the owner of the referenced object is
pinned.  This rule applies to everything, not just kobjects.

Unfortunately kobjects don't have an owner field.  In practice this 
means that it isn't possible to pin the owner of some random kobject -- 
you have to know where the kobject came from or what it's embedded in.  
All users of kobjects need to work this way.

Alan Stern

