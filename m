Return-Path: <linux-kernel-owner+w=401wt.eu-S1754277AbYCPWgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277AbYCPWgn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 18:36:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752546AbYCPWgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 18:36:36 -0400
Received: from phunq.net ([64.81.85.152]:41590 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752445AbYCPWgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 18:36:35 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Date: Sun, 16 Mar 2008 14:36:19 -0800
User-Agent: KMail/1.9.5
Cc: Willy Tarreau <w@1wt.eu>, David Newall <davidn@davidnewall.com>,
       linux-kernel@vger.kernel.org
References: <200803092346.17556.phillips@phunq.net> <200803161457.04580.phillips@phunq.net> <20080316215547.07824de7@core>
In-Reply-To: <20080316215547.07824de7@core>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803161536.20128.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On Sunday 16 March 2008 14:55, Alan Cox wrote:
> > > That isn't anything to do with what was being proposed. *ORDERING* not
> > > flush to media.
> > 
> > This is where you have made a fundamental mistake in your proposal.
> > Suppose you have a steady, heavy write load onto ramback.  Eventually,
> > the entire ramdisk will be dirty and you have to drop back to disk
> > speed, right?  My design does not suffer from that problem, but your
> > proposal does.
> 
> In your design the entire ramdisk goes bang and disappears on a crash.

According to you.  A more accurate statement: if you have the ramdisk
on the host, then the host is assumed to be reliable.  If the ramdisk
is external (http://www.violin-memory.com/products/violin1010.html)
then your statement is untrue in every sense.

But you did not address the logic of my statement above: that your
fundamental design prevents you from operating at ramdisk speed during
normal operation.

> > It gets worse than that.  Suppose somebody writes the same region
> > twice, how do you order that?  Do you try to store that new data
> > somewhere, keeping in mind that we are already at terabyte scale?  Is
> > there a limit on how much overwrite data you may have to store?  (No.)
> 
> You only have to care about ordering if there is a store barrier between
> the two (not usual).

No wait, it is completely normal.  There is a barrier on every journal
transaction.  Constructing such a load is trivial.

> You only have to care about filling if you generate 
> enough dirty blocks at a very high rate (which is unusual for most
> workloads).

It is completely normal for a transaction processing system.

> If you don't care about those then we have ramdisk already and 

I care about them, as do others.

> if you want to write a ramdisk driver for external ramdisk great. You'd

Exactly the purpose for which this driver was written.  And as a bonus
it happens to be useful for internal ramdisk applications as well.  (It
is useful for me, however your mileage may vary.)

> also fix the layering violations then by allowing device mapper to
> implement things like snapshotting and writeback seperated from your
> driver.

Device mapper already can, so I do not get your point.  Also, what is
this layering violation you refer to?

> Even in the extreme case that you propose there are trivial ways of
> getting coherency. Simple example - if you can sweep all the data out in
> say 10 minutes

If.

> then you can buy twice the physical media and ensure that 
> one of the two sets of disk backups is genuinely store barrier consistent
> to some snapshot time (say every 30 minutes but obviously user tunable).
> If you at least had some kind of credible snapshotting you'd find people
> less hostile to your glorified ramdisk.

Hostility does not equate to accuracy.  Galileo comes to mind.

I see people arguing that a server+linux+batteries+mirroring+replication
cannot achieve enterprise grade reliability.  Balderdash.

Regards,

Daniel
