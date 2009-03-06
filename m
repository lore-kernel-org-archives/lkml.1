Return-Path: <linux-kernel-owner+w=401wt.eu-S1754813AbZCFJ55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813AbZCFJ55 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 04:57:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753571AbZCFJ5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 04:57:48 -0500
Received: from gate.crashing.org ([63.228.1.57]:49271 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751074AbZCFJ5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 04:57:47 -0500
Subject: Re: commit "radeonfb: Fix resume from D3Cold on some platforms"
 breaks resume from RAM on PowerBook
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Gaudenz Steinlin <gaudenz@soziologie.ch>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090306090906.GA5183@soziologie.ch>
References: <20090304083859.GB6889@soziologie.ch>
	 <1236219920.7260.6.camel@pasglop> <20090305125919.GA5474@soziologie.ch>
	 <1236318629.7260.120.camel@pasglop>  <20090306090906.GA5183@soziologie.ch>
Content-Type: text/plain
Date: Fri, 06 Mar 2009 20:57:20 +1100
Message-Id: <1236333440.7260.136.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> So you are able to resume with my minimal config + CPU_FREQ? This would
> be really strange if it is really the exact same model.

Yes, it appears to be :-)

> To verify if we really have the same model I included some data below. I
> also included the gcc and binutils versions.
> 
> Please tell me if you have any further ideas on what to test.

In the commmit your revert, I added a function that "tests" if the chip
appears to need to be POSTed: radeon_check_power_loss(). Try commenting
out the content and make it always return 1.

Another thing you can try in radeonfb_pci_resume():

        if (pdev->dev.power.power_state.event == PM_EVENT_SUSPEND) {
+		pci_restore_state(pdev);
+		pci_enable_device(pdev);
+		pci_set_master(pdev);
                /* Wakeup chip */

And if that helps, then try to find out which of these 3 things helped.

Cheers,
Ben.


