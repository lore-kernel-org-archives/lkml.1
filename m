Return-Path: <linux-kernel-owner+w=401wt.eu-S1754201AbYEZPPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201AbYEZPPc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 11:15:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751487AbYEZPPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 11:15:21 -0400
Received: from elasmtp-banded.atl.sa.earthlink.net ([209.86.89.70]:44359 "EHLO
	elasmtp-banded.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751004AbYEZPPU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 11:15:20 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=mindspring.com;
  b=QvI9/X8bhs4ysvlMAPn8g/RcTv5QOqgxMBjLMY/YMCoQWJnyeFbn9oepY68QnkJf;
  h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Date: Mon, 26 May 2008 11:14:58 -0400
From: Bill Fink <billfink@mindspring.com>
To: Alejandro Riveira =?ISO-8859-1?Q?Fern=E1ndez?= 
	<ariveira@gmail.com>
Cc: Theodore Tso <tytso@MIT.EDU>, Glen Turner <gdt@gdt.id.au>,
       Chris Peterson <cpeterso@cpeterso.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Jeff Garzik <jeff@garzik.org>, "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Rick Jones <rick.jones2@hp.com>,
       "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/net: remove network drivers' last few uses of
 IRQF_SAMPLE_RANDOM
Message-Id: <20080526111458.fff6c311.billfink@mindspring.com>
In-Reply-To: <20080526154326.1fe44214@Varda>
References: <482C7E53.3050300@hp.com>
	<482C8184.2030906@garzik.org>
	<482C8550.5000909@intel.com>
	<482C8D4D.3040702@garzik.org>
	<20080516132107.GA11304@csclub.uwaterloo.ca>
	<20080516161029.44ded734@core>
	<20080516173610.GA27126@csclub.uwaterloo.ca>
	<20080516191125.46f59ad6@core>
	<a24804730805162155m72e6b40aweb8822515c880c50@mail.gmail.com>
	<1211728189.5913.71.camel@andromache>
	<20080525232712.GF5970@mit.edu>
	<20080526154326.1fe44214@Varda>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.8.6; powerpc-yellowdog-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-ELNK-Trace: c598f748b88b6fd49c7f779228e2f6aeda0071232e20db4d32d7c0ca0a7a501643718b8e1e4770ef350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 96.234.158.248
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 May 2008, Alejandro Riveira Fernández wrote:

> El Sun, 25 May 2008 19:27:12 -0400
> Theodore Tso <tytso@MIT.EDU> escribió:
> 
> > On Mon, May 26, 2008 at 12:39:49AM +0930, Glen Turner wrote:
> > > 
> > > For example, /dev/random has run out. So the output of /dev/urandom
> > > is now determined by previous values of /dev/random.  I then send in
> > > a stack of network packets at regular intervals. So the output of
> > > /dev/urandom is now greatly determined by those packets.  My search
> > > space for the resulting key is small since /dev/urandom appears to
> > > be random, but in fact is periodic.
> > 
> > That's not how it works.  Basically, as long as there is *some*
> > entropy in the system, even from the /var/lib/random-seed, or from
> > keyboard interrupts, or from mouse interrupts, which is unknown to the
> > attacker, in the worse case /dev/urandom will be no worse than a
> > cryptographic random number generator.
> > 
>  [ ... ] 
>  
>  Just a shot in the dark... would hw sensors (raw data) chips be a good source
>  of entropy for /dev/random ?? 

For systems with high resolution timers, even if an attacker has total
knowledge/control of the network, it doesn't seem realistically possible
for them to determine the low order bits of the nanosecond timer of
disk and network I/O system calls, if those were used as a source of
entropy.  I think this is a case of the (unrealistic) best being an
enemy of the common (and realistic) good.

Another idea that occured to me:  How about using the low order bits
of the instruction memory address being executed that was interrupted
by the HZ timer interrupt.  This also doesn't seem to be something
that an external attacker could realistically determine.  And a
combination of these approaches would be that much stronger, combined
of course with any other available entropy sources.

						-Bill

