Return-Path: <linux-kernel-owner+w=401wt.eu-S1756745AbYIYR2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745AbYIYR2y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 13:28:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753198AbYIYR2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 13:28:46 -0400
Received: from twin.jikos.cz ([213.151.79.26]:58722 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752380AbYIYR2p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 13:28:45 -0400
Date: Thu, 25 Sep 2008 19:24:57 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Frans Pop <elendil@planet.nl>
cc: Jiri Kosina <jkosina@suse.cz>, airlied@gmail.com,
       Jeff Garzik <jeff@garzik.org>, davem@davemloft.net,
       Andrew Morton <akpm@linux-foundation.org>, jeffrey.t.kirsher@intel.com,
       david.vrabel@csr.com, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, chrisl@vmware.com,
       Ingo Molnar <mingo@elte.hu>, jbarnes@virtuousgeek.org,
       jesse.brandeburg@gmail.com
Subject: Re: [Bug #11382] e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
In-Reply-To: <200809250401.54818.elendil@planet.nl>
Message-ID: <Pine.LNX.4.64.0809251921340.18801@twin.jikos.cz>
References: <20080923.150722.141587696.davem@davemloft.net>
 <9929d2390809231512w160d221axa2923a6b293a041@mail.gmail.com>
 <alpine.LNX.1.10.0809240014390.4671@pegasus.suse.cz>
 <20080923.211215.193696086.davem@davemloft.net> <alpine.LNX.1.10.0809250110070.4671@pegasus.suse.cz>
 <21d7e9970809241722w7c3bb6a5w1af5801b7380169d@mail.gmail.com>
 <21d7e9970809241722w7c3bb6a5w1af5801b7380169d@mail.gmail.com>
 <alpine.LNX.1.10.0809250310190.4671@pegasus.suse.cz> <200809250401.54818.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Sep 2008, Frans Pop wrote:

> Extra datapoint. As far as I've seen this problem has not yet been 
> reported by any people running Debian. This could point to X.Org as 
> Debian currently has 7.3 while I think the reports so far have been with 
> 7.4.

Yes, I think that xorg/xorg i915 driver/libdrm/GEM/whatever are the 
biggest suspect currently, according to the data that has been gathered so 
far.

Still, what confuses me a little bit -- the EEPROM of the card is set to 
all 0xff, once the corruption happens. Isn't that a quite a coincidence, 
that bytes representing "nothing" in this context are used?

If being set to 0 (it's so easy to call memset(0) on a bogus pointer, 
there are usually lots of them in the code) or to random garbage, it would 
seem to be much more understandable, than 0xff.

-- 
Jiri Kosina
SUSE Labs

