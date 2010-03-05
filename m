Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729Ab0CEObH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 09:31:07 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:56964 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751423Ab0CEObF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 09:31:05 -0500
Date: Fri, 5 Mar 2010 09:31:02 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Hugh Daschbach <hdasch@broadcom.com>
cc: Greg KH <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Jan Blunck <jblunck@suse.de>, David Vrabel <david.vrabel@csr.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       james Bottomley <James.Bottomley@suse.de>,
       James Smart <james.smart@emulex.com>
Subject: RE: System reboot hangs due to race against devices_kset->list
 triggered by SCSI FC workqueue
In-Reply-To: <233671224A0FED4688218FFDBED26E1A5181BF12E4@IRVEXCHCCR01.corp.ad.broadcom.com>
Message-ID: <Pine.LNX.4.44L0.1003050926090.1677-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Mar 2010, Hugh Daschbach wrote:

> I have added get_device()/put_device() to ensure there's the device
> hasn't fully disappeared before calling list_del_init().  Is this
> needed?

Yes, it is.  In fact, it's necessary to insure the device doesn't
disappear before you call the shutdown routines!

>  If so, there's "might_sleep()" commented out in put_device().
> Do I need to release the lock before calling put_device()?

A better approach might be to do the list_del_init() while still 
holding the initial spinlock, before you call the shutdown methods.  
Then do the put_device() before reacquiring the spinlock at the end of 
the loop.

Alan Stern

