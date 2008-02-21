Return-Path: <linux-kernel-owner+w=401wt.eu-S1760922AbYBUD3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760922AbYBUD3j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 22:29:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751565AbYBUD32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 22:29:28 -0500
Received: from mail.suse.de ([195.135.220.2]:48779 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752941AbYBUD3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 22:29:20 -0500
From: Neil Brown <neilb@suse.de>
To: device-mapper development <dm-devel@redhat.com>
Date: Thu, 21 Feb 2008 14:29:19 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18364.61455.517441.304953@notabene.brown>
Cc: David Chinner <dgc@sgi.com>, Andi Kleen <andi@firstfloor.org>,
       Michael Tokarev <mjt@tls.msk.ru>, linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] Re: [PATCH] Implement barrier support for single
	device DM devices
In-Reply-To: message from Jeremy Higdon on Monday February 18
References: <20080215120821.GA8267@basil.nowhere.org>
	<20080215122002.GM29914@agk.fab.redhat.com>
	<47B58EAA.8040405@msgid.tls.msk.ru>
	<20080215142010.GA29552@one.firstfloor.org>
	<20080215141229.GB1788@agk.fab.redhat.com>
	<47B97E87.6040209@emc.com>
	<47B9870B.8060005@msgid.tls.msk.ru>
	<20080218221644.GN155407@sgi.com>
	<20080219071948.GA244758@sgi.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday February 18, jeremy@sgi.com wrote:
> 
> 
> I'll put it even more strongly.  My experience is that disabling write
> cache plus disabling barriers is often much faster than enabling both
> barriers and write cache enabled, when doing metadata intensive
> operations, as long as you have a drive that is good at CTQ/NCQ.

Doesn't this speed gain come at a correctness cost?  Barriers aren't
only about flushed the write cache.  They are also about preventing
re-ordering, both at the "elevator" layer and inside the device.
If the device does CTQ, it could re-order requests could it not?
Then two writes sent from the fs could make it to media in the wrong
order, and a power failure in between could corrupt your data.

Or am I misunderstanding something ??

(of course this only applies to XFS where disabling barriers means
"hope for the best", as opposed to ext3 where disabling barriers means
"don't trust the device, impose explicit ordering").

NeilBrown
