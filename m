Return-Path: <linux-kernel-owner+w=401wt.eu-S1751835AbZHZQTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751835AbZHZQTm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 12:19:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751771AbZHZQTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 12:19:41 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:33086 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbZHZQTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 12:19:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=vx00hNmece/fUexARNutX4FJxlTiINbwLbdTP4HCt6K57unWPM78tnyNT4fAsGZEqr
         UZ+kZTuE34CvjqOpNhOrSvfD/CAQgSXpXUYdmZh8PWW+eKLjMl1s3n8t7w71Y9wkTkQU
         3V7P04qfMWLmMxBYGkJSyeirQZFGQJBsh++Gs=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.1.10.0908261209240.9933@gentwo.org>
References: <200908241007.47910.ngupta@vflare.org>
	 <84144f020908241033l4af09e7h9caac47d8d9b7841@mail.gmail.com>
	 <4A92EBB4.1070101@vflare.org>
	 <Pine.LNX.4.64.0908242132320.8144@sister.anvils>
	 <4A930313.9070404@vflare.org>
	 <Pine.LNX.4.64.0908242224530.10534@sister.anvils>
	 <4A93FAA5.5000001@vflare.org> <4A94358C.6060708@vflare.org>
	 <alpine.DEB.1.10.0908261209240.9933@gentwo.org>
Date: Wed, 26 Aug 2009 19:19:40 +0300
X-Google-Sender-Auth: 3a2eb100610ac6a8
Message-ID: <84144f020908260919ke9d6c34qb47c3015ee0ca89b@mail.gmail.com>
Subject: Re: [PATCH 1/4] compcache: xvmalloc memory allocator
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Nitin Gupta <ngupta@vflare.org>, Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-mm-cc@laptop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Aug 2009, Nitin Gupta wrote:
>> I went crazy. I meant 40 bits for PFN -- not 48. This 40-bit PFN should be
>> sufficient for all archs. For archs where 40 + PAGE_SHIFT < MAX_PHYSMEM_BITS
>> ramzswap will just issue a compiler error.

On Wed, Aug 26, 2009 at 7:10 PM, Christoph
Lameter<cl@linux-foundation.org> wrote:
> How about restricting the xvmalloc memory allocator to 32 bit? If I
> understand correctly xvmalloc main use in on 32 bit in order to be
> able to use HIGHMEM?

That was the main reason for a specialized allocator rather than
trying to use SLOB. However, if "xvmalloc" is merged with ramzswap, it
makes sense to use it on desktop class 64-bit machines as well.

                                Pekka
