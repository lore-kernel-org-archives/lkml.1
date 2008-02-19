Return-Path: <linux-kernel-owner+w=401wt.eu-S1759591AbYBSC5F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759591AbYBSC5F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 21:57:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752363AbYBSC4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 21:56:53 -0500
Received: from mx1.redhat.com ([66.187.233.31]:47693 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752222AbYBSC4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 21:56:52 -0500
Date: Tue, 19 Feb 2008 02:56:43 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: David Chinner <dgc@sgi.com>
Cc: Michael Tokarev <mjt@tls.msk.ru>, Ric Wheeler <ric@emc.com>,
       device-mapper development <dm-devel@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] Re: [PATCH] Implement barrier support for single device DM devices
Message-ID: <20080219025643.GD4066@agk.fab.redhat.com>
Mail-Followup-To: David Chinner <dgc@sgi.com>,
	Michael Tokarev <mjt@tls.msk.ru>, Ric Wheeler <ric@emc.com>,
	device-mapper development <dm-devel@redhat.com>,
	Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
References: <20080215120821.GA8267@basil.nowhere.org> <20080215122002.GM29914@agk.fab.redhat.com> <47B58EAA.8040405@msgid.tls.msk.ru> <20080215142010.GA29552@one.firstfloor.org> <20080215141229.GB1788@agk.fab.redhat.com> <47B97E87.6040209@emc.com> <47B9870B.8060005@msgid.tls.msk.ru> <20080218221644.GN155407@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080218221644.GN155407@sgi.com>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2008 at 09:16:44AM +1100, David Chinner wrote:
> Surely any hardware that doesn't support barrier
> operations can emulate them with cache flushes when they receive a
> barrier I/O from the filesystem....
 
My complaint about having to support them within dm when more than one
device is involved is because any efficiencies disappear: you can't send
further I/O to any one device until all the other devices have completed
their barrier (or else later I/O to that device could overtake the
barrier on another device).  And then I argue that it would be better
for the filesystem to have the information that these are not hardware
barriers so it has the opportunity of tuning its behaviour (e.g.
flushing less often because it's a more expensive operation).

Alasdair
-- 
agk@redhat.com
