Return-Path: <linux-kernel-owner+w=401wt.eu-S935216AbYCSUvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935216AbYCSUvq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758725AbYCSTqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:46:35 -0400
Received: from mx.bridgeco.net ([213.173.191.47]:3825 "EHLO
	mailgate57.bridgeco.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758722AbYCSTqe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:46:34 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: MMC: Card detection through pin CD/DAT3 issue
Date: Wed, 19 Mar 2008 09:41:14 +0100
Message-ID: <83116F0A4FF67A4F97BA0B6E408C48E301DAB652@zuerich.BC-Int.NET>
In-Reply-To: <E1Jbkv6-0003xh-IA@be1.7eggert.dyndns.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: MMC: Card detection through pin CD/DAT3 issue
Thread-Index: AciJTQq0LQgFVB+xTUOgd//adQ2lkQATGNog
References: <a8HRS-1KI-17@gated-at.bofh.it> <a8Ibj-2w0-17@gated-at.bofh.it> <a8J7c-4QO-1@gated-at.bofh.it> <E1Jbkv6-0003xh-IA@be1.7eggert.dyndns.org>
From: "Wappler Marcel" <Marcel.Wappler@bridgeco.net>
To: <7eggert@gmx.de>, "Pierre Ossman" <drzeus-mmc@drzeus.cx>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 19 Mar 2008 08:42:21.0049 (UTC) FILETIME=[2567CE90:01C8899D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you, Pierre,

this special host controller is more an SDHCI _inspired_ than a
_compliant_ one. Not only powering off the card bus led to the not
working card detection but also the RESET_ALL function. Both
tasks are reqired by the SDHCI standard after removing the card.
But Pierre has prepared the sdhci.c very well: there is a quirk
called "SSM_QUIRK_NO_CARD_NO_RESET". In combination with disabling
power off after a card removal now it works.

Bodo Eggert wrote:
>> I have found this requirement in the SD host controller spec:
>> "The card detect is active regardless of the SD Bus Power."
>> 
>> I wonder how the card should be able to pull up the CD/DAT3 Pad to
>> VCC if its only VCC pad is not connected to VCC due to the fact that
>> the host controller has switched off the cards power - any idea how
>> this could be managed?
 
> If the VCC pin is connected to 0 V, the "pullup" will pull 
> down to 0V. 
> If the controller reverses it's logic while VCC=0, it might work.

I am concerned  that in this case there would be neither a pull 
up nor a pull down at this signal. Due to floating gates that input
could lead to millions of "card detection" events a second, if
no card is inserted?


Regards,
Marcel

Marcel Wappler
Bridgeco AG
CH-8600 Dübendorf
Switzerland
