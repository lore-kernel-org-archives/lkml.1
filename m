Return-Path: <linux-kernel-owner+w=401wt.eu-S1760191AbYB2O1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760191AbYB2O1k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 09:27:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758690AbYB2O1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 09:27:30 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:53223 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758518AbYB2O13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 09:27:29 -0500
Subject: Re: Can Linux kernel handle unsynced TSC?
From: Peter Zijlstra <peterz@infradead.org>
To: Zhao Forrest <forrest.zhao@gmail.com>
Cc: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
In-Reply-To: <ac8af0be0802290620q208cf4b0sd672cf18594074eb@mail.gmail.com>
References: <ac8af0be0802290055m5ca1aa84yad6e38f6935f847@mail.gmail.com>
	 <1204281823.6243.78.camel@lappy>
	 <ac8af0be0802290620q208cf4b0sd672cf18594074eb@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 29 Feb 2008 15:27:21 +0100
Message-Id: <1204295241.6243.108.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-02-29 at 22:20 +0800, Zhao Forrest wrote:
> On 2/29/08, Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > On Fri, 2008-02-29 at 16:55 +0800, Zhao Forrest wrote:
> > > Sorry for reposting it.
> > >
> > > For example,
> > > 1 rdtsc() is invoked on CPU0
> > > 2 process is migrated to CPU1, and rdtsc() is invoked on CPU1
> > > 3 if TSC on CPU1 is slower than TSC on CPU0, can kernel guarantee
> > > that the second rdtsc() doesn't return a value smaller than the one
> > > returned by the first rdtsc()?
> >
> > No, rdtsc() goes directly to the hardware. You need a (preferably cheap)
> > clock abstraction layer on top if you need this.
> 
> Thank you for the clarification. I think gettimeofday() is such kind
> of clock abstraction layer, am I right?

Yes, gtod is one such a layer, however it fails the 'cheap' test for
many definitions of cheap.

