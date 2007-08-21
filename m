Return-Path: <linux-kernel-owner+w=401wt.eu-S1758341AbXHULPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758341AbXHULPd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 07:15:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755462AbXHULPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 07:15:25 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37514 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754176AbXHULPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 07:15:24 -0400
Date: Tue, 21 Aug 2007 13:15:23 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jan Glauber <jang@linux.vnet.ibm.com>, heiko.carstens@de.ibm.com,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [accounting regression since rc1]  scheduler updates
Message-ID: <20070821111523.GA3795@one.firstfloor.org>
References: <20070812163225.GA11996@elte.hu> <200708141037.48001.borntraeger@de.ibm.com> <20070820154529.GA300@elte.hu> <1187629438.8541.40.camel@localhost> <20070820180810.GA25160@elte.hu> <p73lkc5zl2m.fsf@bingen.suse.de> <20070821070922.GA16695@elte.hu> <20070821100717.GA692@one.firstfloor.org> <20070821102023.GA24111@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070821102023.GA24111@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> i know there are some incredibly broken (but rare) boxes where the bios 
> will report it only knows C1 and do C2? Is that the case you are 
> referring to, or is there something else too?

There are first a couple of older and not so old (Centaur) chips that 
generally stop the TSC in C1.

And also some boxes who shouldn't have anything deeper than C2 have
trouble with the TSC. For example I got a Opteron machine (which
definitely shouldn't have any C2 since it's two socket) where the
TSC appears to stop or at least slow down a lot in C1.

And thirdly it's just unclean to add all kinds of custom hooks
there. It was already ugly in NOHZ, please don't continue that.

-Andi
