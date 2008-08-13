Return-Path: <linux-kernel-owner+w=401wt.eu-S1753424AbYHMUYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424AbYHMUYW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 16:24:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751098AbYHMUYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 16:24:11 -0400
Received: from wbmler1.mail.xerox.com ([13.13.138.216]:50792 "EHLO
	wbmler1.mail.xerox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbYHMUYK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 16:24:10 -0400
X-Greylist: delayed 1140 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Aug 2008 16:24:10 EDT
X-Xerox-Source-Ip: 13.151.210.15
X-Xerox-Source-Name: usa7061gw002.na.xerox.net
X-Xerox-Reported-Name: USA7061GW002.na.xerox.net
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [linux-pm] Power management for SCSI
Date: Wed, 13 Aug 2008 16:03:57 -0400
Message-ID: <556445368AFA1C438794ABDA8901891C094876DA@USA0300MS03.na.xerox.net>
In-Reply-To: <Pine.LNX.4.44L0.0808131534440.13982-100000@iolanthe.rowland.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [linux-pm] Power management for SCSI
Thread-Index: Acj9fgOinRSiEJBfQF+cb9OZZ6kalgAAH0HQ
References: <200808131825.27303.oneukum@suse.de> <Pine.LNX.4.44L0.0808131534440.13982-100000@iolanthe.rowland.org>
From: "Leisner, Martin" <Martin.Leisner@xerox.com>
To: "Alan Stern" <stern@rowland.harvard.edu>,
       "Oliver Neukum" <oneukum@suse.de>
Cc: "Linux-pm mailing list" <linux-pm@lists.osdl.org>,
       "kernel list" <linux-kernel@vger.kernel.org>, <teheo@novell.com>,
       <James.Bottomley@hansenpartnership.com>, "Pavel Machek" <pavel@suse.cz>,
       "Stefan Richter" <stefanr@s5r6.in-berlin.de>
X-OriginalArrivalTime: 13 Aug 2008 20:03:59.0573 (UTC) FILETIME=[B98C9050:01C8FD7F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Regarding these scsi suspend patches, there's a general
problem to drop power on disk devices on a running system.
I discussed it in:

http://www.gossamer-threads.com/lists/linux/kernel/811598

We have a sequence:
    a) stop further block requests
    b) sync the disk (and sync the cache -- there was talk on and off
       for several years about sync not realling syncing)
    c) drop power on the disk

We tweak the ext3 mount timeout and the /proc/sys/vm settings to put
the computer into laptop mode.

When a read comes along, we reverse the process...(or a forced write
which generally won't happen).

But we need to add patches to the device driver and the block layer to
enable this...it seems useful if there was a more generic way to
handle it...maybe registering a callback to reenable power and a
mechanism
to start the poweroff sequence...

We've done this in 2.6.20, I wonder if there's any work along these
lines in recent kernels (I'm going to look at 2.6.2[67]...)

Marty

>   -----Original Message-----
>   From: linux-pm-bounces@lists.linux-foundation.org [mailto:linux-pm-
>   bounces@lists.linux-foundation.org] On Behalf Of Alan Stern
>   Sent: Wednesday, August 13, 2008 3:37 PM
>   To: Oliver Neukum
>   Cc: Linux-pm mailing list; kernel list; teheo@novell.com;
>   James.Bottomley@hansenpartnership.com; Pavel Machek; Stefan Richter
>   Subject: Re: [linux-pm] Power management for SCSI
>   
>   On Wed, 13 Aug 2008, Oliver Neukum wrote:
>   
>   > > In Alan's patch, SCSI calls scsi_host_template methods (if the
LLD
>   > > provides ones) to suspend and resume a Scsi_Host.  The LLD can
use
>   them
>   > > to work with the underlying infrastructure to determine what can
be
>   done
>   > > at that time.  I.e. are there other protocols or other
initiator-
>   like
>   > > nodes sharing the link?  If yes or if "maybe yes", the
>   infrastructure
>   > > keeps the link up.  If not, it can move it into a low-power
state.
>   >
>   > That is a parculiar way of viewing it. Alan's patch introduce
runtime
>   > pm attributes to the devices. Quoting:
>   >
>   
>   With the original patch, you can't operate on the link independent
from
>   the devices.  But with the revised patch (whenever I manage to find
>   time to write it!), you _will_ be able to.
>   
>   Alan Stern
>   
>   _______________________________________________
>   linux-pm mailing list
>   linux-pm@lists.linux-foundation.org
>   https://lists.linux-foundation.org/mailman/listinfo/linux-pm
