Return-Path: <linux-kernel-owner+w=401wt.eu-S1756795AbYGZRZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795AbYGZRZ1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 13:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753159AbYGZRZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 13:25:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54223 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751946AbYGZRZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 13:25:16 -0400
Date: Sat, 26 Jul 2008 11:22:49 -0600
From: Pete Zaitcev <zaitcev@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Alan" <alan@clueserver.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: Problem mounting Motorola USB device
Message-Id: <20080726112249.1ade4980.zaitcev@redhat.com>
In-Reply-To: <20080725235122.0e097f1f.akpm@linux-foundation.org>
References: <52610.198.182.194.170.1216229551.squirrel@clueserver.org>
	<20080725235122.0e097f1f.akpm@linux-foundation.org>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.13.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jul 2008 23:51:22 -0700, Andrew Morton <akpm@linux-foundation.org> wrote:

> (cc linux-usb-devel)
> 
> On Wed, 16 Jul 2008 10:32:31 -0700 (PDT) "Alan" <alan@clueserver.org> wrote:

> > [...] The device gives an odd media error at towards
> > the end of the device.  It gave that before, but would still mount.

Weird. Actually, I would rather blame the partitioning code than
the usb-storage as such.

> > [...] I know I probably need a new memory card.  I
> > would like to recover this one first.

Want a practical suggestion? Try to stick the card into a common
many-in-one reader, a SanDisk SDDR-somenumber would usually work.
Save the data.

> > sd 6:0:0:0: Attached scsi generic sg2 type 0
> > sd 6:0:0:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
> > sd 6:0:0:0: [sdb] Sense Key : Medium Error [current]
> > sd 6:0:0:0: [sdb] Add. Sense: No additional sense information

Well, duh.

BTW Andrew added:

> It's a 2.6.24 -> 2.6.25 regression.

Maybe in FAT... See the sector number (1987576).

BTW, all Fedora kernels have usbmon enabled. May I see the trace?
Best of all, take the one from the working 2.6.24 (if such install
is still available). It would become obvious if usb-storage began to
do something different.

Obligatory notice: I don't think ub would fix this.

-- Pete
