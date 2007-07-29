Return-Path: <linux-kernel-owner+w=401wt.eu-S1761340AbXG2Iyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761340AbXG2Iyr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 04:54:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760665AbXG2Iyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 04:54:37 -0400
Received: from 1wt.eu ([62.212.114.60]:4060 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760663AbXG2Iyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 04:54:36 -0400
Date: Sun, 29 Jul 2007 10:54:27 +0200
From: Willy Tarreau <w@1wt.eu>
To: Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
Cc: "Darryl L. Miles" <darryl-mailinglists@netbauds.net>,
       linux-kernel@vger.kernel.org, Netdev <netdev@vger.kernel.org>
Subject: Re: TCP SACK issue, hung connection, tcpdump included
Message-ID: <20070729085427.GA22784@1wt.eu>
References: <46AC2CBE.5010500@netbauds.net> <20070729064511.GA18718@1wt.eu> <Pine.LNX.4.64.0707291052300.10340@kivilampi-30.cs.helsinki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0707291052300.10340@kivilampi-30.cs.helsinki.fi>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 29, 2007 at 11:26:00AM +0300, Ilpo Järvinen wrote:
> On Sun, 29 Jul 2007, Willy Tarreau wrote:
> 
> > On Sun, Jul 29, 2007 at 06:59:26AM +0100, Darryl L. Miles wrote:
> > > CLIENT = Linux 2.6.20.1-smp [Customer build]
> > > SERVER = Linux 2.6.9-55.ELsmp [Red Hat Enterprise Linux AS release 4 
> > > (Nahant Update 5)]
> > > 
> > > The problems start around time index 09:21:39.860302 when the CLIENT issues 
> > > a TCP packet with SACK option set (seemingly for a data segment which has 
> > > already been seen) from that point on the connection hangs.
> 
> ...That's DSACK and it's being correctly sent. To me, it seems unlikely to 
> be the cause for this breakage...
> 
> > Where was the capture taken ? on CLIENT or on SERVER (I suspect client from
> > the timers) ? 
> 
> ...I would guess the same based on SYN timestamps (and from the DSACK 
> timestamps)...
> 
> > A possible, but very unlikely reason would be an MTU limitation
> > somewhere, because the segment which never gets correctly ACKed is also the
> > largest one in this trace.
> 
> Limitation for 48 byte segments? You have to be kidding... :-) But yes,
> it seems that one of the directions is dropping packets for some reason 
> though I would not assume MTU limitation... Or did you mean some other 
> segment?

No, I was talking about the 1448 bytes segments. But in fact I don't
believe it much because the SACKs are always retransmitted just afterwards.

BTW, some information are missing. It would have been better if the trace
had been read with tcpdump -Svv. We would have got seq numbers and ttl.
Also, we do not know if there's a firewall between both sides. Sometimes,
some IDS identify attacks in crypted traffic and kill connections. It
might have been the case here, with the connection closed one way on an
intermediate firewall.

Regards,
Willy

