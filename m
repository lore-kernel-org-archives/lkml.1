Return-Path: <linux-kernel-owner+w=401wt.eu-S1760404AbYEPSeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760404AbYEPSeT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 14:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755004AbYEPSeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 14:34:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36211 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409AbYEPSeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 14:34:01 -0400
Date: Fri, 16 May 2008 15:33:56 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH][PCI]: Introduce pci_find_capability_cached and make
	MSI use it
Message-ID: <20080516183356.GA7307@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org, linux-rt-users@vger.kernel.org
References: <20080515160426.GD14846@ghostprotocols.net> <20080515170407.GM9921@parisc-linux.org> <20080515171003.GF14846@ghostprotocols.net> <200805161044.34938.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805161044.34938.jbarnes@virtuousgeek.org>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, May 16, 2008 at 10:44:34AM -0700, Jesse Barnes escreveu:
> On Thursday, May 15, 2008 10:10 am Arnaldo Carvalho de Melo wrote:
> > Em Thu, May 15, 2008 at 11:04:07AM -0600, Matthew Wilcox escreveu:
> > > On Thu, May 15, 2008 at 01:04:26PM -0300, Arnaldo Carvalho de Melo wrote:
> > > > 	So I implemented pci_find_capability_cached and made MSI use it
> > > > for good measure, please consider applying.
> > >
> > > As I told you on IRC, this is just the MSI code being complete crap.
> > > It should be caching the offset itself.  We shouldn't have this extra
> > > array in the struct pci_dev just because MSI is broken.
> >
> > Well, we can certainly do that, its just that I did this first and
> > thought that perhaps there could be some other users, but I see that 44
> > extra bytes per pci_dev can be a pain if the only one to reap benefits
> > is MSI, can't you think of any other users? I couldn't detect any so far
> > in my admitedly limited testing.
> 
> There are a few other common cap checks, but I don't think they compare to MSI 
> in terms of latency sensitivity (though I didn't audit all the CAP_ID_EXP 
> checks, there are quite a few of those).
> 
> Since we know MSI is a problem, let's just go with fixing that for now.  If we 
> find that other caps are also causing problems we can revisit caching all of 
> them; the patch is simple enough.

Do you want me to submit another patch or can you cook up one?

- Arnaldo
