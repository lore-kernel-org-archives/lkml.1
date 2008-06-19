Return-Path: <linux-kernel-owner+w=401wt.eu-S1753422AbYFSUgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422AbYFSUgz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 16:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751031AbYFSUgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 16:36:45 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:46461 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbYFSUgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 16:36:44 -0400
Message-ID: <485AC2D9.2060406@s5r6.in-berlin.de>
Date: Thu, 19 Jun 2008 22:34:33 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.13) Gecko/20080313 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Pekka J Enberg <penberg@cs.helsinki.fi>,
       Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       dsd@gentoo.org, mdharm-usb@one-eyed-alien.net,
       linux-usb@vger.kernel.org, vegardno@ifi.uio.no,
       James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
       Greg KH <greg@kroah.com>
Subject: Re: [RFC/PATCH] usb-storage: wait for device scanning before mounting
 root
References: <Pine.LNX.4.44L0.0804241704220.14840-100000@iolanthe.rowland.org> <Pine.LNX.4.64.0804250022160.1209@sbz-30.cs.Helsinki.FI> <48118DDD.8010507@s5r6.in-berlin.de> <Pine.LNX.4.64.0804251110400.758@sbz-30.cs.Helsinki.FI> <20080425091122.GA14990@parisc-linux.org> <20080619182310.GA30833@parisc-linux.org> <485AA7EA.6080105@s5r6.in-berlin.de> <20080619185419.GN4392@parisc-linux.org> <485AB95E.5070609@s5r6.in-berlin.de> <20080619202226.GP4392@parisc-linux.org>
In-Reply-To: <20080619202226.GP4392@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Thu, Jun 19, 2008 at 09:54:06PM +0200, Stefan Richter wrote:
>> When to say "I've finished scanning"? --- I think the answer is:  When
>> (a) probing of a configurable number of SCSI targets or logical units
>> was finished or (b) a configurable timeout occurs, whatever of the two
>> happens first.
...
> Yes, I do see the problem.  There's no way the SCSI core can know when
> a driver has finished scanning, so I've punted to the driver to set its
> own timeout here.

This can of course (and frequently is) implemented in userspace, but
requires an initrd.  I'm not up to speed how scsi_wait_scan is put to
use --- it can be used without initrd, can't it?

> I know that new devices really can show up at any
> time, but I think it's reasonable to say that if a machine is booted
> with the same configuration as last time, the drives should show up with
> the same names.

I know that is not what you meant here, but...:

They do show up with the same target identifiers and logical unit
identifiers.  The SCSI core doesn't pass the identifiers through to
userland though.  (Couldn't resist to go off-subject.  Sorry.)
-- 
Stefan Richter
-=====-==--- -==- =--==
http://arcgraph.de/sr/
