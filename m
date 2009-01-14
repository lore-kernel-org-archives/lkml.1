Return-Path: <linux-kernel-owner+w=401wt.eu-S1761469AbZANOpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761469AbZANOpo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 09:45:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758264AbZANOpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 09:45:19 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:40870 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755647AbZANOpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 09:45:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=nNnhC4VI8JXtj3lSVllrVl7qaB8tJhaYmDjBoxErwpHlwPb0OHlEqHhiXbOds0DY6Q
         fPwaetZh7Klt8muqlCYbx+/OXA918FJqAemsQWcuAKmjbUdSNt9DCJ+lv1N7PR5SwslZ
         rt9T++AlnViuZ088zDxJKd6y+uGBGc6ByBLwo=
Message-ID: <84144f020901140645o68328e01ne0e10ace47555e19@mail.gmail.com>
Date: Wed, 14 Jan 2009 16:45:15 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Nick Piggin" <npiggin@suse.de>
Subject: Re: [patch] SLQB slab allocator
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       "Lin Ming" <ming.m.lin@intel.com>,
       "Christoph Lameter" <cl@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <20090114142200.GB25401@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20090114090449.GE2942@wotan.suse.de>
	 <84144f020901140253s72995188vb35a79501c38eaa3@mail.gmail.com>
	 <20090114114707.GA24673@wotan.suse.de>
	 <84144f020901140544v56b856a4w80756b90f5b59f26@mail.gmail.com>
	 <20090114142200.GB25401@wotan.suse.de>
X-Google-Sender-Auth: 06d8b3fa3806c7db
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,

On Wed, Jan 14, 2009 at 4:22 PM, Nick Piggin <npiggin@suse.de> wrote:
> The problem is there was apparently no plan for resolving the SLAB vs SLUB
> strategy. And then features and things were added to one or the other one.
> But on the other hand, the SLUB experience was a success in a way because
> there were a lot of performance regressions found and fixed after it was
> merged, for example.

That's not completely true. I can't speak for Christoph, but the
biggest problem I have is that I have _no way_ of reproducing or
analyzing the regression. I've tried out various benchmarks I have
access to but I haven't been able to find anything.

The hypothesis is that SLUB regresses because of kmalloc()/kfree()
ping-pong between CPUs and as far as I understood, Christoph thinks we
can improve SLUB with the per-cpu alloc patches and the freelist
management rework.

Don't get me wrong, though. I am happy you are able to work with the
Intel engineers to fix the long standing issue (I want it fixed too!)
but I would be happier if the end-result was few simple patches
against mm/slub.c :-).

On Wed, Jan 14, 2009 at 4:22 PM, Nick Piggin <npiggin@suse.de> wrote:
> I'd love to be able to justify replacing SLAB and SLUB today, but actually
> it is simply never going to be trivial to discover performance regressions.
> So I don't think outright replacement is great either (consider if SLUB
> had replaced SLAB completely).

If you ask me, I wish we *had* removed SLAB so relevant people could
have made a huge stink out of it and the regression would have been
taken care quickly ;-).

                       Pekka
