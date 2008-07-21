Return-Path: <linux-kernel-owner+w=401wt.eu-S1754790AbYGUTPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790AbYGUTPw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 15:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755439AbYGUTOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 15:14:35 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:33401 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754790AbYGUTOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 15:14:32 -0400
Subject: Re: [PATCH 0/2] Migrate data off physical pages with corrected
	memory errors (Version 7)
From: Alex Williamson <alex.williamson@hp.com>
To: Russ Anderson <rja@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu, tglx@linutronix.de,
       Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org
In-Reply-To: <20080720173914.GA9409@sgi.com>
References: <20080718203514.GD29621@sgi.com>
	 <87prpa88iw.fsf@basil.nowhere.org>  <20080720173914.GA9409@sgi.com>
Content-Type: text/plain
Organization: OSLO R&D
Date: Mon, 21 Jul 2008 13:11:39 -0600
Message-Id: <1216667499.8806.79.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-07-20 at 12:39 -0500, Russ Anderson wrote:
> On Sat, Jul 19, 2008 at 12:37:11PM +0200, Andi Kleen wrote:
> > If you really wanted to do this you probably should hook it up
> > to mcelog's (or the IA64 equivalent) DIMM database
> 
> Is there an IA64 equivalent?  I've looked at the x86_64 mcelog,
> but have not found a IA64 version.

There's a bit in the SAL error record that can tell you when the
platform thinks the page should be deallocated.  In the section header
(B2.2), ERROR_RECOVERY_INFO, bit 3 "Error threshold exceeded".  If you
use this bit, then it's a platform decision.  If you want pages to be
deallocated on the first hit, then have your SAL always set that bit.  I
believe HP systems do implement this bit in SAL using some kind of
heuristics.

	Alex

-- 
Alex Williamson                             HP Open Source & Linux Org.

