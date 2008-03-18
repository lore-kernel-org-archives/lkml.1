Return-Path: <linux-kernel-owner+w=401wt.eu-S1753549AbYCRMYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549AbYCRMYs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 08:24:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752242AbYCRMYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 08:24:41 -0400
Received: from mx.bridgeco.net ([213.173.191.47]:1351 "EHLO
	mailgate57.bridgeco.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752061AbYCRMYk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 08:24:40 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: MMC: Card detection through pin CD/DAT3 issue
Date: Tue, 18 Mar 2008 13:24:33 +0100
Message-ID: <83116F0A4FF67A4F97BA0B6E408C48E301DAB4DF@zuerich.BC-Int.NET>
In-Reply-To: <20080318122033.020b45b5@mjolnir.drzeus.cx>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: MMC: Card detection through pin CD/DAT3 issue
Thread-Index: AciI6jPX7I/PkEJmSoy49MsreeApSgAB7Mvw
References: <83116F0A4FF67A4F97BA0B6E408C48E301DAB4AA@zuerich.BC-Int.NET> <20080318122033.020b45b5@mjolnir.drzeus.cx>
From: "Wappler Marcel" <Marcel.Wappler@bridgeco.net>
To: "Pierre Ossman" <drzeus-mmc@drzeus.cx>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 18 Mar 2008 12:24:39.0862 (UTC) FILETIME=[098B6560:01C888F3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pierre,

>> With this detection scheme I have some dificulties togehter
>> with the internal working of the current MMC stack:
>> The controller cannot detect a newly inserted card if the card power 
>> is switched of. This is due to the fact that the SD card applies the 
>> internal card detection pull up after it powered up. If there is no 
>> power -> no powering up -> no pull up. (besides the fact that a pull 
>> up needs power to for doing its work :-) )
>> 

> Then you have broken hardware. The specs clearly state that the 
> controller must be able to detect cards without powering up the
> cards. Also, the cards must implement the pull-up in a way that
> behaves like a resistor. So there should be no requirement for 
> full power there either.

I have found this requirement in the SD host controller spec:
"The card detect is active regardless of the SD Bus Power."

I wonder how the card should be able to pull up the CD/DAT3 Pad to VCC
if its only VCC pad is not connected to VCC due to the fact that the host
controller has switched off the cards power - any idea how this could be
managed?

There is a SD card spec section somewhere which statet that:
"If one of the supply pins (VDD or VSS) is not connected properly, then
the current is drawn through a data line to supply the card."

Maybe this is the key in understanding ho the pull up without VCC connected
works?

Thanks,
marcel
