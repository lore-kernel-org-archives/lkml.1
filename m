Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729Ab0BSULG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 15:11:06 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:51763 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751774Ab0BSULE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 15:11:04 -0500
Date: Fri, 19 Feb 2010 23:11:00 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: David Vrabel <david.vrabel@csr.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Richard =?utf-8?Q?R=C3=B6jfors?= 
	<richard.rojfors.ext@mocean-labs.com>,
       Pierre Ossman <pierre@ossman.eu>, Ben Dooks <ben@simtec.co.uk>,
       linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] sdhci: Implement CAP_CLOCK_BASE_BROKEN quirk
Message-ID: <20100219201100.GA17881@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20100219194827.GA16636@oksana.dev.rtsoft.ru>
 <4B7EECB2.9090406@csr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4B7EECB2.9090406@csr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 19, 2010 at 07:55:30PM +0000, David Vrabel wrote:
> Anton Vorontsov wrote:
> > Some hosts (e.g. as found in CNS3xxx SOCs) report wrong value in
> > CLOCK_BASE capability field, and currently there is no way to
> > force the SDHCI core to use the platform-provided base clock value.
> 
> I don't think this needs a new quirk. Change the sdhci driver to check
> if the platform provides a value before reading the standard register.

Well, Pierre once said that by default we should conform to the
SDHCI spec, and any diviations from the spec should be handled by
the quirks:

http://linux.derkeiler.com/Mailing-Lists/Kernel/2009-02/msg03385.html

Spec clearly states that base clock == 0 is the case when we should
fall back to the platform-provided clocks.

So, for controllers that conform to the spec, following might be
true:

- Platform provides its own (alternate) clock, but
- SDHCI block choose not to use it, and doesn't clear bits in the
  capability register
- Then the driver should not use the platform provided clock.

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
