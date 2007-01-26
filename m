Return-Path: <linux-kernel-owner+w=401wt.eu-S1161136AbXAZSkH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161136AbXAZSkH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 13:40:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161157AbXAZSkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 13:40:07 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:34793 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161136AbXAZSkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 13:40:05 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <45BA4AFA.1080106@s5r6.in-berlin.de>
Date: Fri, 26 Jan 2007 19:39:54 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.9) Gecko/20070121 SeaMonkey/1.0.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux1394-devel@lists.sourceforge.net, Robert Crocombe <rcrocomb@ieee.org>
Subject: Re: [RFT PATCH] ieee1394: ohci1394: serialize reset requests and
 irq handler
References: <tkrat.5ef766da36a4a03a@s5r6.in-berlin.de>
In-Reply-To: <tkrat.5ef766da36a4a03a@s5r6.in-berlin.de>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
>   - Use the ohci->event_lock to serialize the trigger for software-
>     enforced bus resets against a large portion of the IRQ handler.
...
> Todo:
>   - Test.
>   - Audit *all* of ohci1394's register accesses for the need of
>     serialization by spinlocks + mmiowb.
...

PS: AFAIU what I'm doing here, it affects

  - bus resets triggered by local software (the bug report was also
    about externally triggered bus resets),

  - and potentially bus resets (even externally triggered ones) on SMP
    systems with (PCI) bridges if the IRQ handler migrates to a another
    CPU between two interrupt events in quick succession.

Can the latter happen in Linux or/and with -rt kernels?
-- 
Stefan Richter
-=====-=-=== ---= ==-=-
http://arcgraph.de/sr/
