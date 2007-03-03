Return-Path: <linux-kernel-owner+w=401wt.eu-S2992880AbXCCBcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992880AbXCCBcQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 20:32:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992826AbXCCBcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 20:32:16 -0500
Received: from ns2.suse.de ([195.135.220.15]:34916 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992880AbXCCBcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 20:32:15 -0500
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [RFC] div64_64 support
References: <20070223170527.4ca695b2@freekitty>
	<Pine.LNX.4.61.0702262108010.23355@yvahk01.tjqt.qr>
	<20070226143127.5c74bec9@freekitty>
From: Andi Kleen <andi@firstfloor.org>
Date: 03 Mar 2007 03:31:52 +0100
In-Reply-To: <20070226143127.5c74bec9@freekitty>
Message-ID: <p73slcnawh3.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger <shemminger@linux-foundation.org> writes:

> Here is another way to handle the 64 bit divide case.
> It allows full 64 bit divide by adding the support routine
> GCC needs.

Not supplying that was intentional by Linus so that people
think twice (or more often) before they using such expensive
operations. A plain / looks too innocent.

Is it really needed by CUBIC anyways?  It uses it for getting
the cubic root, but the algorithm recommended by Hacker's Delight
(great book) doesn't use any divisions at all. Probably better 
to use a better algorithm without divisions.

-Andi
