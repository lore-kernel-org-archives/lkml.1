Return-Path: <linux-kernel-owner+w=401wt.eu-S1754645AbZFXLOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbZFXLOX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 07:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751214AbZFXLOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 07:14:15 -0400
Received: from relay1.sgi.com ([192.48.179.29]:50250 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750818AbZFXLOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 07:14:14 -0400
Date: Wed, 24 Jun 2009 06:14:15 -0500
From: Robin Holt <holt@sgi.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Robin Holt <holt@sgi.com>, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>,
       Haren Myneni <hbabu@us.ibm.com>, kexec@lists.infradead.org
Subject: Re: [PATCH 1/7] ia64, kdump: Mask MCA/INIT on freezing cpus
Message-ID: <20090624111415.GA6878@sgi.com>
References: <4A39E247.4030908@jp.fujitsu.com> <4A39E2CF.80901@jp.fujitsu.com> <20090622134557.GC7084@sgi.com> <4A4022EA.1020506@jp.fujitsu.com> <20090623055536.GE6865@sgi.com> <4A408D32.9010500@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A408D32.9010500@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 05:07:14PM +0900, Hidetoshi Seto wrote:
> Robin Holt wrote:
> > On Tue, Jun 23, 2009 at 09:33:46AM +0900, Hidetoshi Seto wrote:
> >> Robin Holt wrote:
> > ...
> >> Do you mean that the 2nd kernel should be able to handle MCA/INIT from its
> >> boot up?  I guess the word PROM is nearly equal to PAL/SAL firmware, if so
> >> then I don't think there are good generic interface/procedure could be
> >> useful here.  Do you have any concrete idea?
> > 
> > No concrete ideas.  Just a really uneasy feeling whenever the INIT
> > is disabled.
> 
> Don't worry, don't be afraid.
> Again, my patches don't disable INIT until kdump is invoked.
> (And if kdump is invoked via INIT, it have already masked at the begging
>  of INIT handlers.)

The concern is that any time we prevent SAL from receiving control during
an MCA/INIT, we reduce the maintainability of the machine.  Having them
masked at any time results in the NMI/INIT not recording the PROM record
which we use to diagnose where the hang is.

In other patches, you implemented a do-nothing handler.  Could that
be used?

Alternatively, when the machine is first booted, the handler is defined
by SAL as a SAL routine.  Could you record that during kernel boot and
then just set the handler back to the SAL provided one prior to starting
the kexec kernel boot?  At that point, the machine is more like the
first boot.  Now that I think about this, this alternative seems fairly
attractive.

Thanks,
Robin
