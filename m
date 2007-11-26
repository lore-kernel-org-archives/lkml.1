Return-Path: <linux-kernel-owner+w=401wt.eu-S1757685AbXKZSMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757685AbXKZSMV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 13:12:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752163AbXKZSML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 13:12:11 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:55979 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714AbXKZSMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 13:12:09 -0500
Date: Mon, 26 Nov 2007 12:11:49 -0600
To: Luke Browning <lukebr@linux.vnet.ibm.com>
Cc: michael@ellerman.id.au, Michael Neuling <mikey@neuling.org>,
       Jeff Garzik <jeff@garzik.org>, Jan-Bernd Themann <themann@de.ibm.com>,
       netdev <netdev@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Klein <osstklei@de.ibm.com>, linux-ppc <linuxppc-dev@ozlabs.org>,
       Christoph Raisch <raisch@de.ibm.com>, Paul Mackerras <paulus@samba.org>,
       Marcus Eder <meder@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>, ahuja@austin.ibm.com
Subject: Re: [PATCH] ehea: Add kdump support
Message-ID: <20071126181148.GF4551@austin.ibm.com>
References: <200711091433.51259.osstklei@de.ibm.com> <1196064988.19855.15.camel@concordia> <1196091697.7513.30.camel@luke-laptop.br.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1196091697.7513.30.camel@luke-laptop.br.ibm.com>
User-Agent: Mutt/1.5.11
From: linas@austin.ibm.com (Linas Vepstas)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Mon, Nov 26, 2007 at 01:41:37PM -0200, Luke Browning wrote:
> On Mon, 2007-11-26 at 19:16 +1100, Michael Ellerman wrote:
> 
> > For kdump we have to assume that the kernel is fundamentally broken,

If I may so humbly suggest: since ehea is a power6 thing only,
we should refocus our energies on "hypervisor assisted dump",
which solves all of these problems. 

In short, upon crash, the hypervisor will reset the 
pci devices into working order, and will then boot
a new fresh kernel into a tiny corner of ram. The rest
of ram is not cleared, and can be dumped. After the 
dump, the mem is returned to general use.

The key point here, for ehea, is "the hypervisor
will reset he device state to something rational".

Preliminary patches are at
http://patchwork.ozlabs.org/linuxppc/patch?id=14884
and following.

--linas
