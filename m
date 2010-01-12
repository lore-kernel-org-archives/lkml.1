Return-Path: <linux-kernel-owner+w=401wt.eu-S1754117Ab0ALRuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117Ab0ALRuQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 12:50:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753490Ab0ALRuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 12:50:14 -0500
Received: from server109d.appriver.com ([72.32.253.88]:4687 "EHLO
	server109.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751245Ab0ALRuN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 12:50:13 -0500
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
Date: Tue, 12 Jan 2010 12:51:57 -0500
Message-ID: <3DBBD805E3BA064A87F551C0E8BD36740289740E@MAILSRV.intcomgrp.com>
In-Reply-To: <4B4CA4E5.7030800@gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: arm: Optimization for ethernet MAC handling at91_ether.c
Thread-Index: AcqTpccT6JloKcvaRgCp8cngcWImUgACf3JA
References: <3DBBD805E3BA064A87F551C0E8BD3674028973F5@MAILSRV.intcomgrp.com> <4B4CA4E5.7030800@gmail.com>
From: "James Kosin" <JKosin@intcomgrp.com>
To: "Eric Dumazet" <eric.dumazet@gmail.com>
Cc: <linux-kernel@vger.kernel.org>,
       "Linux Netdev List" <netdev@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/12/2010 11:40 AM, Eric Dumazet wrote:
> CC to netdev
> 
> Le 12/01/2010 16:39, James Kosin a écrit :
>> Everyone,
>>
>> Since, a AT91_EMAC_TUND only happens when the transmitter is unable to
>> transfer the frame in time for a frame to be sent.  It makes sense to
>> RETRY the packet in this condition in the ISR.
>> Or would this overcomplicate a simple task?
>>                 ... see below ...
>>
> ...
> 
>>
>> ...
>> I do know there needs to be a bit more code then to handle the
>> successful case below this; but, this is enough to understand what I am
>> talking about.  The UNDERRUN error should happen infrequently and in
>> ideal circumstances not happen at all.
>>  
> 
> 
> If this happens once in a while, why do you want driver to retry the transmit ?

(a)  It would improve performance by allowing the ISR to handle the re-transmit in this case.
(b)  It would help in the case of small glitches that may happen from external SDRAM without taxing the polling required to handle the re-transmit of the packet... ie: overhead required to re-queue and initiate a packet delivery... since the packet is already scheduled for delivery now.

James
