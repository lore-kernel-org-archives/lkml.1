Return-Path: <linux-kernel-owner+w=401wt.eu-S1754629AbYCTH1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629AbYCTH1h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 03:27:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752625AbYCTH10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 03:27:26 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:62019 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbYCTH1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 03:27:25 -0400
Date: Thu, 20 Mar 2008 08:27:13 +0100 (CET)
From: Bodo Eggert <7eggert@gmx.de>
To: Wappler Marcel <Marcel.Wappler@bridgeco.net>
cc: 7eggert@gmx.de, Pierre Ossman <drzeus-mmc@drzeus.cx>,
       linux-kernel@vger.kernel.org
Subject: RE: MMC: Card detection through pin CD/DAT3 issue
In-Reply-To: <83116F0A4FF67A4F97BA0B6E408C48E301DAB652@zuerich.BC-Int.NET>
Message-ID: <alpine.LSU.0.999.0803200812510.2582@be1.lrz>
References: <a8HRS-1KI-17@gated-at.bofh.it> <a8Ibj-2w0-17@gated-at.bofh.it>
 <a8J7c-4QO-1@gated-at.bofh.it> <E1Jbkv6-0003xh-IA@be1.7eggert.dyndns.org>
 <83116F0A4FF67A4F97BA0B6E408C48E301DAB652@zuerich.BC-Int.NET>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX19TeSWAb8tRVoTEVi6MKywmoslPzjzv5fhCvMr
 JCyg0UQ7N8KMEyu7R8aXfRyL65tyWdoS+gadciXmLkTGH/l8fm
 kjwbX3wJWYiEeVJst0icA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Mar 2008, Wappler Marcel wrote:
> Bodo Eggert wrote:

> >> I have found this requirement in the SD host controller spec:
> >> "The card detect is active regardless of the SD Bus Power."
> >> 
> >> I wonder how the card should be able to pull up the CD/DAT3 Pad to
> >> VCC if its only VCC pad is not connected to VCC due to the fact that
> >> the host controller has switched off the cards power - any idea how
> >> this could be managed?
>  
> > If the VCC pin is connected to 0 V, the "pullup" will pull 
> > down to 0V. 
> > If the controller reverses it's logic while VCC=0, it might work.
> 
> I am concerned  that in this case there would be neither a pull 
> up nor a pull down at this signal. Due to floating gates that input
> could lead to millions of "card detection" events a second, if

As long as no card is inserted, the pin on the controller would be floating 
and generating the same amount of interrupts, unless there is a (weak)
internal pulldown. You can do the same for the reversed logic, using
an internal pullup and abusing the card's pullup as a pulldown.

-- 
Never forget that your weapon is made by the lowest bidder.
