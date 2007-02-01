Return-Path: <linux-kernel-owner+w=401wt.eu-S1751618AbXBAVzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618AbXBAVzv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 16:55:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751602AbXBAVzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 16:55:51 -0500
Received: from gockel.physik3.uni-rostock.de ([139.30.44.16]:1180 "EHLO
	gockel.physik3.uni-rostock.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751438AbXBAVzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 16:55:50 -0500
Date: Thu, 1 Feb 2007 22:55:49 +0100 (CET)
From: Tim Schmielau <tim@physik3.uni-rostock.de>
To: Valdis.Kletnieks@vt.edu
cc: David Howells <dhowells@redhat.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Paul Mackerras <paulus@samba.org>,
       galak@kernel.crashing.org
Subject: Re: [PATCH] Add "is_power_of_2" checking to log2.h.
In-Reply-To: <200702012017.l11KHBG7026805@turing-police.cc.vt.edu>
Message-ID: <Pine.LNX.4.63.0702012225210.23656@gockel.physik3.uni-rostock.de>
References: <Pine.LNX.4.64.0701300543420.17991@CPE00045a9c397f-CM001225dbafb6>
 <3565.1170326639@redhat.com>            <Pine.LNX.4.63.0702011336490.15668@gockel.physik3.uni-rostock.de>
 <200702012017.l11KHBG7026805@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Feb 2007, Valdis.Kletnieks@vt.edu wrote:

> On Thu, 01 Feb 2007 13:39:15 +0100, Tim Schmielau said:
> > #define is_power_of_4(x) (is_power_of_2_or_zero(x) \
> >                           && (x & ((typeof(x))0x55555555)))
> 
> Those 5's are going to need more magic if x is a 64-bit typeof?

Yeah, I can't count. Make that

#define is_power_of_2_or_zero(x) ((x & (x-1))==0)
#define is_power_of_4(x) (is_power_of_2_or_zero(x) \
                          && (x & ((typeof(x))0x5555555555555555ull)))

of course.

Thanks,
Tim
