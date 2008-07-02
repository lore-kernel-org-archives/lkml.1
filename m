Return-Path: <linux-kernel-owner+w=401wt.eu-S1758919AbYGBWSf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758919AbYGBWSf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 18:18:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754693AbYGBWS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 18:18:26 -0400
Received: from gate.crashing.org ([63.228.1.57]:52268 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754525AbYGBWS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 18:18:26 -0400
Subject: Re: Removing sysdevs?
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Andi Kleen <andi@firstfloor.org>
Cc: Greg KH <greg@kroah.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Nathan Lynch <ntl@pobox.com>, Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <486BF9AC.6070704@firstfloor.org>
References: <18539.8141.683072.967851@cargo.ozlabs.ibm.com>
	 <486B9B3A.4060709@firstfloor.org> <20080702185145.GB20938@kroah.com>
	 <200807022341.44965.rjw@sisk.pl> <20080702214853.GA10451@kroah.com>
	 <486BF9AC.6070704@firstfloor.org>
Content-Type: text/plain
Date: Thu, 03 Jul 2008 08:17:58 +1000
Message-Id: <1215037078.21182.62.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-02 at 23:57 +0200, Andi Kleen wrote:
> > The plan is:
> > 	- remaining driver core cleanups to allow for multiple drivers
> > 	  to be bound to individual devices
> > 	- add multiple binding support to the core
> > 	- migrate existing sysdevs to struct device, now that multiple
> > 	  binding is allowed
> > 	- delete sysdev structure
> > 	- profit!
> 
> I hope the sysdev semantics of running with interrupts etc. will be kept?

What "running with interrupts" ? :-) Are you talking specifically about
suspend/resume ? In this case, normal devices also provide irq_off
variants of suspend/resume.

In some areas, those semantics are even a problem for sysdevs. For
example, it's been a pain in the neck for cpufreq on powermac not to be
able to schedule in its suspend routine. Among others...

Cheers,
Ben.


