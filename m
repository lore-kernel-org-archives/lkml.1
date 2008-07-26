Return-Path: <linux-kernel-owner+w=401wt.eu-S1754810AbYGZMSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810AbYGZMSs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 08:18:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935AbYGZMSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 08:18:30 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:51752 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830AbYGZMS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 08:18:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=WEFdSp3T4sxRGrpj+UhCNGkD8xpaoOtqtPwnK7p9SuCxE+ToJjtjmSpRVCTz5z6pAD
         1rIzJoGAunGOO2pgp6I2avzjVV3MR/v8NXIoM41+JoieYd/FmQ3VCPZjGbdhrd9FUPi/
         6tCTUxqGSYOJtQLIXN7WDfPpo6ZDNY9X268P4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: David Miller <davem@davemloft.net>
Subject: Re: recent IDE regression
Date: Sat, 26 Jul 2008 14:04:49 +0200
User-Agent: KMail/1.9.9
Cc: harvey.harrison@gmail.com, linux-ide@kernel.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
References: <20080724.233831.193691312.davem@davemloft.net>
In-Reply-To: <20080724.233831.193691312.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807261404.49947.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 July 2008, David Miller wrote:

[...]

> Something like this:
> 
> endian: Always evaluate arguments.
> 
> Changeset 7fa897b91a3ea0f16c2873b869d7a0eef05acff4
> ("ide: trivial sparse annotations") created an IDE bootup
> regression on big-endian systems.  In drivers/ide/ide-iops.c,
> function ide_fixstring() we now have the loop:
> 
> 		for (p = end ; p != s;)
> 			be16_to_cpus((u16 *)(p -= 2));
> 
> which will never terminate on big-endian because in such
> a configuration be16_to_cpus() evaluates to "do { } while (0)"
> 
> Therefore, always evaluate the arguments to nop endian transformation
> operations.
> 
> Signed-off-by: David S. Miller <davem@davemloft.net>

Thanks David.

PS We need more big-endian users testing linux-next (this particular patch
despite being trivial has been put there just-in-case for a week)
 
