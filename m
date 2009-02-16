Return-Path: <linux-kernel-owner+w=401wt.eu-S1753092AbZBPRa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092AbZBPRa1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 12:30:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752761AbZBPRaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 12:30:05 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:5830 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752AbZBPRaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 12:30:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=vYQfe5sDSQ7KW75i49Jt1UaPF6UxB62UqQ29PVQPK7YBg4Sxeolm2cnC+6tJSSOtl/
         3fA5ymr6V9NuxYocLCOS4FHhREWL3j3GdTl95yS0iNwoSkL9Wvk4/5TN3mcwu9CiRudz
         9iieat3XY2QYOJNnyLEMu1CjlBnu9fEhI0mFM=
MIME-Version: 1.0
In-Reply-To: <1234801952.20430.33.camel@localhost>
References: <1234272104-10211-1-git-send-email-kirill@shutemov.name>
	 <84144f020902100535i4d626a9fj8cbb305120cf332a@mail.gmail.com>
	 <20090210134651.GA5115@epbyminw8406h.minsk.epam.com>
	 <Pine.LNX.4.64.0902101605070.20991@melkki.cs.Helsinki.FI>
	 <20090216135643.GA6927@cmpxchg.org>
	 <1234801952.20430.33.camel@localhost>
Date: Mon, 16 Feb 2009 19:29:59 +0200
X-Google-Sender-Auth: dd10a8823dc3381e
Message-ID: <84144f020902160929k67ce1881p959646a326bb3f40@mail.gmail.com>
Subject: Re: [PATCH] Export symbol ksize()
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Joe Perches <joe@perches.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       Christoph Lameter <cl@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-crypto@vger.kernel.org,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Geert.Uytterhoeven@sonycom.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-16 at 14:56 +0100, Johannes Weiner wrote:
>> One problem is that zeroing ksize()
>> bytes can have an overhead of nearly twice the actual allocation size.

On Mon, Feb 16, 2009 at 6:32 PM, Joe Perches <joe@perches.com> wrote:
> A possible good thing is when linux has a
> mechanism to use known zeroed memory in
> kzalloc or kcalloc, it's already good to go.

Hmm, kzfree() is not going to be all that common operation so there
won't be that many known zeroed regions and I suspect tracking them
will have more overhead than just doing the memset().
