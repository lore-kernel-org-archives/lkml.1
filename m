Return-Path: <linux-kernel-owner+w=401wt.eu-S1753466AbZF2DAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466AbZF2DAw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 23:00:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751936AbZF2DAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 23:00:44 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:29173 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbZF2DAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 23:00:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=kYWXaW5QNCY4dhZiYC6KdlUGeen+sRq1MdGwhwAdivEsHihoRMIBhrfy+XOP3nGjOg
         snwnOS2CB8RbE5CoL01T7pJdvmYkmNUEClXpQgj/kVQnqSuG/jA6VABdLP9x4gSNn6MS
         wzisF+q7sa9Vt0xpxqbCf4k2LiJRGdPaHIdu8=
Message-ID: <4A482E56.1070604@gmail.com>
Date: Mon, 29 Jun 2009 11:00:38 +0800
From: Eric Miao <eric.y.miao@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Daniel Ribeiro <drwyrm@gmail.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Pierre Ossman <pierre@ossman.eu>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       openezx-devel <openezx-devel@lists.openezx.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: [PATCH 1/2] MMC/pxamci: workaround regulator framework bugs
References: <1246057668.10360.316.camel@brutus>	 <20090627004814.GB4379@sirena.org.uk> <1246071323.10360.386.camel@brutus>
In-Reply-To: <1246071323.10360.386.camel@brutus>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Ribeiro wrote:
> Em Sáb, 2009-06-27 às 01:48 +0100, Mark Brown escreveu:
>>> +		/*
>>> +		 * When the bootloader leaves a supply active, it's
>>> +		 * initialized with zero usecount ... and we can't
>>> +		 * disable it without first enabling it.  Until the
>>> +		 * framework is fixed, we need a workaround like this
>>> +		 * (which is safe for MMC, but not in general).
>> This also needs to explain the actual situation, especially the
>> exclusivity reqirement of the MMC core.  It might be worth providing a
>> helper in the MMC core, everything is going to need to be updated to use
>> exclusive get whenever someone implements it.
> 
> Heh, this patch was copy-n-paste from twl code. I really can't put much
> time on this. :(
> 
>> As discussed at some length the regulator API is not going to be changed
>> in the way you demand.  This is not something that it should be easy for
>> standard consumers to do since for standard consumers it normally points
>> out a programming error.
> 
> Ok, so I will "fix it" hacking the bootloader to power off the voltage
> regulator before giving control to kernel. Lets hope that the next
> developer that tries to use the regulator framework with a mmc card and
> stumbles on the "regulator already enabled" case has more time to fix it
> properly. :)
> 

This looks to be running into the same issue as clocks - where for power
savings the clocks are assumed to be off as many as possible, leaving only
those essential ones enabled, yet the assumption of the boot loader does
this correctly is always a big problem, putting this into the kernel,
however, is ugly.
