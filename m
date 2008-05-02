Return-Path: <linux-kernel-owner+w=401wt.eu-S935353AbYEBSKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935353AbYEBSKy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 14:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759878AbYEBSKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 14:10:47 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:26310 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759690AbYEBSKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 14:10:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DZZjTHMw0oT+s15gRBYNWSy4nSmxPn6It/CpImFL+b2sh4v11uaSaDotiuUHr2HZWBVUudkgwQl45uytA/KdgLG3IzY2toGjO70LRh3zSmImaP9DNyrMWrRJyX2m7PsVAZ7Y3HStLMJxj6AJ7/bRgqAszmt7FGbv2NpVgLD/7jY=
Message-ID: <f24d23310805021110u58d1a00dm50a5720aaf34dddd@mail.gmail.com>
Date: Fri, 2 May 2008 23:40:44 +0530
From: "debian developer" <debiandev@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [Patch 1/1] Trivial - kernel/time/ntp.c: fix warning
In-Reply-To: <f24d23310805021042v68446bbuc79d4f1a6ac4c7a1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f24d23310805021042v68446bbuc79d4f1a6ac4c7a1@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

 On compiling on a Xeon machine i get the following warning

 kernel/time/ntp.c: In function `do_adjtimex':
 kernel/time/ntp.c:328: warning: comparison of distinct pointer types
 lacks a cast
 kernel/time/ntp.c:329: warning: comparison of distinct pointer types
 lacks a cast

 This is with gcc version 3.4.3. The following patch fixes this...

 --- linux-2.6.25/kernel/time/ntp.c.orig 2008-05-03 04:27:20.000000000 +0530
 +++ linux-2.6.25/kernel/time/ntp.c      2008-05-03 04:45:06.000000000 +0530
 @@ -325,8 +325,8 @@ int do_adjtimex(struct timex *txc)
                     * Scale the phase adjustment and
                     * clamp to the operating range.
                     */
 -                   time_offset = min(time_offset, (s64)MAXPHASE *
NSEC_PER_USEC);
 -                   time_offset = max(time_offset, (s64)-MAXPHASE *
NSEC_PER_USEC);
 +                   time_offset = min(time_offset, (s64)(MAXPHASE *
NSEC_PER_USEC));
 +                   time_offset = max(time_offset, (s64)(-MAXPHASE *
NSEC_PER_USEC));

                    /*
                     * Select whether the frequency is to be controlled
