Return-Path: <linux-kernel-owner+w=401wt.eu-S937067AbXGSImz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937067AbXGSImz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 04:42:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762468AbXGSImq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 04:42:46 -0400
Received: from wr-out-0506.google.com ([64.233.184.237]:34959 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761634AbXGSImp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 04:42:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oOWOFRzNWKzWsurnqnm8QlkWdQfvzIDEkryZjQ1zfzp0yugPuhJAFikOW3CI3qObMPO81SW0QB1DAvzeNdatOpcxyLSZsg+8NA2GDCnyM/qJTYC8vsmVBTrAUUdwS64T+/BvhdWfi6F7tqnVjZoYGYKKjjIslcdhVH8dPfVJGR0=
Message-ID: <21d7e9970707190115r15e691d5s123c9889a8ebd8a5@mail.gmail.com>
Date: Thu, 19 Jul 2007 18:15:03 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: cmpxchg is not available to generic code
Cc: akpm@linux-foundation.org, airlied@linux.ie, linux-kernel@vger.kernel.org
In-Reply-To: <20070719.002716.30181989.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070719000549.1e57b5b2.akpm@linux-foundation.org>
	 <20070719.002716.30181989.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/19/07, David Miller <davem@davemloft.net> wrote:
> From: Andrew Morton <akpm@linux-foundation.org>
> Date: Thu, 19 Jul 2007 00:05:49 -0700
>
> > What's that code doing anyway?  driver-private locking primitives?
>
> It's an atomic lock shared with userspace.  Whatever implementation is
> used to do the lock on that object must be identical in the userspace
> DRM bits.
>
> Unlike futex, the lock operation on the user side isn't optional.
> So if the platform can't do a true cmpxchg it generally cannot
> support DRM.

Actually in  theory the userspace side is optional, it should fallback
to always entering the kernel and being slow, but Ive no idea how
well that codepath is tested... but it's an area I'd hate to play with
now ..

Maybe we could add CONFIG_HAVE_CMPXCHG and let DRM depend on it..

Dave.
