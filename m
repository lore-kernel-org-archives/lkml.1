Return-Path: <linux-kernel-owner+w=401wt.eu-S1758371AbYC0BXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758371AbYC0BXc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 21:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755126AbYC0BXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 21:23:23 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42233 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754676AbYC0BXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 21:23:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: benh@kernel.crashing.org
Subject: Re: [RFC][PATCH 1/3] PM: Introduce new top level suspend and hibernation callbacks (rev. 4)
Date: Thu, 27 Mar 2008 02:23:05 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Alexey Starikovskiy <astarikovskiy@suse.de>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Oliver Neukum <oliver@neukum.org>
References: <200803262353.30566.rjw@sisk.pl> <200803270054.58546.rjw@sisk.pl> <1206576403.6926.62.camel@pasglop>
In-Reply-To: <1206576403.6926.62.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803270223.06715.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 27 of March 2008, Benjamin Herrenschmidt wrote:
> 
> > > There is absolutely no point getting a second struct anymore.
> > 
> > I obviously disagree with that opinion, so please elaborate.
> 
> Well, what does it bring you ? Why can't it be one struct ? To save
> space in the data area ?

Mostly, but not only that.

There are users of 'struct pm_ops' that aren't even supposed to define the
_noirq callbacks (device types and device classes), so I thought it would be
better to introduce a separate _noirq struct after all.

> I don't think it makes things much cleaner. But I won't fight a war for it,
> now that they are clearly named differently and things like prepare/complete
> are no longer in "noirq", it's semantically the same thing as having the
> fields in one structure, so it's mostly cosmetic.

Well, I'm not going to fight for having the two separate stuctures either.
Also, it wouldn't be difficult to rearrange thigs so that all of the callbacks
are in one structure, so if other people think it's better to do it this way,
I'll go for it.

Thanks,
Rafael
