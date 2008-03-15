Return-Path: <linux-kernel-owner+w=401wt.eu-S1754089AbYCOWdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089AbYCOWdg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 18:33:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752367AbYCOWd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 18:33:27 -0400
Received: from phunq.net ([64.81.85.152]:33191 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752155AbYCOWd0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 18:33:26 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Willy Tarreau <w@1wt.eu>
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Date: Sat, 15 Mar 2008 14:33:09 -0800
User-Agent: KMail/1.9.5
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, David Newall <davidn@davidnewall.com>,
       linux-kernel@vger.kernel.org
References: <200803092346.17556.phillips@phunq.net> <200803151417.13899.phillips@phunq.net> <20080315215427.GC13012@1wt.eu>
In-Reply-To: <20080315215427.GC13012@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803151533.10797.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 15 March 2008 14:54, Willy Tarreau wrote:
> I think it could get major adoption with ordered writes.

It already has ordered write when it is in flush mode.

OK, I hear you. There will be an ordered write mode that uses barriers
to decide the ordering.  It will greatly reduce the speed at which
ramback can flush dirty data because of the need to wait synchronously
on every barrier, of which there are many.  And thus will widen out the
window during which UPS power must remain available if power goes out,
in order to get all acknowledged transactions on to stable media.  The
advantage is, the stable media always has a point-in-time version of
the filesystem.

Don't expect this mode in the immediate future though, there are bugs
to fix in the current driver, which already implements the required
performance and stability requirements for a broad range of users.

> > That is why I keep recommending that a ramback setup be replicated or
> > mirrored, which people in this thread keep glossing over.  When
> > replicated or mirrored, you still get the microsecond-level transaction
> > times, and you get the safety too.
> 
> I agree, but in this case, you should present it this way. You have been
> insisting too much on the average PC's reliability, the fact that no kernel
> ever crashed for you, etc... So you are demonstrating that your product is
> good provided that everything goes perfectly. All people who have experienced
> software or hardware problems in the past (ie mostly everyone here) will not
> trust your code because it relies on pre-requisites they know they do not
> have.

That would have been a miscommunication then.  I see arguments coming
in that suggest embedded solutions, EMC for example, are inherently more
reliable than a Linux based solution.  Well guess what?  Some of those
embedded solutions already use Linux.

Also, peecees are much more reliable than people give them credit for,
especially if you harden up the obvious points of failure such as fans
and spinning disks.  Once you have your system all hardened up, then
you _still_ better replicate your important data.  Perhaps I should not
admit this, but I simply fail to do that on the machine from which I am
posting right now, which also runs my web server and mail system.  That
is because I would have to reboot it to install ddsnap so I can replicate
properly, and because the thing is so darn reliable that I just have
not gotten around to it.  I do copy off the important files from time
to time though, and do various other things to ameliorate the risk.  If
it was enterprise data I would obviously do a lot more.

> > There will be a whole bunch of patches from me that are SSD oriented,
> > over time.  The fact is, enterprise scale ramdisks are here now, while
> > enterprise scale flash is not.  Getting close, but not here.  And flash
> > does not approach the write performance of RAM, not now and probably
> > not ever.
> 
> My goal is not to replace RAM with flash, but disk with flash.

My immediate goal is to replace disk with RAM.

> You are 
> against ordered writes for a performance reason. Use SSD instead of
> hard drives and it will be as fast as sequential writes. Also, when
> you say that enterprise scale flash is not there, I don't agree. You
> can already afford hundreds of gigs of flash in 3,5" form factor. An
> 1.6 TB SSD has even been presented at CES2008, with sales announced
> for Q3. So clearly this will replace your hard drives soon, very soon.
> Even if it costs $5k, that's a very acceptable solution to replace a
> disk in a RAM-speed appliance.

Exactly what I mean: close but not there.  Those gigantic RAM boxes are
shipping now, and the same company has got a 5 TB flash box coming down
the pipe, and sooner than Q3.  But the RAM box will always outperform
the flash box.  You just keep throwing writes at it until all available
flash is in erase mode, and the thing slows down.  If that is not a
problem for you, then great, you can also save a lot of money by going
with flash.  But if nothing less than the ultimate in performance will
do, RAM is the only way to go.

Daniel
