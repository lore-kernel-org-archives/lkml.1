Return-Path: <linux-kernel-owner+w=401wt.eu-S1753818AbXLJCUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818AbXLJCUf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 21:20:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751634AbXLJCUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 21:20:25 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:8086 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbXLJCUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 21:20:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Jj3iaa3o72rXUA/RR96gK0ikbea+wyagnuzc6DPg9kV2P7ovB3prgFvK7gL3GLor3fArwOpGALVI6pLbbOAE18uggE39ZiFzEiJgnY2ofLanftNQ0e0kmxe9ugQNuM/y7cD9B/61MQGcBgTLmo4i6AdLdrAf2x6OAbzaqymffKc=
Message-ID: <475CA25F.5000103@gmail.com>
Date: Mon, 10 Dec 2007 11:20:15 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andreas Mohr <andi@lisas.de>
CC: Robert Hancock <hancockr@shaw.ca>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-ide@vger.kernel.org,
       Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org
Subject: Re: 2.6.24-rc4-git5: Reported regressions from 2.6.23
References: <fa.qQhD8aJpiTOFaZqjRYwoaG7YT1c@ifi.uio.no> <fa.yaP86AixGhz5Q7eXSu04pIQp6ho@ifi.uio.no> <fa.c3k8VKWAx4HIo9zXWbL5Ek0oSBw@ifi.uio.no> <fa.C8ACnOhs8bXB++vmugf5F34JcJg@ifi.uio.no> <fa.5o6E6S0UWnARbQPxLe30TvLQIiY@ifi.uio.no> <475AE150.9050306@shaw.ca> <20071209213642.GA27096@rhlx01.hs-esslingen.de> <20071210000429.GA3916@rhlx01.hs-esslingen.de> <20071210004959.GA23280@rhlx01.hs-esslingen.de>
In-Reply-To: <20071210004959.GA23280@rhlx01.hs-esslingen.de>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Mohr wrote:
> As such one can conclude that this BIOS is rather very confused when being called for _GTM on an entirely
> unused controller port. And this is either because the BIOS is dumb or because ACPI doesn't really
> expect anyone to call _GTM on an unused physical port. I'd bet on the latter...
> (however I haven't found ACPI 3.0b explicitly mentioning this somewhere yet)

Thanks a lot for finding this out.  One of the two reports in bug 9320
seems to be the same problem although the other doesn't seem to be.  So,
it seems we'll have to check that both primary and secondary slots are
empty and skip _GTM if so.  :-(

Also, right, there's no need to fail suspend on _GTM failure whatever
the error is.  That was me being anal again.  Will incorporate both into
the ACPI fixes patchset.

Thanks.

-- 
tejun
