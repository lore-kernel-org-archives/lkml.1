Return-Path: <linux-kernel-owner+w=401wt.eu-S933558AbYB2TCE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933558AbYB2TCE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 14:02:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758688AbYB2TBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 14:01:53 -0500
Received: from smtp-out.google.com ([216.239.33.17]:32647 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021AbYB2TBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 14:01:52 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=m4kjUzpMy6Gy3D/LI99Tl5gP3mBRu0hMt7fKyT0ZdoZ9I7L4FX1Mx2ybBsFB+nWpl
	WOfukMw6EzLbNmx70Yw9A==
Message-ID: <65dd6fd50802291101j3786ee60iec0f3a24f5df9945@mail.gmail.com>
Date: Fri, 29 Feb 2008 11:01:38 -0800
From: "Ollie Wild" <aaw@google.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [RFC/PATCH] RLIMIT_ARG_MAX
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Michael Kerrisk" <michael.kerrisk@googlemail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>, michael.kerrisk@gmail.com,
       carlos@codesourcery.com, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>, drepper@redhat.com,
       mtk.manpages@gmail.com
In-Reply-To: <alpine.LFD.1.00.0802290956110.17889@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1204119455.6242.403.camel@lappy>
	 <alpine.LFD.1.00.0802290801290.17889@woody.linux-foundation.org>
	 <c49095e30802290858t42eb8a61ua0ed73e27971bc77@mail.gmail.com>
	 <alpine.LFD.1.00.0802290907480.17889@woody.linux-foundation.org>
	 <1204305488.6243.113.camel@lappy>
	 <alpine.LFD.1.00.0802290928200.17889@woody.linux-foundation.org>
	 <1204306934.6243.119.camel@lappy>
	 <alpine.LFD.1.00.0802290956110.17889@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 29, 2008 at 10:12 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> So it's not *going* to be exact even with RLIMIT_ARG_MAX, because it's
> going to have all those other issues to contend with - on a 64-bit
> architecture, the argument _pointers_ are often within an order of
> magnitude of the argument strings themselves, and I don't think your patch
> counted them as part of the argument/environemnt size (I was too lazy to
> check the sources, but I'm pretty sure argv/env_start/end is just the
> string space, not the pointers).

This is precisely why I picked 25% as the maximum argument size ratio.
 In practice, that 25% can easily mean 50% or more.  If people want to
increase this, it can probably be tweaked somewhat, but switching it
to, say, 50% probably isn't a good idea.

Ollie
