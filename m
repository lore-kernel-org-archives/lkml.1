Return-Path: <linux-kernel-owner+w=401wt.eu-S1761549AbYAHQ1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761549AbYAHQ1Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 11:27:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755958AbYAHQ1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 11:27:16 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:39621 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751275AbYAHQ1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 11:27:14 -0500
Subject: Re: [RFC/PARTIAL PATCH 0/3] dma: passing "attributes" to dma_map_*
	routines
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: akepner@sgi.com
Cc: Tony Luck <tony.luck@intel.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Roland Dreier <rdreier@cisco.com>, David Miller <davem@davemloft.net>,
       Muli Ben-Yehuda <muli@il.ibm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20080108023222.GP23661@sgi.com>
References: <20080108023222.GP23661@sgi.com>
Content-Type: text/plain
Date: Tue, 08 Jan 2008 10:27:08 -0600
Message-Id: <1199809628.3534.34.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-01-07 at 21:32 -0500, akepner@sgi.com wrote:
>         The following patchset allows additional "attributes" to be 
>         passed to dma_map_*/dma_unmap_* implementations. (The reason 
>         why this is useful/necessary has been mentioned several
>         times, 
>         most recently here:
>         http://marc.info/?l=linux-kernel&m=119258541412724&w=2.)
>         
>         This is incomplete in that only ia64 and x86_64 are supported
>         - 
>         the purpose is mainly to give us something specific to
>         discuss. 

I'm already on record saying I don't think attributes in the generic
code is the right approach.  All of the attributes I can see adding are
bus specific (even to the extent that PCIe ones wouldn't apply to PCI
for instance).  I really think the right approach is to sort out the
attribute infrastructure and not try to overload the generic DMA API.  I
can certainly see that we might like to use it to take advantage of
other PCIe attributes (where available, of course).

Ultimately, it might be the best implementation course to pass the
attributes in to the dma_map routines, but I can't see them being
generic, they'd still be bus specific, so the correct way is to have a
bus specific attribute setup routine and pass some sort of opaque
attribute handle (or even just use the existing dma handle).

>         The approach here is to change the dma_map_* interface so 
>         that the last argument is an u32 which encodes the direction 
>         of the dma and, optionally, other attributes. Changing the 
>         interface is a bit intrusive, but callers of dma_map_* don't 
>         need to be modified.
>         
>         There are 3 patches:
>         
>         [1/3] dma: create linux/dma-direction.h 
>         [2/3] dma: ia64/sn2 allow "attributes" to be used by dma_map_*
>         [2/3] dma: x86_64 allow "attributes" to be used by dma_map_*

James

P.S. please update my email address: the @steeleye.com one no longer
works now.

