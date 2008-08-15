Return-Path: <linux-kernel-owner+w=401wt.eu-S1758426AbYHOR4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758426AbYHOR4Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 13:56:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756484AbYHOR4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 13:56:17 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:56714 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755248AbYHOR4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 13:56:16 -0400
Date: Fri, 15 Aug 2008 13:04:41 -0400
From: Theodore Tso <tytso@mit.edu>
To: douglas.leeder@sophos.com
Cc: "Press, Jonathan" <Jonathan.Press@ca.com>, alan@lxorguk.ukuu.org.uk,
       andi@firstfloor.org, Arjan van de Ven <arjan@infradead.org>,
       hch@infradead.org, Helge Hafting <helge.hafting@aitel.hist.no>,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       Peter Zijlstra <peterz@infradead.org>, viro@ZenIV.linux.org.uk
Subject: Re: [malware-list] TALPA - a threat model?  well sorta.
Message-ID: <20080815170441.GA22395@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, douglas.leeder@sophos.com,
	"Press, Jonathan" <Jonathan.Press@ca.com>, alan@lxorguk.ukuu.org.uk,
	andi@firstfloor.org, Arjan van de Ven <arjan@infradead.org>,
	hch@infradead.org, Helge Hafting <helge.hafting@aitel.hist.no>,
	linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
	Peter Zijlstra <peterz@infradead.org>, viro@ZenIV.linux.org.uk
References: <2629CC4E1D22A64593B02C43E855530304AE4BF6@USILMS12.ca.com> <20080815131820.053BF31679D@pmx1.sophos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080815131820.053BF31679D@pmx1.sophos.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2008 at 02:18:12PM +0100, douglas.leeder@sophos.com wrote:
> > - New infection makes it onto the machine before the signatures have
> > caught up with it.  This also happens.  There is an ongoing PR race
> > among AV vendors about who was faster on the draw to get out signatures
> > to detect some new malware.  The fact that this race exists reflects
> > that reality that there is some window during which new malware will
> > make it onto some number of machines before the scanners catch up.

Let's go back to the threat model.  The Threat Model which Eric Paris
has suggested is that we are only trying to solve the Scanning
Problem.  Just Scanning.

That implies if the malware has been written to the disk, we will
catch it once AV catching is turned on and the user attempts to run or
otherwise access the file with the bad content.  However, if the
malware starts running, then regardless of whether the malware is
running with user privileges, or manages to get root privileges via
some buffer overflow that wasn't caught via
LSM/SELinux/AppAmor/whatever, this is out of scope of Eric's proposal.

Are we agreed on that?  There may be other components of the solution
such as LSM, SELinux, etc., that will very likely be useful in
protecting the system once the malware starts running.  But I thought
Eric's proposal proposed excluding that from the Threat Model for the
purposes of the interface we are trying to solve.  If that's not true,
let's deal with it now.

> Not to mention removable media - it might be old hat, but infected/malware
> files can come in on floppies, CDs or USB flash discs careless left on the
> pavement outside an office.

That's not a problem given the scanning model proposed by Eric; when
you insert removable media, it will get scanned when it is first
accessed.

	  	    	     	     	     - Ted
