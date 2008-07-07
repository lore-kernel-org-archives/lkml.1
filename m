Return-Path: <linux-kernel-owner+w=401wt.eu-S1755839AbYGGQTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839AbYGGQTg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 12:19:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754342AbYGGQTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 12:19:17 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:58856 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754096AbYGGQTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 12:19:16 -0400
Date: Mon, 7 Jul 2008 10:19:14 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Grant Grundler <grundler@parisc-linux.org>
Cc: Michael Ellerman <michael@ellerman.id.au>, linux-pci@vger.kernel.org,
       kaneshige.kenji@jp.fujitsu.com, mingo@elte.hu, tglx@linutronix.de,
       davem@davemloft.net, dan.j.williams@intel.com,
       Martine.Silbermann@hp.com, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 1/4] PCI MSI: Store the number of messages in the msi_desc
Message-ID: <20080707161914.GB14894@parisc-linux.org>
References: <20080705132728.GO14894@parisc-linux.org> <1215264855-4372-1-git-send-email-matthew@wil.cx> <1215396324.19157.14.camel@localhost> <20080707024125.GU14894@parisc-linux.org> <1215402512.9862.16.camel@localhost> <20080707120418.GZ14894@parisc-linux.org> <20080707160203.GA7521@colo.lackof.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080707160203.GA7521@colo.lackof.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2008 at 10:02:03AM -0600, Grant Grundler wrote:
> > -	if (!entry->dev || entry->msi_attrib.type != PCI_CAP_ID_MSI)
> > +	if (!entry->dev || entry->msi_attrib.is_msix)
> >  		return;
> 
> This is why I don't like bit fields.
> "uninitialized" (3rd state) doesn't exist.
> Is there something else in place to catch that state?
> 
> (It's clearly a bug if someone did that and maybe I'm
> being too paranoid.)

msi_descs are only allocated in two places, one of which sets is_msix
and the other doesn't.  I wouldn't object to passing parameters to
alloc_msi_entry() so there's only one place that fills in is_msix, but
yes, I do think the current code is too paranoid.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
