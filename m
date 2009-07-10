Return-Path: <linux-kernel-owner+w=401wt.eu-S1758036AbZGJXrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758036AbZGJXrl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 19:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757436AbZGJXrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 19:47:32 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48624 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757388AbZGJXrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 19:47:31 -0400
Date: Fri, 10 Jul 2009 19:46:47 -0400
From: Dave Jones <davej@redhat.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       cpufreq@vger.kernel.org
Subject: Re: 2.6.31-rc2+: Interrupts enabled after cpufreq_suspend
Message-ID: <20090710234646.GA11669@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Marcin Slusarz <marcin.slusarz@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Linux PM List <linux-pm@lists.linux-foundation.org>,
	cpufreq@vger.kernel.org
References: <4A561074.5080407@gmail.com> <20090710192511.GB6240@redhat.com> <1247264617.21776.6.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247264617.21776.6.camel@pasglop>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 11, 2009 at 08:23:37AM +1000, Ben Herrenschmidt wrote:
 > On Fri, 2009-07-10 at 15:25 -0400, Dave Jones wrote:
 > 
 > > The answer seems to be in 42d4dc3f4e1ec1396371aac89d0dccfdd977191b
 > > which introduced all this code to work around some failure that only happens
 > > on PPC...
 > > 
 > >     [PATCH] Add suspend method to cpufreq core
 > >     
 > >     In order to properly fix some issues with cpufreq vs. sleep on
 > >     PowerBooks, I had to add a suspend callback to the pmac_cpufreq driver.
 > >     I must force a switch to full speed before sleep and I switch back to
 > >     previous speed on resume.
 > > 
 > > 
 > > Ben, is there something better we can do here ?
 > > 
 > > I really don't want to add an #ifdef __powerpc__ to core code if we can help it.
 > > I'd rather we didn't call into driver guts at all from the suspend path.
 > 
 > Wait a minute ... having a suspend/resume method in cpufreq is one
 > thing, having it muck around with SMP is another :-) The ppc code
 > doesn't do that.
 > 
 > There's nothing fundamentally "fail" in requiring a switch to a given
 > frequency before suspend. I don't know what kind of major FAIL the K8
 > code is doing here though :-)

The fail part comes from the fact that interrupts get reenabled.
And that's something that can easily happen out of our control if
we call into acpi_cpufreq's ->get method for example, so powernow-k8 isn't
the sole reason.

 > I'm happy instead of #ifdef's however to push the logic into the ppc
 > driver, or use a flag that the ppc driver sets to enable that logic.

Cool.

	Dave

