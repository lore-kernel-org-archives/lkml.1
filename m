Return-Path: <linux-kernel-owner+w=401wt.eu-S1752864AbZA1KN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbZA1KN1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 05:13:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751123AbZA1KNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 05:13:18 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:40149 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854AbZA1KNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 05:13:17 -0500
Subject: Re: [PATCH v3] timer: implement lockdep deadlock detection
From: Peter Zijlstra <peterz@infradead.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <1233136487.4151.5.camel@johannes.local>
References: <1233010786.4344.1.camel@johannes.local>
	 <20090126230721.GA6556@elte.hu> <1233046009.4012.3.camel@johannes.local>
	 <20090127132759.GI23121@elte.hu>  <20090127134128.GA24965@elte.hu>
	 <1233079597.4755.2.camel@johannes.local> <1233081027.10992.21.camel@laptop>
	 <1233082650.4455.9.camel@johannes.local> <1233130815.10992.39.camel@laptop>
	 <1233136487.4151.5.camel@johannes.local>
Content-Type: text/plain
Date: Wed, 28 Jan 2009 11:13:01 +0100
Message-Id: <1233137581.10992.44.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-28 at 10:54 +0100, Johannes Berg wrote:
> On Wed, 2009-01-28 at 09:20 +0100, Peter Zijlstra wrote:
> > On Tue, 2009-01-27 at 19:57 +0100, Johannes Berg wrote:
> > > This modifies the timer code in a way to allow lockdep to detect
> > > deadlocks resulting from a lock being taken in the timer function
> > > as well as around the del_timer_sync() call.
> > > 
> > > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> > 
> > Nice, thanks!
> 
> I actually got "trying to register non-static key" on my powerpc64
> machine. Is there a possibility that functions are not static??

Hmm, weird, afaict static_obj() includes both text and data, for the
core kernel as well as modules.

