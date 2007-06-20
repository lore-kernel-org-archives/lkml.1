Return-Path: <linux-kernel-owner+w=401wt.eu-S1754006AbXFTQWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006AbXFTQWc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 12:22:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752166AbXFTQWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 12:22:23 -0400
Received: from wr-out-0506.google.com ([64.233.184.239]:7397 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbXFTQWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 12:22:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=VzlQF1RV2rNHiTra/17FCtMTMvDLdOSv4ECXReiCr2UAKsGO0xuDmnW8Q9p/RPrFTTADWwgQeqU1czwwCwZvC3ou5wKuHQ/D4KNfnoiQ/pDScokAKVUcTok2A19vkbsXj5SMO3DKEo8lKt/NIJ9bAIArLltmQv0oVkfnF6d3YMw=
Message-ID: <2c0942db0706200922i15ce44b0xceaed95d002dba33@mail.gmail.com>
Date: Wed, 20 Jun 2007 09:22:20 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Timo Sirainen" <tss@iki.fi>
Subject: Re: SMP read() stopping at memory page boundaries
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1182354493.3768.80.camel@hurina>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1182351171.3768.65.camel@hurina> <1182354493.3768.80.camel@hurina>
X-Google-Sender-Auth: 131c7bab060b8801
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/20/07, Timo Sirainen <tss@iki.fi> wrote:
> On Wed, 2007-06-20 at 17:52 +0300, Timo Sirainen wrote:
> > Sometimes read() returns only 4096 bytes. I'm locking the file, so I
> > don't think this should ever happen, right?

man 2 read

read() is always allowed to return less than you asked for. You need
to go back and ask for the rest. That's why people wrap read() and
write() in loops, and use those wrapped versions instead.

> read() sometimes returns 4096 bytes but with the "1111" already included
> in the data.

Uhm, do you mean 'without the 1111'? 4096 with the 1111 sounds
perfectly fine. (Though 4096 without the 1111 is also perfectly fine.)

> Is there a way to avoid this without locking the file while
> reading? The "1111" tries to act as a kind of a lock.

I think you've misunderstood how read and write work. pread and pwrite
are no different in this respect -- they just allow an atomic
seek+read/write.

Ray
