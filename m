Return-Path: <linux-kernel-owner+w=401wt.eu-S1161126AbXDYObe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161126AbXDYObe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 10:31:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030948AbXDYObe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 10:31:34 -0400
Received: from mx0.starentnetworks.com ([12.38.223.203]:59608 "EHLO
	mx0.starentnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030934AbXDYObd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 10:31:33 -0400
X-MessageTextProcessor: DisclaimIt (2.70.271) [Starent Networks Corp.]
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.1830
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: 2.6.20.7 mss negotiation and path mtu discovery mostly broken?
Date: Wed, 25 Apr 2007 10:31:23 -0400
Message-ID: <7CCD07160348804497EF29E9EA5560D7020F6206@exchtewks2.starentnetworks.com>
In-Reply-To: <p73k5w032wv.fsf@bingen.suse.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 2.6.20.7 mss negotiation and path mtu discovery mostly broken?
thread-index: AceHQ+ELOyqKHkl3Tha8tYZqHNNYTAAAE/iA
From: "Ristuccia, Brian" <bristuccia@starentnetworks.com>
To: "Andi Kleen" <andi@firstfloor.org>
Importance: normal
Cc: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
X-OriginalArrivalTime: 25 Apr 2007 14:31:24.0377 (UTC) FILETIME=[66B24C90:01C78746]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > 08:39:55.493029 IP 12.33.234.69.35026 > 10.2.10.254.22: S 
> > 2768979373:2768979373(
> > 0) win 5840 <mss 1460,sackOK,timestamp 3873837730 0,nop,wscale 2>
> > 08:39:55.493119 IP 10.2.10.254.22 > 12.33.234.69.35026: S
> > 963242385:963242385(0)
> >  ack 2768979374 win 17896 <mss 8960,sackOK,timestamp 413751
> 
> The MSS clamp for sending to 10.2.10.254.22 is 8960. MSS is 
> only one way -- each uses what the other tells it.
> 

Right - except that 10.2.10.254 keeps sending to 12.33.234.69 with an
increasingly large MSS, even though 12.33.234.69 has asked for no larger
than 1460.

> > In the following dump, the system eventually gets in a 
> state where it 
> > oscillates between sendng undeliverable 2896 byte packets and 
> > deliverable 1448 byte ones.
> 
> This should only happen on PMTU expire, which is normally ~15mins.
> Perhaps you misconfigured it manually using sysctl.
> 

This is /proc/sys/net/ipv4/route/mtu_expires? It's 600.

-- 
Brian Ristuccia


"This email message and any attachments are confidential information of Starent Networks, Corp. The information transmitted may not be used to create or change any contractual obligations of Starent Networks, Corp.  Any review, retransmission, dissemination or other use of, or taking of any action in reliance upon this e-mail and its attachments by persons or entities other than the intended recipient is prohibited. If you are not the intended recipient, please notify the sender immediately -- by replying to this message or by sending an email to postmaster@starentnetworks.com -- and destroy all copies of this message and any attachments without reading or disclosing their contents. Thank you."
