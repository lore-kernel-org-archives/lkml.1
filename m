Return-Path: <linux-kernel-owner+w=401wt.eu-S1756809AbYDPCAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809AbYDPCAo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 22:00:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752812AbYDPCAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 22:00:32 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:21412 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645AbYDPCAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 22:00:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=xYycc5oEWJ5a5eM4hkd4+EVSHPty9WJdN5bzoWRbogp59unjSDZV/BJd+g2Z3kMv5A2OiK2weMysYkLDH/FLK23aMoJZ7GcqULH1H3MNf00oHKiKF5g4Rw5fXR2AwATX94HQn3mbdIQ5Sv5rIM0tY9dT/TvPBpLQWjK891XQH64=
Message-ID: <86802c440804151900t3357eb52w4cf2339b38ce2c17@mail.gmail.com>
Date: Tue, 15 Apr 2008 19:00:18 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch] mm: sparsemem memory_present() memory corruption fix
Cc: "Christoph Lameter" <clameter@sgi.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       "Mel Gorman" <mel@csn.ul.ie>, "Nick Piggin" <npiggin@suse.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, apw@shadowen.org,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <86802c440804151830h3917619ct5f1077530020f13f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080415201734.GA25628@elte.hu>
	 <alpine.LFD.1.00.0804151353380.2879@woody.linux-foundation.org>
	 <20080416000356.GA24737@elte.hu> <20080416001816.GA26295@elte.hu>
	 <86802c440804151732j519a541t9d8e4f6b49a53313@mail.gmail.com>
	 <20080416004430.GA26928@elte.hu>
	 <Pine.LNX.4.64.0804151745440.6876@schroedinger.engr.sgi.com>
	 <20080416005231.GC26996@elte.hu> <20080416011704.GA439@elte.hu>
	 <86802c440804151830h3917619ct5f1077530020f13f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2008 at 6:30 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
> On Tue, Apr 15, 2008 at 6:17 PM, Ingo Molnar <mingo@elte.hu> wrote:
>  >
>  >  * Ingo Molnar <mingo@elte.hu> wrote:
>  >
>  >  > > > this is the only call to memory_present() we do in 32-bit arch
>  >  > > > setup, so it's required.
>  >  > >
>  >  > > We could clip there if SPARSEMEM is configured. I wonder if this
>  >  > > affects other platforms that need HIGHMEM support?
>  >  >
>  >  > clip where and what?
>  >
>  >  i.e. as per my previous argument i'd consider the need to sanitize the
>  >  calls in the architecture fundamentally wrong.
>  >
>  >  whether the core code emits a warning or allows the call is an
>  >  additional question i mention in the changelog - but the core sparse
>  >  memory code should _definitely_ not silently overflow a key internal
>  >  array ... (of which data structure the architecture code is not even
>  >  aware of)
>
>  or you can move that check into find_max_pfn for x86_32? so it will
>  not affect other platform regarding Christoph's concern?
>
the patch doesn't have side effects on x86_64.

YH
