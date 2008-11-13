Return-Path: <linux-kernel-owner+w=401wt.eu-S1752687AbYKMGOB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687AbYKMGOB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 01:14:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751064AbYKMGNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 01:13:51 -0500
Received: from rv-out-0506.google.com ([209.85.198.234]:62680 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbYKMGNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 01:13:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=RQwdnNhThu34E8fN+YKv0JBMmpSm85I8NuNqUu2Twnih+rv9hjWhvlzf3NW2gPJcuI
         g1aA2TUZSAPaqovwcZNICmqZLqj/lZiku/i5O5CU8vxVcVtgxNnjav3QAL3mo0sYNqLU
         /TteENiGiLjuC2o9YwkyhCmuccXEzODfg2hsk=
Subject: Re: [PATCH 3/4] add ksm kernel shared memory driver
From: Eric Rannaud <eric.rannaud@gmail.com>
To: Valdis.Kletnieks@vt.edu
Cc: Jonathan Corbet <corbet@lwn.net>, Izik Eidus <ieidus@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
       aarcange@redhat.com, chrisw@redhat.com, avi@redhat.com
In-Reply-To: <23027.1226443216@turing-police.cc.vt.edu>
References: <1226409701-14831-1-git-send-email-ieidus@redhat.com>
	 <1226409701-14831-2-git-send-email-ieidus@redhat.com>
	 <1226409701-14831-3-git-send-email-ieidus@redhat.com>
	 <1226409701-14831-4-git-send-email-ieidus@redhat.com>
	 <20081111150345.7fff8ff2@bike.lwn.net>
	 <23027.1226443216@turing-police.cc.vt.edu>
Content-Type: text/plain
Date: Wed, 12 Nov 2008 22:13:47 -0800
Message-Id: <1226556827.13670.54.camel@nc050>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-11-11 at 17:40 -0500, Valdis.Kletnieks@vt.edu wrote: 
> On Tue, 11 Nov 2008 15:03:45 MST, Jonathan Corbet said:
> Seems reasonably sane to me - only doing the first 128 bytes rather than
> a full 4K page is some 32 times faster.  Yes, you'll have the *occasional*
> case where two pages were identical for 128 bytes but then differed, which is
> why there's buckets.  But the vast majority of the time, at least one bit
> will be different in the first part.

In the same spirit, computing a CRC32 instead of a SHA1 would probably
be faster as well (faster to compute, and faster to compare the
digests). The increased rate of collision should be negligible.

Also, the upcoming SSE4.2 (Core i7) has a CRC32 instruction. (Support is
already in the kernel: arch/x86/crypto/crc32c-intel.c)

