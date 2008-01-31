Return-Path: <linux-kernel-owner+w=401wt.eu-S1759302AbYAaF7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759302AbYAaF7T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 00:59:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751211AbYAaF7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 00:59:09 -0500
Received: from outbound-mail-39.bluehost.com ([69.89.20.193]:54440 "HELO
	outbound-mail-39.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751061AbYAaF7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 00:59:08 -0500
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 Jan 2008 00:59:08 EST
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Greg KH <greg@kroah.com>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver opt-in
Date: Wed, 30 Jan 2008 21:51:12 -0800
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Matthew Wilcox <matthew@wil.cx>, Arjan van de Ven <arjan@infradead.org>,
       Tony Camuso <tcamuso@redhat.com>,
       Grant Grundler <grundler@parisc-linux.org>, Loic Prylli <loic@myri.com>,
       Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, Martin Mares <mj@ucw.cz>
References: <20080114225225.GQ18741@parisc-linux.org> <20080129031804.GF20198@parisc-linux.org> <20080129131955.GC10761@kroah.com>
In-Reply-To: <20080129131955.GC10761@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801302151.12544.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 169.222.10.15 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 January 2008 05:19:55 am Greg KH wrote:
> Hahahaha, oh, that's a good one...
>
> But what about the thousands of implementations out there that are
> buggy?
>
> I'm with Arjan here, I'm very skeptical.

Ugg, let's look at the actual data (again); I'm really not sure why people 
are jumping to such dire conclusions about the current state of things.

AIUI we only have 3 issues so far (remember mmconfig has been enabled in -mm 
for a long time):
  1) host bridge decode problems (disabling decode to avoid overlaps can 
cause some bridges to stop decoding RAM addrs, but we have a fix for that)
  2) config space retry on ATI (I think willy already debunked this one?)
  3) some FUD about SMM or other firmware interrupts coming in during BAR 
sizing while decode is disabled (this one is just pure FUD; if we want to 
solve it properly we need a new platform hook to disable SMM/NMI/etc. 
around PCI probing)

What else was there?  What reason do we have to think that things are so 
disastrous?

So I really prefer willy's approach to Arjan's alternative...

Jesse
