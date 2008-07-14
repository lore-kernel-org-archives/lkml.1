Return-Path: <linux-kernel-owner+w=401wt.eu-S1758432AbYGNV22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758432AbYGNV22 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 17:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758257AbYGNV2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 17:28:16 -0400
Received: from outbound-mail-146.bluehost.com ([67.222.38.36]:38439 "HELO
	outbound-mail-146.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758243AbYGNV2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 17:28:15 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User:DomainKey-Status;
	b=K1rmk7QN8jNOHzK9fHTy96lI4CEzaTBauQXWn5+fgBSZPpsLps8GHSpzFFGxvcwgOXqmLGFRwWZFfA0bXfgenXSek6vnPwHeBowRO4wKMWooYpN04GA6GP1P6HQTvcmK;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Matthew Wilcox <matthew@wil.cx>
Subject: Re: x86: PCI multi domain/segment config access
Date: Mon, 14 Jul 2008 14:28:10 -0700
User-Agent: KMail/1.9.9
Cc: John Keller <jpk@sgi.com>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
References: <20080711211347.6461.68923.91734@attica.americas.sgi.com> <20080711212117.GW14894@parisc-linux.org>
In-Reply-To: <20080711212117.GW14894@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807141428.11022.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 11, 2008 2:21 pm Matthew Wilcox wrote:
> On Fri, Jul 11, 2008 at 04:13:47PM -0500, John Keller wrote:
> > On x86 PCI Config space access to domains/segments > 0 appears to be
> > broken. The noted patch related to PCI ext config space has all config
> > accesses to offsets < 256 using conf1 if available, which is most likely
> > the case.
> >
> > This would force usage of conf1 for non-extended config access (< 256) on
> > PCI domains > 0.
> >
> > Am I missing something, or how would a conf1 access reference a domain
> > other than zero?
>
> You're correct.  Sorry about that, I wasn't thinking about domains at
> the time I wrote the patch.  Try this:
>
> [X86] Fix PCI config space for domains > 0
>
> John Keller reports that PCI config space access is broken on machines
> with more than one domain.  conf1 accesses only work for domain 0.
>
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

Oops, yeah, good catch.  Thanks for fixing this up, Matthew.  Just applied it 
to my linux-next branch.

Thanks,
Jesse
