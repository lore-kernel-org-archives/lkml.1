Return-Path: <linux-kernel-owner+w=401wt.eu-S1761474AbZLPAg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761474AbZLPAg6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 19:36:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761450AbZLPAgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 19:36:53 -0500
Received: from hera.kernel.org ([140.211.167.34]:44870 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761447AbZLPAgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 19:36:52 -0500
Message-ID: <4B282C2A.4050801@kernel.org>
Date: Wed, 16 Dec 2009 09:39:06 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: SATA_SIL: Add a work-around for IXP4xx CPU.
References: <m3fx8m0vwh.fsf@intrepid.localdomain>	<4B274694.6020701@kernel.org> <m3hbrrc013.fsf@intrepid.localdomain>
In-Reply-To: <m3hbrrc013.fsf@intrepid.localdomain>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/16/2009 08:03 AM, Krzysztof Halasa wrote:
> Tejun Heo <tj@kernel.org> writes:
> 
>> Hmmm... Given that there are some platforms which have problem with
>> mmio and sil3112/4 can do everything via io accesses, it would be nice
>> to generalize this so that there's CONFIG_SATA_SIL_NO_MMIO which is
>> selected by affected platforms.  Are you interested in doing it?
> 
> Unfortunately I no longer have access to that SIL3512 miniPCI card so
> I wouln't be able to test on IXP425. Perhaps it's not a problem, testing
> on i386 (probably with disabled MMIO BAR) should be enough.
> 
> OTOH IIRC SIL3x12 needs to use the MMIO write to start BM DMA, otherwise
> the AT-style 64 KB limits apply. I think IXP4xx would benefit from only
> ioread8() going through normal IO.
> 
> Do you know what platforms have the MMIO problems? What kind of problems
> are there, inability to use MMIO at all? (IXP4xx can't do 8/16-bit MMIO
> reads).

I don't remember exactly but similar subjects have come up multiple
times on the mailing list and elsewhere.  ISTR a case where MMIO was
completely unavailable but I could be mistaken.  At any rate, the most
common problem seems to be smaller MMIO accesses, so generalizing your
previous patch just a bit would help a lot.
ie. CONFIG_SATA_SIL_ONLY_32BIT_MMIO which is selected by platform.

Thanks.

-- 
tejun
