Return-Path: <linux-kernel-owner+w=401wt.eu-S1757699AbZGJWYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757699AbZGJWYR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 18:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757343AbZGJWYD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 18:24:03 -0400
Received: from gate.crashing.org ([63.228.1.57]:51691 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756425AbZGJWYB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 18:24:01 -0400
Subject: Re: 2.6.31-rc2+: Interrupts enabled after cpufreq_suspend
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Dave Jones <davej@redhat.com>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       cpufreq@vger.kernel.org
In-Reply-To: <20090710192511.GB6240@redhat.com>
References: <4A561074.5080407@gmail.com>  <20090710192511.GB6240@redhat.com>
Content-Type: text/plain
Date: Sat, 11 Jul 2009 08:23:37 +1000
Message-Id: <1247264617.21776.6.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-10 at 15:25 -0400, Dave Jones wrote:

> The answer seems to be in 42d4dc3f4e1ec1396371aac89d0dccfdd977191b
> which introduced all this code to work around some failure that only happens
> on PPC...
> 
>     [PATCH] Add suspend method to cpufreq core
>     
>     In order to properly fix some issues with cpufreq vs. sleep on
>     PowerBooks, I had to add a suspend callback to the pmac_cpufreq driver.
>     I must force a switch to full speed before sleep and I switch back to
>     previous speed on resume.
> 
> 
> Ben, is there something better we can do here ?
> 
> I really don't want to add an #ifdef __powerpc__ to core code if we can help it.
> I'd rather we didn't call into driver guts at all from the suspend path.

Wait a minute ... having a suspend/resume method in cpufreq is one
thing, having it muck around with SMP is another :-) The ppc code
doesn't do that.

There's nothing fundamentally "fail" in requiring a switch to a given
frequency before suspend. I don't know what kind of major FAIL the K8
code is doing here though :-)

I'm happy instead of #ifdef's however to push the logic into the ppc
driver, or use a flag that the ppc driver sets to enable that logic.

Cheers,
Ben.


