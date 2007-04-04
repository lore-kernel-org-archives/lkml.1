Return-Path: <linux-kernel-owner+w=401wt.eu-S1753566AbXDDQWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566AbXDDQWl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 12:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753573AbXDDQWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 12:22:40 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:52727 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753568AbXDDQWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 12:22:40 -0400
Date: Wed, 4 Apr 2007 11:22:34 -0500
To: Brad Boyer <flar@allandria.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
Message-ID: <20070404162234.GS4922@austin.ibm.com>
References: <1175610345.2665.15.camel@shinybook.infradead.org> <17938.57292.870224.132415@cargo.ozlabs.ibm.com> <1175642916.10567.24.camel@shinybook.infradead.org> <20070403212928.GA12951@cynthia.pants.nu> <1175644642.10567.31.camel@shinybook.infradead.org> <20070403221002.GA13210@cynthia.pants.nu> <1175648051.10567.61.camel@shinybook.infradead.org> <20070403230908.GA13471@cynthia.pants.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070403230908.GA13471@cynthia.pants.nu>
User-Agent: Mutt/1.5.11
From: linas@austin.ibm.com (Linas Vepstas)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2007 at 04:09:08PM -0700, Brad Boyer wrote:
> The issue is that the naming should be consistent. I
> shouldn't need to know what the hardware is to use what is fundamentally
> an abstraction of "serial port" as far as the user is concerned. On
> Solaris, I can say "/dev/term/a" and know that I will get the first
> serial port if it is available without needing to care if it is the
> zs, se or asy driver talking to the hardware.

I presume that a correctly structured set of rules for udev should
accomplish the same thing; when udev runs, it could create links to
/dev/serial0 or /dev/serial/0 etc. as you wish. Applications
"should" use the udev-created links, not the raw, underlying device
nodes.

The biggest problem would seem to be that the assignment would
depend on the detection order; there don't seem to be unique 
id's that would help udev consistently assign device names in 
consistent order.

--linas
