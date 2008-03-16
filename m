Return-Path: <linux-kernel-owner+w=401wt.eu-S1753543AbYCPV53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbYCPV53 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 17:57:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752565AbYCPV5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 17:57:18 -0400
Received: from phunq.net ([64.81.85.152]:45750 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752524AbYCPV5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 17:57:18 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Date: Sun, 16 Mar 2008 13:57:03 -0800
User-Agent: KMail/1.9.5
Cc: Willy Tarreau <w@1wt.eu>, David Newall <davidn@davidnewall.com>,
       linux-kernel@vger.kernel.org
References: <200803092346.17556.phillips@phunq.net> <200803151500.05993.phillips@phunq.net> <20080315230558.12e9c96c@the-village.bc.nu>
In-Reply-To: <20080315230558.12e9c96c@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803161457.04580.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 15 March 2008 16:05, Alan Cox wrote:0
> > ,,,interpreting a barrier to mean flush through to rotating media...
> > performance will drop to the millisecond per transaction zone...
> 
> That isn't anything to do with what was being proposed. *ORDERING* not
> flush to media.

This is where you have made a fundamental mistake in your proposal.
Suppose you have a steady, heavy write load onto ramback.  Eventually,
the entire ramdisk will be dirty and you have to drop back to disk
speed, right?  My design does not suffer from that problem, but your
proposal does.

It gets worse than that.  Suppose somebody writes the same region
twice, how do you order that?  Do you try to store that new data
somewhere, keeping in mind that we are already at terabyte scale?  Is
there a limit on how much overwrite data you may have to store?  (No.)

> I want the speed and reliability. Without that ramback is a distraction
> until someone solves the real problems.

Somebody has.  But please feel free to solve some other problem.  I
would love to see a detailed design from you, or a patch.

> > they need to achieve microsecond level transaction throughput and data
> 
> You have no guarantee of commit to stable storage so your use of the word
> "transaction" is a bit farcical.

The UPS provides a guarantee of commit to stable storage.  No amount of
FUD will change that.  But please go ahead and calculate the risks
involved.  I am confident you will admit that there are standard]
techniques available to ameliorate risk, which may be applied _on top of_
ramback, thus not destroying its microsecond-level transaction
performance as you propose.

Daniel
