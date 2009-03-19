Return-Path: <linux-kernel-owner+w=401wt.eu-S1755063AbZCSWlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063AbZCSWlh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 18:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752452AbZCSWl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 18:41:27 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:46693 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751908AbZCSWl1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 18:41:27 -0400
From: Bela Lubkin <blubkin@vmware.com>
To: "'Martin Wilck'" <martin.wilck@fujitsu-siemens.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Corey Minyard <minyard@acm.org>,
       "openipmi-developer@lists.sourceforge.net" 
	<openipmi-developer@lists.sourceforge.net>
Date: Thu, 19 Mar 2009 15:41:23 -0700
Subject: RE: [Openipmi-developer] [PATCH] limit CPU time spent in kipmid
Thread-Topic: [Openipmi-developer] [PATCH] limit CPU time spent in kipmid
Thread-Index: AcmosSOdBlPQ6rjiQb2+mxp4DzWydQAMWVgQ
Message-ID: <7A7D327E99D30143AC98BDABFCABFF0122711630C3@PA-EXMBX04.vmware.com>
References: <49C27281.4040207@fujitsu-siemens.com>
In-Reply-To: <49C27281.4040207@fujitsu-siemens.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'll give this a try, we've certainly had plenty of Fun with the
cost of running kipmid...

Why O Why are essentially all modern "managed" machines designed
with KCS?  Even when you bless it with an identifiable interrupt
(as HP have done), it still cannot perform anywhere near as well
as BT, with its whole-packet DMA transfers.

I've been assuming that some silicon designer put out a KCS chip
early in the game and ramped production up to the point where it
was practically free, while other protocols were still tacking a
few cents onto the cost of every box.  Thus, millions of hobbled
"server" computers.  Grumble snort.

>Bela<

> -----Original Message-----
> From: Martin Wilck [mailto:martin.wilck@fujitsu-siemens.com] 
> Sent: Thursday, March 19, 2009 9:28 AM
> To: linux-kernel@vger.kernel.org; Corey Minyard; 
> openipmi-developer@lists.sourceforge.net
> Subject: [Openipmi-developer] [PATCH] limit CPU time spent in kipmid
> 
> Hello Corey, hi everyone,
> 
> here is a patch that limits the CPU time spent in kipmid. I 
> know that it 
> was previously stated that current kipmid "works as designed" (e.g. 
> http://lists.us.dell.com/pipermail/linux-poweredge/2008-Octobe
r/037636.html), 
> yet users are irritated by the high amount of CPU time kipmid 
> may use up 
> on current servers with many sensors, even though it is 
> "nice" CPU time. 
> Moreover, kipmid busy-waiting for the KCS interface to become 
> ready also 
> prevents CPUs from sleeping.
> 
> The attached patch was developed and tested on an enterprise 
> distribution kernel where it caused the CPU load of kipmid to drop to 
> essentially 0 while still delivering reliable IPMI communication.
> 
> I am looking forward for comments.
> Martin
> 
> -- 
> Martin Wilck
> PRIMERGY System Software Engineer
> FSC IP ESP DEV 6
> 
> Fujitsu Siemens Computers GmbH
> Heinz-Nixdorf-Ring 1
> 33106 Paderborn
> Germany
> 
> Tel:			++49 5251 525 2796
> Fax:			++49 5251 525 2820
> Email:			mailto:martin.wilck@fujitsu-siemens.com
> Internet:		http://www.fujitsu-siemens.com
> Company Details:	http://www.fujitsu-siemens.com/imprint.html
> 