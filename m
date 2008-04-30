Return-Path: <linux-kernel-owner+w=401wt.eu-S1760941AbYD3STl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760941AbYD3STl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 14:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758975AbYD3STd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 14:19:33 -0400
Received: from rv-out-0708.google.com ([209.85.198.241]:4074 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757863AbYD3STc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 14:19:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=SirNgdrj3yZR1aXRc413jdg1SYqENN3zQ2yJ7uOmcQXDeLkrjwKPso3fjEYSueSK9pPAfRFdv0A5qjiXzgwY9e/jzkGQx1tTrmeH8rR1cAnvIbnn+pUYJr4Ex+hFUGoAEoPEN11+kCqeLcwdm/ZuEmxi69zF1t7PVyRK3zzBYDw=
Message-ID: <2c0942db0804301119r430b3b86t880437da1f7ce513@mail.gmail.com>
Date: Wed, 30 Apr 2008 11:19:31 -0700
From: "Ray Lee" <ray@madrabbit.org>
To: "Soumyadip Das Mahapatra" <dip_kernel@yahoo.co.in>
Subject: Re: Improved Swaping Method In sort.c
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <191572.86791.qm@web94110.mail.in2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <191572.86791.qm@web94110.mail.in2.yahoo.com>
X-Google-Sender-Auth: ef5f720da0ec8d36
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2008 at 11:09 AM, Soumyadip Das Mahapatra
<dip_kernel@yahoo.co.in> wrote:
> Thanks Jan,
>  Actually it should be
>  static void u32_swap(void *a, void *b)
>  {
>     *(u32 *)b ^= *(u32 *)a;
>     *(u32 *)a ^= *(u32 *)b;
>     *(u32 *)b ^= *(u32 *)a;
>  }
>  But this code saves memory equaling two integers. What about that ?

The above prevents gcc from storing the intermediary in a register. So
you're trading fast register access for slow memory access.

Really, you shouldn't be prosing optimizations unless you do two
things: check the output of gcc (on at least one platform, but really
should be several), and include timings of before/after.
