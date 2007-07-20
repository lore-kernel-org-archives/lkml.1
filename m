Return-Path: <linux-kernel-owner+w=401wt.eu-S1761371AbXGTL1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761371AbXGTL1q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 07:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756314AbXGTL1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 07:27:36 -0400
Received: from wr-out-0506.google.com ([64.233.184.230]:59267 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755644AbXGTL1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 07:27:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qD4ZVMMVRY5d2gwc6pHtH67WJuDbrQMOfnV2VC4NCHCERcKVYNdga42Pk/eKmjNg1hbjAdEgkj7zeIWZyHzAzUKMzpI4D5JZX+96uZV3MUlkYao7F8DKLrN55ZftLPlYVmWYuZPNSgdiwuLPCt8oAIqzPaic/9dXjJ6FXt9gU+s=
Message-ID: <a781481a0707200427y7a29257fpfa5978c391eb3534@mail.gmail.com>
Date: Fri, 20 Jul 2007 16:57:33 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Chris Snook" <csnook@redhat.com>
Subject: Re: [RFC 1/4] CONFIG_STABLE: Define it
Cc: "clameter@sgi.com" <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, akpm@linux-foundation.org
In-Reply-To: <46A097FE.3000701@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070531002047.702473071@sgi.com>
	 <20070531003012.302019683@sgi.com>
	 <a781481a0707200341o21381742rdb15e6a9dc770d27@mail.gmail.com>
	 <46A097FE.3000701@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/20/07, Chris Snook <csnook@redhat.com> wrote:
> Satyam Sharma wrote:
> > [ Just cleaning up my inbox, and stumbled across this thread ... ]
> >
> >
> > On 5/31/07, clameter@sgi.com <clameter@sgi.com> wrote:
> >> Introduce CONFIG_STABLE to control checks only useful for development.
> >>
> >> Signed-off-by: Christoph Lameter <clameter@sgi.com>
> >> [...]
> >>  menu "General setup"
> >>
> >> +config STABLE
> >> +       bool "Stable kernel"
> >> +       help
> >> +         If the kernel is configured to be a stable kernel then various
> >> +         checks that are only of interest to kernel development will be
> >> +         omitted.
> >> +
> >
> >
> > "A programmer who uses assertions during testing and turns them off
> > during production is like a sailor who wears a life vest while drilling
> > on shore and takes it off at sea."
> >                                                - Tony Hoare
> >
> >
> > Probably you meant to turn off debug _output_ (and not _checks_)
> > with this config option? But we already have CONFIG_FOO_DEBUG_BAR
> > for those situations ...
>
> There are plenty of validation and debugging features in the kernel that go WAY
> beyond mere assertions, often imposing significant overhead (particularly when
> you scale up) or creating interfaces you'd never use unless you were doing
> kernel development work.  You really do want these features completely removed
> from production kernels.

As for entire such "development/debugging-related features", most (all, really)
should anyway have their own config options.

> The point of this is not to remove one-line WARN_ON and BUG_ON checks (though we
> might remove a few from fast paths), but rather to disable big chunks of
> debugging code that don't implement anything visible to a production workload.

Oh yes, but it's still not clear to me why or how a kernel-wide "CONFIG_STABLE"
or "CONFIG_RELEASE" would help ... what's wrong with finer granularity
"CONFIG_xxx_DEBUG_xxx" kind of knobs?
