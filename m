Return-Path: <linux-kernel-owner+w=401wt.eu-S1753982AbYJaDAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982AbYJaDAW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 23:00:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753314AbYJaDAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 23:00:06 -0400
Received: from cantor.suse.de ([195.135.220.2]:48201 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753174AbYJaDAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 23:00:05 -0400
Date: Fri, 31 Oct 2008 03:59:58 +0100
From: Nick Piggin <npiggin@suse.de>
To: Glauber Costa <glommer@redhat.com>
Cc: Matt Mackall <mpm@selenic.com>, Avi Kivity <avi@redhat.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       aliguori@codemonkey.ws, Jeremy Fitzhardinge <jeremy@goop.org>,
       Krzysztof Helt <krzysztof.h1@poczta.fm>
Subject: Re: [PATCH] regression: vmalloc easily fail.
Message-ID: <20081031025958.GB19268@wotan.suse.de>
References: <1225234513-3996-1-git-send-email-glommer@redhat.com> <20081028232944.GA3759@wotan.suse.de> <20081029094856.GD4269@poweredge.glommer> <20081029101145.GB5953@wotan.suse.de> <49083B14.6070402@redhat.com> <20081029104333.GD5953@wotan.suse.de> <20081029220737.GF11532@poweredge.glommer> <20081030044941.GA9470@wotan.suse.de> <1225385162.23508.33.camel@calx> <20081030180443.GE18634@poweredge.glommer>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081030180443.GE18634@poweredge.glommer>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2008 at 04:04:43PM -0200, Glauber Costa wrote:
> On Thu, Oct 30, 2008 at 11:46:02AM -0500, Matt Mackall wrote:
> > On Thu, 2008-10-30 at 05:49 +0100, Nick Piggin wrote:
> > > I still think we should get rid of the guard pages in non-debug kernels
> > > completely,
> > 
> > For what it's worth, I agree.
> Do we want any specific option, or is DEBUG_VM enough ?

I'd almost say DEBUG_PAGEALLOC; which could also disable lazy unmapping
in order to catch use-after free better. Or just a different option
entirely.

DEBUG_VM has, so far, been kept to relatively cheap tests that are not
much pain to turn on, and shouldn't result in much behavioural change
of algorithms/data structures AFAIKS. Which can be a good thing.
