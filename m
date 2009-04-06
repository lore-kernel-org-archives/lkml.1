Return-Path: <linux-kernel-owner+w=401wt.eu-S1753931AbZDFXa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931AbZDFXa7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 19:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750847AbZDFXau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 19:30:50 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:38520 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696AbZDFXat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 19:30:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=qXRRX86/1h5Opx+JUxDRkKlLPsXhYj6viy37t8ixvckSoepDd5ouan5XZkrbAgxgtE
         FtLHu/L0Xn6qRhr/cykDUOh400KicPBnqyftJcIlYF1qZs0QXsnve4VC3ti6BR0dFnPl
         brM2m4kA5Ym+uMVkORY7zYi5hwbsCaJBvwTQs=
Message-ID: <49DA9094.1070803@gmail.com>
Date: Tue, 07 Apr 2009 01:30:28 +0200
From: =?UTF-8?B?Sm9zw6kgTWFyw63CrWEgRmVybsOhbmRleiBHb256w6FsZXo=?= 
	<josemariafg@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090323)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mmc: Some microSD cards are not recognized by PCIxx12
 SDA controller
References: <49B5C091.3090303@gmail.com>	<20090324211748.30cd7429@mjolnir.ossman.eu>	<49C9E4B8.3000708@gmail.com>	<20090325171749.62bd0fbb@mjolnir.ossman.eu>	<49CBAF36.1010203@gmail.com> <20090405203317.72ce6aff@mjolnir.ossman.eu>
In-Reply-To: <20090405203317.72ce6aff@mjolnir.ossman.eu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is curious. I have concentrated my tests on 2.6.29 with HZ=100 and no preemption, and I have done next tests with my microSD card and laptop:

*	mmc_delay(2) -> FAIL
*	mdelay(2) -> FAIL
*	mmc_delay(10) -> Works!
*	mdelay(10) -> Works!

And by mistake I found that:

*	msleep(2) -> Works!

	Best Regards,
		José María

Pierre Ossman wrote:
> 
> All of them will result in a sleep though. Preferably, I'd like to now
> the minimum delay you need to get things working. Change from
> mmc_delay() to mdelay() to make sure there aren't any sleeps (which
> generally take quite some time to complete).
> 
> Rgds

