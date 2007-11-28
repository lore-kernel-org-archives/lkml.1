Return-Path: <linux-kernel-owner+w=401wt.eu-S1761483AbXK1PwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761483AbXK1PwV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 10:52:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757121AbXK1PwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 10:52:09 -0500
Received: from mtagate3.de.ibm.com ([195.212.29.152]:2782 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761175AbXK1PwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 10:52:08 -0500
Date: Wed, 28 Nov 2007 16:52:05 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [RFC] New kobject/kset/ktype documentation and example code
Message-ID: <20071128165205.30ef426f@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <1196253354.3242.40.camel@lov.site>
References: <20071127230252.GB10038@kroah.com>
	<20071128100108.45fcbf15@gondolin.boeblingen.de.ibm.com>
	<1196253354.3242.40.camel@lov.site>
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

On Wed, 28 Nov 2007 13:35:54 +0100,
Kay Sievers <kay.sievers@vrfy.org> wrote:

> On Wed, 2007-11-28 at 10:01 +0100, Cornelia Huck wrote:
> > On Tue, 27 Nov 2007 15:02:52 -0800, Greg KH <greg@kroah.com> wrote:
> 
> > > Among other things, kobject_init() sets the kobject's reference count to
> > > one.  Calling kobject_init() is not sufficient, however. Kobject users
> > > must, at a minimum, set the name of the kobject; this is the name that will
> > > be used in sysfs entries. 
> > 
> > Unless they don't register their kobject. (But they should always set a
> > name anyway to avoid funny debug messages, so it is probably a good
> > idea to call this a "must").
> 
> Yeah, we should require it. And kobject_cleanup() needs to be called to
> free the allocated name, if the object is not already added and needs to
> be deleted (common in rewinding on error).

Always using kobject_put() should take care of that.

> 
> Btw, do you have a good example for unregistered/unnamed kobjects?

Unfortunately not (I can only think of devices that might never be
registered).
