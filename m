Return-Path: <linux-kernel-owner+w=401wt.eu-S1764859AbYFHMXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764859AbYFHMXi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 08:23:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762063AbYFHMX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 08:23:27 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:21632 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761989AbYFHMX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 08:23:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=DhNtcWXcFPaju5lXTGKQQyYORiqVuievPbAz/PHZE2qHc7F/4q7+AEmqNRSIQPSc7w
         FFxczDfs7WQT/azHLWB/x6HfX2zgeL37yYQpq6ZYvlElNpZPZHYqkxRPDdDuS49MYRLc
         ieeswNpNG/nn5+m98gKbTcq7rYlmx4i/wishM=
Message-ID: <8499950a0806080523l15e5ba01v30c4c78b59e0a4d7@mail.gmail.com>
Date: Sun, 8 Jun 2008 13:23:24 +0100
From: "Oleg Verych" <olecom@gmail.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: [PATCH] Speed up "make headers_*"
Cc: "David Woodhouse" <dwmw2@infradead.org>,
       "Vegard Nossum" <vegard.nossum@gmail.com>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Jan Engelhardt" <jengelh@computergmbh.de>
In-Reply-To: <20080608111707.GB10545@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080608094730.GA30098@uranus.ravnborg.org>
	 <19f34abd0806080312j2b09179cpa384a0460af5874e@mail.gmail.com>
	 <20080608104122.GA10545@uranus.ravnborg.org>
	 <1212922141.32207.495.camel@pmac.infradead.org>
	 <20080608111707.GB10545@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Correct. A quick grep shows that we have these different
> uses of __KERNEL__:
>
> #if defined(__ARM_EABI__) && !defined(__KERNEL__)
> #if !defined(CONFIG_M68K) || !defined(__KERNEL__)
> #if defined(CONFIG_VIDEO_V4L1_COMPAT) || !defined (__KERNEL__)
> #if defined(__GNUC__) && !defined(__STRICT_ANSI__) || defined(__KERNEL__)
> #if defined(__KERNEL__)

> #ifndef __KERNEL__
>
> #else and #endif filtered away.
>
> A script needs to take into account other preprocessor
> uses too due to their nested nature.
> But doable I'm sure.
>
> And I rather have 100 lines perl than use the unifdef utility
> because we then have it collected in one place and can do even
> stricter validation.

I've suggested some time ago to adopt a coding style for simple

#if defined(__KERNEL__)
#ifndef __KERNEL__

this will be much clearner as for developers to know the scope by
using simple /* __KERNEL__ */  /* !__KERNEL__ */, and `sed`
script for that would be from 1 to 4 lines.

-- 
sed 'sed && sh + olecom = love'  <<  ''
-o--=O`C
 #oo'L O
<___=E M
