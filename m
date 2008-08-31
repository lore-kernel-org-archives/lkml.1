Return-Path: <linux-kernel-owner+w=401wt.eu-S1753881AbYHaPUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881AbYHaPUv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 11:20:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751450AbYHaPUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 11:20:41 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:48357 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319AbYHaPUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 11:20:40 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	b=NJOsbM+p4rrRL10fd5E6yth8KD70R+2Kn/9anq+h5/EkydK9gTDmzIVaXEH9pa4VIpJZNbS+XFLcyKSl63mNShQh6dlGmIGsE8nz0Ww5M6Lz5qMbqbnnw90gUWayz4ek;
Message-ID: <48BAB6C4.20007@simon.arlott.org.uk>
Date: Sun, 31 Aug 2008 16:20:36 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.16 (X11/20080726)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Matthew Wilcox <matthew@wil.cx>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 1/2] lib: add generic helper to print sizes rounded to
 the	correct SI range
References: <48B9546B.4010004@simon.arlott.org.uk>	 <1220117091.3615.3.camel@localhost.localdomain>	 <20080830174516.GD1239@parisc-linux.org>	 <48B9B552.8060406@simon.arlott.org.uk>	 <48B9B588.7060709@simon.arlott.org.uk>	 <1220147947.3615.18.camel@localhost.localdomain>	 <20080831025412.GJ1239@parisc-linux.org>	 <1220195310.4021.4.camel@localhost.localdomain> <1220195634.4021.9.camel@localhost.localdomain>
In-Reply-To: <1220195634.4021.9.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/08/08 16:13, James Bottomley wrote:
> This patch adds the ability to print sizes in either units of 10^3 (SI)
> or 2^10 (Binary) units.  It rounds up to three significant figures and
> can be used for either memory or storage capacities.

> +	const char *units_2[] = {"B", "Kib", "MiB", "GiB", "TiB", "PiB",

I think this should have been "KiB".
I'd prefer an option to display these without the "i"...

Oh and you need to store the original capacity before it's re-scaled to 
512 bytes. Outputting sdkp->capacity at that stage it'll be a count of 
512-byte sectors.

-- 
Simon Arlott
