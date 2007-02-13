Return-Path: <linux-kernel-owner+w=401wt.eu-S1751038AbXBMIdF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751038AbXBMIdF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 03:33:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751193AbXBMIdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 03:33:04 -0500
Received: from one.firstfloor.org ([213.235.205.2]:55928 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbXBMIdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 03:33:03 -0500
From: Andi Kleen <andi@firstfloor.org>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [patch 4/9] Remove the TSC synchronization on SMP machines
Date: Tue, 13 Feb 2007 09:28:05 +0100
User-Agent: KMail/1.9.5
Cc: Christoph Lameter <clameter@sgi.com>, Vojtech Pavlik <vojtech@suse.cz>,
       Jiri Bohac <jbohac@suse.cz>, linux-kernel@vger.kernel.org,
       ssouhlal@freebsd.org, tglx@linutronix.de, johnstul@us.ibm.com,
       zippel@linux-m68k.org, andrea@suse.de
References: <20070201095952.589234000@jet.suse.cz> <Pine.LNX.4.64.0702121632420.19380@schroedinger.engr.sgi.com> <1171348808.12771.19.camel@laptopd505.fenrus.org>
In-Reply-To: <1171348808.12771.19.camel@laptopd505.fenrus.org>
Organization: -
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702130928.05838.andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 February 2007 07:40, Arjan van de Ven wrote:
> On Mon, 2007-02-12 at 16:34 -0800, Christoph Lameter wrote:
> > On Fri, 2 Feb 2007, Andi Kleen wrote:
> > 
> > > I've threatened to just disable RDTSC for ring 3 before, but it'll likely
> > > never happen because too many programs use it.
> > 
> > Those programs are aware that they are fiddling around with low level 
> > material but with this patchset we are going to have a non 
> > monotonic time subsystem?
> 
> no quite the opposite. gettimeofday() currently is NOT monotonic
> unfortunately. 

Anytime it is non monotonic that's a bug. We've had bugs
like this before, but recently we're doing reasonably well. Of course
there can be always improvements, but in general I don't agree
with your statement, sorry. You can usually rely on it being monotonic,
short of the known limitations (e.g. don't run ntpd) 

Usually it weren't really classical bugs, but more "hardware does
unexpected things under us". x86 hardware is a moving target unfortunately.

> With this patchseries it actually has a better chance of
> becoming that...

ntpd problem is fundamental, nothing will change that. However
it doesn't seem to be a big one in practice. 

-Andi
 
