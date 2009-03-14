Return-Path: <linux-kernel-owner+w=401wt.eu-S1754520AbZCNEFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520AbZCNEFm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 00:05:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751487AbZCNEFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 00:05:08 -0400
Received: from kroah.org ([198.145.64.141]:50940 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751049AbZCNEFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 00:05:07 -0400
Date: Fri, 13 Mar 2009 21:03:22 -0700
From: Greg KH <greg@kroah.com>
To: Ralf Nyren <ralf@nyren.net>
Cc: linux-kernel@vger.kernel.org, klloyd@sierrawireless.com
Subject: Re: Sierra Wireless (MC8780) HSDPA speed issue
Message-ID: <20090314040322.GB3417@kroah.com>
References: <alpine.DEB.1.10.0903131551310.5791@fujje.iml.umu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0903131551310.5791@fujje.iml.umu.se>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 13, 2009 at 04:01:19PM +0100, Ralf Nyren wrote:
> Hi,
> 
> I have a Sierra Wireless MC8780 UMTS card in a Fujitsu S6410 laptop running
> kernel 2.6.28.7. In kernel sierra driver v1.3.2.
> 
> The card works but speed seems limited to approx 1.0 Mbit/s download using the
> linux driver.  Testing the card in Windows XP yields download speeds close to
> 5.0 Mbit/s.
> 
> I recently updated the firmware of the card to support HSDPA/HSUPA. The update
> gave the desired result in Windows but not in Linux. The speed improved in
> Linux but didn't increase above 1 Mbit/s.
> 
> Is there any known driver limitations or is this a configuration issue?
> 
> Please let me know if you need any additional information.

Are you testing up or down speeds?

If you want to, and you think the driver is the problem, try changing
the values in drivers/usb/serial/sierra.c:
	/* per port private data */
	#define N_IN_URB        4
	#define N_OUT_URB       4
	#define IN_BUFLEN       4096

Try bumping up the N_IN_URB and N_OUT_URB values a bunch and let me know
if things go faster now.

thanks,

greg k-h
