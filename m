Return-Path: <linux-kernel-owner+w=401wt.eu-S1755233AbYGYSTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233AbYGYSTw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 14:19:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753557AbYGYSTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 14:19:38 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:39641 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862AbYGYSTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 14:19:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=qdc6BVfj91vMmMpbVaQdbJtJRU8sFSi6SYFHK14B8ioPg5cGtfvz0U1XzP/sSIGFVg
         xwdng8JF+fdzh4b3XNBZZvmVj3AO73Cc5BRtjgK0qHi/gOM1pGWlNLIwIDKgE6XAd8xN
         HDfRmCxg1XPyDfobLm/GqYZaBz5KmAVC8yINc=
Subject: Re: [PATCH] byteorder: force in-place endian conversion to always
	evaluate args
From: Harvey Harrison <harvey.harrison@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <488A17EC.2000107@zytor.com>
References: <1217003621.5971.4.camel@brick>  <488A17EC.2000107@zytor.com>
Content-Type: text/plain
Date: Fri, 25 Jul 2008 11:19:35 -0700
Message-Id: <1217009975.5971.21.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-07-25 at 14:14 -0400, H. Peter Anvin wrote:
> Harvey Harrison wrote:
> > David Miller reported breakage in ide when the in-place byteorder helpers
> > were used as the macros do not always evaluate their args which led to
> > an infinite loop.
> > 
> > Just make them functions to ensure they always do so.
> 
> > -#define __cpu_to_be64s(x) do {} while (0)
> 
> For what it's worth, the way to write a macro like this:
> 
> #define __cpu_to_be64s(x) ((void)(x))

If you've looked at the byteorder rework I've done in -mm, these get
unified in a single include/linux/byteorder.h and look like:

static inline void __le16_to_cpus(__u16 *p)
{
#ifdef __BIG_ENDIAN
	__swab16s(p);
#endif
}

static inline void __be16_to_cpus(__u16 *p)
{
#ifdef __LITTLE_ENDIAN
	__swab16s(p);
#endif
}

...etc.

As you can now rely on __BIG/__LITTLE_ENDIAN being set reliably.

Harvey

