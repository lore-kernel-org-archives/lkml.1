Return-Path: <linux-kernel-owner+w=401wt.eu-S1750978AbXBMRUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750978AbXBMRUV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 12:20:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750993AbXBMRUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 12:20:21 -0500
Received: from one.firstfloor.org ([213.235.205.2]:41453 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbXBMRUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 12:20:19 -0500
From: Andi Kleen <ak@suse.de>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [patch 4/9] Remove the TSC synchronization on SMP machines
Date: Tue, 13 Feb 2007 18:20:14 +0100
User-Agent: KMail/1.9.5
Cc: Arjan van de Ven <arjan@infradead.org>, Vojtech Pavlik <vojtech@suse.cz>,
       Jiri Bohac <jbohac@suse.cz>, linux-kernel@vger.kernel.org,
       ssouhlal@freebsd.org, tglx@linutronix.de, johnstul@us.ibm.com,
       zippel@linux-m68k.org, andrea@suse.de
References: <20070201095952.589234000@jet.suse.cz> <1171348808.12771.19.camel@laptopd505.fenrus.org> <Pine.LNX.4.64.0702130906530.23634@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0702130906530.23634@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702131820.15180.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 February 2007 18:09, Christoph Lameter wrote:
> On Tue, 13 Feb 2007, Arjan van de Ven wrote:
> 
> > no quite the opposite. gettimeofday() currently is NOT monotonic
> > unfortunately. With this patchseries it actually has a better chance of
> > becoming that...
> 
> It is monotonic on IA64 at least and we have found that subtle application 
> bugs occur if it is not. IA64 (and other arches using time interpolation) 
> can insure the monotoneity of time sources. Are you sure about this? I 
> wonder why the new time of day subsystem does not have that?

Just to avoid spreading misinformation: modulo some new broken hardware
(which we always try to work around when found) i386/x86-64 gettimeofday
is monotonic.  AFAIK on the currently known hardware it should be generally
ok.

However ntpd can always screw you up, but that's inherent in the design.

Safer in general is to use clock_gettime(CLOCK_MONOTONIC, ...) which guarantees
no interference from ntpd

-Andi
