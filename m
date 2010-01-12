Return-Path: <linux-kernel-owner+w=401wt.eu-S1754714Ab0ALTCI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714Ab0ALTCI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 14:02:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754645Ab0ALTCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 14:02:06 -0500
Received: from server109h.appriver.com ([72.32.253.92]:4285 "EHLO
	server109.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754597Ab0ALTCF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 14:02:05 -0500
X-Policy: GLOBAL - intcomgrp.com
X-Policy: GLOBAL - intcomgrp.com
X-Primary: jkosin@intcomgrp.com
X-Note: This Email was scanned by AppRiver SecureTide
X-ALLOW: JKosin@intcomgrp.com ALLOWED
X-Virus-Scan: V-
X-Note: Spam Tests Failed: 
X-Country-Path: UNITED STATES->UNITED STATES
X-Note-Sending-IP: 216.54.13.100
X-Note-Reverse-DNS: mail.intcomgrp.com
X-Note-WHTLIST: JKosin@intcomgrp.com
X-Note: User Rule Hits: 
X-Note: Global Rule Hits: G113 G114 G115 G116 G120 G121 G132 G219 
X-Note: Encrypt Rule Hits: 
X-Note: Mail Class: ALLOWEDSENDER
X-Note: Headers Injected
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: arm: Optimization for ethernet MAC handling at91_ether.c
Date: Tue, 12 Jan 2010 14:03:46 -0500
Message-ID: <3DBBD805E3BA064A87F551C0E8BD36740289741C@MAILSRV.intcomgrp.com>
In-Reply-To: <3DBBD805E3BA064A87F551C0E8BD367402897418@MAILSRV.intcomgrp.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: arm: Optimization for ethernet MAC handling at91_ether.c
Thread-Index: AcqTspWCmnn7FjRuR3SQzPFeTMxe6wAANsBQAAGbhMA=
References: <3DBBD805E3BA064A87F551C0E8BD3674028973F5@MAILSRV.intcomgrp.com> <4B4CA4E5.7030800@gmail.com> <3DBBD805E3BA064A87F551C0E8BD36740289740E@MAILSRV.intcomgrp.com> <4B4CBA93.4090909@gmail.com> <3DBBD805E3BA064A87F551C0E8BD367402897418@MAILSRV.intcomgrp.com>
From: "James Kosin" <JKosin@intcomgrp.com>
To: "James Kosin" <JKosin@intcomgrp.com>,
       "Eric Dumazet" <eric.dumazet@gmail.com>
Cc: <linux-kernel@vger.kernel.org>,
       "Linux Netdev List" <netdev@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/12/2010 1:50 PM, James Kosin wrote:
> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Eric Dumazet
> Sent: Tuesday, January 12, 2010 1:08 PM
> To: James Kosin
> Cc: linux-kernel@vger.kernel.org; Linux Netdev List
> Subject: Re: arm: Optimization for ethernet MAC handling at91_ether.c
> 
> Le 12/01/2010 18:51, James Kosin a écrit :
>> On 1/12/2010 11:40 AM, Eric Dumazet wrote:
> 
> 
> I know.  Actually, I am using the hardware; and the part is capable of more than this driver is displaying.
> 
> 1)  The part is able to queue up two packets (1) actively being transmitted, and (1) queued up behind that packet.  The driver doesn't exploit this; probably because this would cause some confusion, since we wouldn't really know which packet failed when this happens.
> 
> 2)  TX performance is so..so.  With bing on another computer using '-z' option it is reporting a fairly good value of 74Mbps.  I'll have to try with a re-compiled kernel at some point to give better feedback if we can improve this more.
> 
> Your interpretation makes some sense on the transmit side.  The RX currently has a DMA queue that extends to a depth of 9 (currently).  So getting one transmit out before checking the RX may improve things a bit.
> 

Scratch that.  The interrupt doesn't queue up or send another packet directly.  So, it wouldn't help on performance here.  But, may in other implementations that queue/transmit packets in the ISR.  At least in the case where the transmitter is limited to one.

James
