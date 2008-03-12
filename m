Return-Path: <linux-kernel-owner+w=401wt.eu-S1754127AbYCLTSf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127AbYCLTSf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 15:18:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751694AbYCLTS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 15:18:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:34865 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560AbYCLTS1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 15:18:27 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] [PATCH] cpuidle: avoid singing capacitors
Date: Wed, 12 Mar 2008 15:17:52 -0400
User-Agent: KMail/1.9.9
Cc: Andi Kleen <andi@firstfloor.org>, Pierre Ossman <drzeus-list@drzeus.cx>,
       LKML <linux-kernel@vger.kernel.org>, Adam Belay <abelay@novell.com>,
       Lee Revell <rlrevell@joe-job.com>
References: <20080303231033.GB15255@one.firstfloor.org> <20080311085145.5fcf3186@mjolnir.drzeus.cx> <20080311104822.GC18917@one.firstfloor.org>
In-Reply-To: <20080311104822.GC18917@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803121517.52801.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 March 2008, Andi Kleen wrote:
> > I have now found a very hacky workaround that is slightly better than
> > disabling C3 altogether; making C3 exclusive to one core at a time. It
> > seems to kill the noise and the system now spends 50% in C3, instead of
> > 0%.
> 
> I suspect it won't do much of C3 if only one core is idle this way.
> Most likely you just disabled C3 this way in a way invisible to software.

Andi is correct.
C-states are coordinated in hardware.
ie. if both cores enter core-C3, then the hardware allows the package
to enter package C3.

Package C-states are a big deal -- that is where most of the power savings is.

So preventing all the cores from entering C3 at the same time is
the opposite of what we want to be doing.

-Len
