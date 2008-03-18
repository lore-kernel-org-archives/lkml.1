Return-Path: <linux-kernel-owner+w=401wt.eu-S1752578AbYCRK7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578AbYCRK7v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 06:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751124AbYCRK7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 06:59:41 -0400
Received: from mx.bridgeco.net ([213.173.191.47]:3766 "EHLO
	mailgate57.bridgeco.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750876AbYCRK7l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 06:59:41 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: MMC: Card detection through pin CD/DAT3 issue
Date: Tue, 18 Mar 2008 11:59:25 +0100
Message-ID: <83116F0A4FF67A4F97BA0B6E408C48E301DAB4AA@zuerich.BC-Int.NET>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: MMC: Card detection through pin CD/DAT3 issue
Thread-Index: Ach0m4cSiApNdLdFScC3DSTHVH8H7w==
From: "Wappler Marcel" <Marcel.Wappler@bridgeco.net>
To: <linux-kernel@vger.kernel.org>
Cc: <drzeus-mmc@drzeus.cx>
X-OriginalArrivalTime: 18 Mar 2008 10:59:40.0315 (UTC) FILETIME=[29FA46B0:01C888E7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pierre, hi MMC developers,

I am at porting the generic PCI controller driver mmc/host/sdhci.c to a special non PCI direct memory mapped host. The hardware
vendor decided to implement the card detection not through the mechanical card present switch but through detecting the card
internal pull up at pin 1 (CD/DAT3).

With this detection scheme I have some dificulties togehter with the internal working of the current MMC stack:

The controller cannot detect a newly inserted card if the card power is switched of. This is due to the fact that the SD card
applies the internal card detection pull up after it powered up. If there is no power -> no powering up -> no pull up. (besides the
fact that a pull up needs power to for doing its work :-) )

My questions are:

1. knows anyone a host controller which uses the same card detection mechanism?

2. How could the driver manage the problem that the MMC stack switches off the card power if removed and therefor no state change on
line CD/DAT3 occurs at re-insertion of that card?

3. In a short look through some MMC card specs I did not find any description of some card detection mechanism. So I suppose the
mechanical switch is the only possible solution to detect a newly inserted card. Am I right or is there nevertheless a chance to
detect a inserted MMC together with this host?

Please CC me personaly and thanks a lot,
Marcel
--
Marcel Wappler
Bridgeco AG
CH-8600 Dübendorf
Switzerland
