Return-Path: <linux-kernel-owner+w=401wt.eu-S1031243AbXDZPJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031243AbXDZPJ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 11:09:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031259AbXDZPJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 11:09:56 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:45442 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031243AbXDZPJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 11:09:55 -0400
Date: Thu, 26 Apr 2007 17:12:47 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>, Tejun Heo <htejun@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH RFD] alternative kobject release wait mechanism
Message-ID: <20070426171247.181bc335@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <Pine.LNX.4.44L0.0704261040440.3552-100000@iolanthe.rowland.org>
References: <20070426102151.0da2e928@gondolin.boeblingen.de.ibm.com>
	<Pine.LNX.4.44L0.0704261040440.3552-100000@iolanthe.rowland.org>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.8.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007 10:58:45 -0400 (EDT),
Alan Stern <stern@rowland.harvard.edu> wrote:

> > > > The remove() method must also unset driver_data.
> > > 
> > > It doesn't really have to.  The driver core could do it.
> > 
> > I think it is more consistent if the driver takes care of the fields
> > specifically designed for its usage.
> 
> Yes.  However if the driver forgets to clear the field it shouldn't cause
> a warning.  After all, there won't be any harm; the next driver to bind 
> to the device will just overwrite the driver_data anyway.

Agreed, but it is still a good practice and should be recommended.

> > Yes. Especially since the "gone"-field may be contained in that
> > embedding structure if the subsystem controls it.
> 
> No, no!  The "gone" flag must be in the private data structure.  If it 
> were in a container of the device structure, then it could be overwritten 
> when a different driver binds to the device.

Argl, thinko again. You're right, of course.
