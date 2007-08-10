Return-Path: <linux-kernel-owner+w=401wt.eu-S1760695AbXHJAez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760695AbXHJAez (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 20:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754567AbXHJAes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 20:34:48 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:11448 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873AbXHJAer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 20:34:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=NjISo7NVKYkgc+BfgTaOvIJW4T6/si4fYHn5GSIgeJymLEWJcLtB3s2OgUHiKVuCsZVg3bfu4dB9gQvGibZZlMZAxP9TVqjtMvs4/Xndrw4HKW1/LfpF6VbF2MUl2mIHxgP+3fG81tRagKNqY64z0bQ0i5rGBGO47mQBhh2ftBQ=
Message-ID: <dc1166600708091734p22612a72g7fcc3e229203918f@mail.gmail.com>
Date: Fri, 10 Aug 2007 10:34:46 +1000
From: "Michael Ellerman" <michael@ellerman.id.au>
To: ljhc@br.ibm.com
Subject: Re: SLUB doesn't work with kdump kernel on Cell
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       "Christoph Lameter" <clameter@sgi.com>,
       "Arnd Bergmann" <arndb@arndb.de>, cbe-oss-dev@ozlabs.org
In-Reply-To: <1186667828.3038.18.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1186604151.3608.46.camel@localhost.localdomain>
	 <200708082310.59997.arnd@arndb.de>
	 <1186667828.3038.18.camel@localhost.localdomain>
X-Google-Sender-Auth: 58ff4a3cc9f5cc0e
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/9/07, Lucio Correia <ljhc@br.ibm.com> wrote:
> On Wed, 2007-08-08 at 23:10 +0200, Arnd Bergmann wrote:
> > On Wednesday 08 August 2007, Lucio Correia wrote:
> > >   DMA             0 ->    12288
> > >   Normal      12288 ->    12288
> > > early_node_map[2] active PFN ranges
> > >     0:        0 ->     2560
> > >     1:    12287 ->    12288
> >
> > As Christoph found, this memory map is really strange. Other machines
> > have something like
> >
> > Zone PFN ranges:
> >   DMA             0 ->    16384
> >   Normal      16384 ->    16384
> > early_node_map[2] active PFN ranges
> >     0:        0 ->     8192
> >     1:     8192 ->    16384
> >
> > Lucio,
> > What code builds the memory map that gets passed to the kdump kernel?

It comes out of the device tree, just like a regular kernel. The
device tree for the kdump kernel is built by kexec-tools, it parses
/proc/device-tree and does a bunch of logic to avoid various reserved
regions: the kernel, TCE tables, RTAS etc.

> I also tried to pass maxcpus=1 for the command line of second kernel,
> and it didn't work. How can I alternatively disable the node?

maxcpus is poorly tested and is known to be broken on Cell, please
don't use it, or fix it first :)

cheers
