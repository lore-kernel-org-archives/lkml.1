Return-Path: <linux-kernel-owner+w=401wt.eu-S1753838AbYJAMnL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838AbYJAMnL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 08:43:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753044AbYJAMm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 08:42:56 -0400
Received: from 206-248-169-182.dsl.ncf.ca ([206.248.169.182]:47937 "EHLO
	phobos.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591AbYJAMm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 08:42:56 -0400
Date: Wed, 1 Oct 2008 08:42:54 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Grant Grundler <grundler@parisc-linux.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci: introduce users of ioremap_pcibar()
Message-ID: <20081001124254.GD10632@phobos.i.cabal.ca>
References: <20080926163641.288bf868@infradead.org> <20080926163718.32f0867e@infradead.org> <20080929072643.GA28871@colo.lackof.org> <20080929064220.374c68a4@infradead.org> <20080929171049.GA14409@colo.lackof.org> <20080929102325.0ca5c0c9@infradead.org> <20081001052450.GB7348@colo.lackof.org> <20080930153001.1107c0de@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080930153001.1107c0de@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2008 at 03:30:01PM -0700, Arjan van de Ven wrote:
> On Tue, 30 Sep 2008 23:24:50 -0600
> Grant Grundler <grundler@parisc-linux.org> wrote:
> 
> > 
> > > And pci_iomap() takes more parameters than most driver writers want
> > > or need. Most of the time it's "I want the whole bar"; even if my
> > > patch wraps around that, making the API simpler is still worth it
> > > imo
> > 
> > You are right about that.
> > Would calling the API "pci_iomap_bar()" to keep the naming consistent
> > help make it more acceptable?
> 
> I'm fine with pci_iomap_bar()... it meets my goals
> Would be nice if I'd be allowed to make it only work on MEM bars not IO
> bars (so that drivers don't accidentally end up calling this on an IO
> bar and then using readl() etc)
> 

If they use the iomap interface they shouldn't be using readl at all,
they should be using ioread*... It would be a bug otherwise.

cheers, Kyle
