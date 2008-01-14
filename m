Return-Path: <linux-kernel-owner+w=401wt.eu-S1755231AbYANI2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231AbYANI2g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 03:28:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754832AbYANI2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 03:28:22 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:20777 "EHLO
	viefep33-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754806AbYANI2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 03:28:20 -0500
Subject: Re: [PATCH] Remove timer frequency choice if tickless is enabled
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Carlos R. Mafra" <crmafra2@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20080114082543.GC18296@elte.hu>
References: <20080112020026.GB5849@Pilar.physics.ucla.edu>
	 <20080112032718.GA3946@Pilar.socal.rr.com> <20080114082543.GC18296@elte.hu>
Content-Type: text/plain
Date: Mon, 14 Jan 2008 09:28:15 +0100
Message-Id: <1200299295.7415.0.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.4 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-01-14 at 09:25 +0100, Ingo Molnar wrote:
> (lkml Cc:-ed)
> 
> * Carlos R. Mafra <crmafra2@gmail.com> wrote:
> 
> >  choice
> >  	prompt "Timer frequency"
> > +	depends on !NO_HZ
> >  	default HZ_250
> >  	help
> >  	 Allows the configuration of the timer frequency. It is customary
> 
> we are not there yet to be able to do this. With NO_HZ the tick is only 
> disabled when we go idle - but it still runs (and we rely on it, for 
> example in the scheduler code) while we are non-idle. Peter Zijlstra is 
> working on the 'high-res scheduler tick' feature to remove the scheduler 
> dependencies.

Yes, and even then we're still not there, there are various other
features that are tick driven, among them the RCU quiecent state
machine.

