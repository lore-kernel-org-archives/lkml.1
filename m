Return-Path: <linux-kernel-owner+w=401wt.eu-S1754372AbYIFTE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372AbYIFTE5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 15:04:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752367AbYIFTEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 15:04:49 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:23313 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224AbYIFTEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 15:04:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=g2crZcVJywlw9yz6keK0n1uTj6rLROSwaIo2wGadvtTySWFSPmroECV46/6dUR/08k
         W9GonBpGrU4Hh8ZGpsBwAs/WMblaBFm4ceQNrQ2UuOv95ULtUOGEU92nZbASqXAr8dAq
         CsoLoUNdqJw/Gz99l5SbfgLgLjWcRaLYcxPbs=
Date: Sat, 6 Sep 2008 23:04:46 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Ingo Molnar <mingo@elte.hu>, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, yhlu.kernel@gmail.com
Subject: Re: [patch 3/3] x86: io-apic - code style cleaning for
	setup_IO_APIC_irqs
Message-ID: <20080906190446.GA23729@lenovo>
References: <20080904183748.950151853@gmail.com>> <48c02b6a.0637560a.15e9.ffffa39d@mx.google.com> <20080905080447.GC12409@elte.hu> <20080905180126.GA19334@lenovo> <20080905181111.GG27395@elte.hu> <20080905183347.GB19334@lenovo> <20080905183835.GA19215@elte.hu> <20080906101533.GA7273@lenovo> <Pine.LNX.4.55.0809061938250.13851@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.55.0809061938250.13851@cliff.in.clinika.pl>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Maciej W. Rozycki - Sat, Sep 06, 2008 at 07:45:08PM +0100]
| On Sat, 6 Sep 2008, Cyrill Gorcunov wrote:
| 
| > Ingo, how about the following approach? We don't introduce new
| > functions but rather srink the code by new printout form.
| 
|  Honestly, this one should probably use sprintf() or suchlike to avoid the
| mess of printk() calls building a line of output from pieces.  It's quite
| easy to calculate here what the maximum size of the buffer required could
| be and automatic arrays can have variable size, so no need for the hassle
| of heap management.  Calls to printk() without a trailing newline should
| be avoided where possible as it messes up logging priority if a message
| pops up from an interrupt inbetween.
| 
|   Maciej
| 

The easiest way would be just print this info on separate
lines like

	IO-APIC (apicid-pin) 1-1 not connected

and just drop all this troubles :)

I'm not sure how much memory we need for every io-apic
pins - iirc there only 32 redirection entry so it could
be about 32 bytes from stack would be enough. Will take
a look. Thanks Maciej! Ingo?

Btw, i think the problem is rather with (as Ingo mentoined)
too nesting cycles - so maybe we could use an iterator
for this? Maybe rcu based? As I see these global variables
are not supposed to be changed during iterations and if that
happens in future we could achieve rcu complains about it
and this prevent us for possible bug. Opinions? (just
a thoughts)

		- Cyrill -
