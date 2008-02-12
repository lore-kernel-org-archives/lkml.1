Return-Path: <linux-kernel-owner+w=401wt.eu-S1762906AbYBLSpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762906AbYBLSpx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 13:45:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758641AbYBLSpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 13:45:41 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:44710 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754843AbYBLSpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 13:45:40 -0500
Subject: Re: [PATCH] enclosure: add support for enclosure services
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: ltuikov@yahoo.com, linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>, jeff@garzik.org
In-Reply-To: <20080212102244.32869382@appleyard>
References: <1202172065.3096.154.camel@localhost.localdomain>
	 <922945.25870.qm@web31811.mail.mud.yahoo.com>
	 <20080212102244.32869382@appleyard>
Content-Type: text/plain
Date: Tue, 12 Feb 2008 12:45:35 -0600
Message-Id: <1202841935.3137.94.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-02-12 at 10:22 -0800, Kristen Carlson Accardi wrote:
> I apologize for taking so long to review this patch.  I obviously agree
> wholeheartedly with Luben.  The problem I ran into while trying to
> design an enclosure management interface for the SATA devices is that
> there is all this vendor defined stuff.  For example, for the AHCI LED
> protocol, the only "defined" LED is 'activity'.  For LED2 and LED3 it
> is up to hardware vendors to define these.  For SGPIO there's all kinds
> of ways for hw vendors to customize.  I felt that it was going to be a
> maintainance nightmare to have to keep track of various vendors
> enclosure implementations in the ahci driver, and that it'd be better
> to just have user space libraries take care of that.  Plus, that way a
> vendor doesn't have to get a patch into the kernel to get their new
> spiffy wizzy bang blinky lights working (think of how long it takes
> something to even get into a vendor kernel, which is what these guys
> care about...).  So I'm still not sold on having an enclosure
> abstraction in the kernel - at least for the SATA controllers.

Correct me if I'm wrong, but didn't the original AHCI enclosure patch
expose activity LEDs via sysfs?

I'm not saying there aren't a lot of non standard pieces that need to be
activated by direct commands or other user activated protocol.  I am
saying there are a lot of standard pieces that we could do with showing
in a uniform manner.

The pieces I think are absolutely standard are

1. Actual enclosure presence (is this device in an enclosure)
2. Activity LED, this seems to be a feature of every enclosure.

I also think the following are reasonably standard (based on the fact
that most enclosure standards recommend but don't require this):

3. Locate LED (for locating the device).  Even if you only have an
activity LED, this is usually done by flashing the activity LED in a
well defined pattern.
4. Fault.  this is the least standardised of the lot, but does seem to
be present in about every enclosure implementation.

All I've done is standardise these four pieces ... the services actually
take into account that it might not be possible to do certain of these
(like fault).

James


