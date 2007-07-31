Return-Path: <linux-kernel-owner+w=401wt.eu-S933131AbXGaSDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933131AbXGaSDX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 14:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762510AbXGaSDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 14:03:07 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:24562 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755219AbXGaSDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 14:03:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=jX2M9PPvlFPofvquRLVmiV/9OgVTON65q1xhdcJ5J1zCzza2Vpx+OEfPSceiqIeOBKdJGhEpdQf1eE4LLSWMJgtH1q1QCLDYiiczAkK4CHfh6WEK28ZJP5fTm0BbowiXSRO6Ebt+vGXbeweyBF2o0XRpCHnI6XCXmDDaOc5xQVg=
Message-ID: <46AF794F.1020107@gmail.com>
Date: Wed, 01 Aug 2007 03:02:55 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
CC: Jeff Garzik <jeff@garzik.org>, James.Bottomley@steeleye.com,
       linux-scsi@vger.kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       edwintorok@gmail.com, axboe@kernel.dk
Subject: Re: [patch 2/4] Expose Power Management Policy option to users
References: <20070705194909.337398431@intel.com>	<20070705130518.135e4e3c.kristen.c.accardi@intel.com>	<46AE12B6.6090408@garzik.org>	<46AED656.8070407@gmail.com> <20070731093014.db9e0734.kristen.c.accardi@intel.com>
In-Reply-To: <20070731093014.db9e0734.kristen.c.accardi@intel.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kristen Carlson Accardi wrote:
> I think what you are saying is that you'd like a way to use your HIPM
> and DIPM without ALPM on the AHCI driver.  Fine - it's really easy
> to add these levels later - if they don't make sense at the sysfs interface
> we can add module params to specify the definition of "min_power" as 
> being performed via HIPM and DIPM instead of ALPM - although as of yet we
> have no evidence what so ever that this method actually adds value over
> ALPM.

I don't really care whose PS implementation goes in.  Believe me.  I try
to stay away from that.  I don't even like my previous implementation.

ALPM has unnecessary performance penalty && is not applicable to
non-ahci controller.  Have you tested ALPM on non-intel ahcis?  There
are a lot out there these days.

I don't think the interface you're suggesting is a good one.  Do you?

>> Also, I generally don't think AHCI ALPM is a good idea.  It doesn't have
>> 'cool down' period before entering PS state which unnecessarily hampers
>> performance and might increase chance of device malfunction.
> 
> "might increase"?  How about some actual examples of where you've shown
> this to be a problem?

I wouldn't have used "might" if I had actual examples.  Well, feel free
to disregard anything following the "might".  I just feel uneasy about
jumping back and forth between PS and active states between consecutive
commands.

> I can assert that I think ALPM is a good idea,
> because I've never had a report of it causing problems.  Windows has 
> been using this feature for a very long time - and you have to admit that
> they have a pretty large market share.  Nobody is complaining about ALPM
> increasing device malfunction, so unless you have proof it seems insane
> to nak due to this. 

Is ALPM enabled by default?  How do they deal with the performance
degradation?

-- 
tejun
