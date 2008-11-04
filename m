Return-Path: <linux-kernel-owner+w=401wt.eu-S1757184AbYKDWa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757184AbYKDWa2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 17:30:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754338AbYKDWaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 17:30:12 -0500
Received: from mail.fieldses.org ([66.93.2.214]:57214 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754197AbYKDWaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 17:30:11 -0500
Date: Tue, 4 Nov 2008 17:30:00 -0500
To: Doug Nazar <nazard@dragoninc.ca>
Cc: "'David Woodhouse'" <David.Woodhouse@intel.com>,
       "'Al Viro'" <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.28-rc3 truncates nfsd results
Message-ID: <20081104223000.GG10974@fieldses.org>
References: <000301c93eaa$fae98460$f0bc8d20$@ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000301c93eaa$fae98460$f0bc8d20$@ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2008 at 01:27:23PM -0500, Doug Nazar wrote:
> Commit 8d7c4203 "nfsd: fix failure to set eof in readdir in some situations"
> breaks the nfsd server. Bisected it back to this commit and reverting it
> fixes the problem.
> 
> However, it only happens on certain machines even with the same kernel &
> filesystem (ext3). I've two groups of similar computers, each group running
> identical kernels. The ones listing only ~250 files are of course in error.
> Eldritch is running 2.6.28-rc3 with that commit reverted. With 2.8.28-rc3 it
> showed the incorrect number.

Well, that's strange; it must be staring me in the face, but I don't see
the problem (and can't reproduce it).  Can you watch for the readdir
with wireshark and see if it's returning an error on the readdir?  Or is
it  just returning succesfully with eof set after the first ~250
entries?

(If you don't want to figure that out yourself you can collect a packet
trace with
	tcpdump -s0 -wtmp.pcap
and send me tmp.pcap.)

--b.

> 
> 
> [root@dryad - Tue Nov 04 13:15:41]
> [/usr/src/linux] for f in golem eldritch slyph kobold basilisk faun  dryad
> nymph troll ogre banshee cockatrice; do echo $f $(ls -1 /net/$f/usr/bin/ |
> wc -l); done
> 
> golem 1082
> eldritch 1644
> slyph 1718
> kobold 1081
> basilisk 267
> faun 265
> 
> dryad 1595
> nymph 245
> troll 243
> ogre 243
> banshee 926
> cockatrice 237
> 
> 
