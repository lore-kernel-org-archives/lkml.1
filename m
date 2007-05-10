Return-Path: <linux-kernel-owner+w=401wt.eu-S1759269AbXEJO5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759269AbXEJO5J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 10:57:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752330AbXEJO46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 10:56:58 -0400
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:37931 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbXEJO45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 10:56:57 -0400
Message-ID: <4643327A.4090906@s5r6.in-berlin.de>
Date: Thu, 10 May 2007 16:55:54 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.2) Gecko/20070222 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Phillip Susi <psusi@cfl.rr.com>
CC: david@lang.hm, Linus Torvalds <torvalds@linux-foundation.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, Adrian Bunk <bunk@stusta.de>,
       Greg K-H <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Please revert 5adc55da4a7758021bcc374904b0f8b076508a11 (PCI_MULTITHREAD_PROBE)
References: <20070508153713.344cc881@gondolin.boeblingen.de.ibm.com> <20070508141149.GJ4226@stusta.de> <alpine.LFD.0.98.0705080819350.3974@woody.linux-foundation.org> <20070508183846.28a94797@gondolin.boeblingen.de.ibm.com> <alpine.LFD.0.98.0705081123080.3974@woody. <46424D44.2040003@s5r6.in-berlin.de> <46432AF8.9050505@cfl.rr.com>
In-Reply-To: <46432AF8.9050505@cfl.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Phillip Susi wrote:
> Stefan Richter wrote:
>> The SCSI stack already has infrastructure for multi-threaded discovery
>> and probing.
> 
> So?  It would still benefit from using a generic framework that other 
> buses can use as well.

Perhaps, perhaps not.  Many details of the If and How of asynchronous,
parallelized probing rest with the low-level drivers.

[BTW, which ever team attempts to design this generic framework please
brings in detailed knowledge of a variety of bus architectures.  I for
one would like to contribute with what I know about IEEE 1394, but
before that I still have to experiment on my own before I have a good
understanding of how to parallelize IEEE 1394 scanning and probing, and
the IEEE 1394 core is being radically reworked at the moment anyway.]

> Not to mention that the current scsi specific 
> framework tends to cause unstable names doesn't it?

No.  Reality causes "unstable" names.  Or more precisely, we ultimately
can't get persistent names from dumb enumerations according to probing
order.  We get persistent names by reading persistent device properties
in userspace and by letting userspace rename or give aliases to devices.

Names based on probing order are fine for really simplistic setups like
the famous Aunt Tilly's home computer --- but not for the general case
that you are trying to cover.

(Sorry for repeating what has been said before in this thread.)
-- 
Stefan Richter
-=====-=-=== -=-= -=-=-
http://arcgraph.de/sr/
