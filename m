Return-Path: <linux-kernel-owner+w=401wt.eu-S1753847AbYATNBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847AbYATNBP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 08:01:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752761AbYATNBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 08:01:00 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:60509 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752AbYATNBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 08:01:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=QNU4uJ4BTjGCLRlkkSv/S6OS1t4DOWGKU3XsvxYSkrBFOKDzSD4N7iIzBKStbiB0hCRZtufjhNhXt5uKi1PHwLruhT3dfonVJOTdxnp1dZZ8cEuI6Eo7qX2w24q2djp4DQAqTLCjecM9yBHSvucuQds6CnsJuTPJEdis+i6ISl8=
Message-ID: <47934604.6080505@gmail.com>
Date: Sun, 20 Jan 2008 22:00:52 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 0/6] RFC: Typesafe callbacks
References: <200801202046.14746.rusty@rustcorp.com.au> <4793450F.40902@gmail.com>
In-Reply-To: <4793450F.40902@gmail.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> * Passing NULL as data to callback which takes non-void pointer
>   triggers warning.  I think this should be allowed.  Something like
>   the following?

Please ignore the last sentence.

> * Allowing non-pointer integral types which fit into pointer would be
>   nice.  It's often convenient to pass integers to simple callbacks.
> 
> The following macro kinda-sorta achieves the above two but it doesn't
> consider promotion of integer types and thus is too strict.  There
> gotta be some way.

What should be do are

* Check that the threadfn's argument fits into void *.

* Trigger overflow in implicit constant conversion warning if the
specified data is too large for the argument type.

Tricky...

-- 
tejun
