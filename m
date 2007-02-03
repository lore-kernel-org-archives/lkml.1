Return-Path: <linux-kernel-owner+w=401wt.eu-S933390AbXBCAYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933390AbXBCAYB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 19:24:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933399AbXBCAYB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 19:24:01 -0500
Received: from outpost.ds9a.nl ([213.244.168.210]:46483 "EHLO outpost.ds9a.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933390AbXBCAYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 19:24:00 -0500
Date: Sat, 3 Feb 2007 01:23:59 +0100
From: bert hubert <bert.hubert@netherlabs.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Alan <alan@lxorguk.ukuu.org.uk>,
       Zach Brown <zach.brown@oracle.com>, linux-kernel@vger.kernel.org,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
Message-ID: <20070203002358.GA26422@outpost.ds9a.nl>
Mail-Followup-To: bert hubert <bert.hubert@netherlabs.nl>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>, Alan <alan@lxorguk.ukuu.org.uk>,
	Zach Brown <zach.brown@oracle.com>, linux-kernel@vger.kernel.org,
	linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
	Benjamin LaHaise <bcrl@kvack.org>
References: <Pine.LNX.4.64.0702011154110.3632@woody.linux-foundation.org> <20070202104900.GA13941@elte.hu> <Pine.LNX.4.64.0702020738500.15057@woody.linux-foundation.org> <20070202195932.15b9b4ed@localhost.localdomain> <Pine.LNX.4.64.0702021155460.15057@woody.linux-foundation.org> <20070202213019.202e8db5@localhost.localdomain> <Pine.LNX.4.64.0702021322310.15057@woody.linux-foundation.org> <20070202224259.GB1212@elte.hu> <Pine.LNX.4.64.0702021459550.15057@woody.linux-foundation.org> <Pine.LNX.4.64.0702021512450.15057@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702021512450.15057@woody.linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 02, 2007 at 03:17:57PM -0800, Linus Torvalds wrote:

> threads. But you need to look at what it is we parallelize here, and ask 
> yourself why we're doing what we're doing, and why people aren't *already* 
> just using a separate thread for it.

Partially this is for the bad reason that creating "i/o threads" (or even
processes) has a bad stigma to it, and additionally has always felt crummy.

On the first reason, the 'pain' of creating threads is actually rather
minor, so this feeling may have been wrong. The main thing is that you don't
wantonly create a thousand i/o threads, whereas you conceivably might want
to have a thousand outstanding i/o requests. At least I know I want to have
that ability.

Secondly, the actual mechanics of i/o processes isn't trivial, and feels
wasteful with lots of additional copying, or in the case of threads,
queueing and posting.

	Bert

-- 
http://www.PowerDNS.com      Open source, database driven DNS Software 
http://netherlabs.nl              Open and Closed source services
