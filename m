Return-Path: <linux-kernel-owner+w=401wt.eu-S1764170AbXH0Vxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764170AbXH0Vxg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:53:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759531AbXH0Vmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:42:47 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:16092 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762858AbXH0Vmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:42:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RZ88iBYGynWGsBo5eKweiB+55GfHkGe+6ZXNb+tIHp/i4FQC11XZmg9b20rDc0OdsuCTKLoNxF+9m0qKdOrDAEAgH9ZB5etbzdojvvqxH5kB048CAlEtWQZ6lqrtf0w9eS4FerrM3KSqwVkIyDWiGP0FLjMFfnp8xLnreeBqDxM=
Message-ID: <8bd0f97a0708271442l4a2f8c76if38ae002b2d32f03@mail.gmail.com>
Date: Mon, 27 Aug 2007 17:42:43 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [-mm patch] make types.h usable for non-gcc C parsers
Cc: "Gabriel C" <nix.or.die@googlemail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Olaf Hering" <olh@suse.de>
In-Reply-To: <20070827213637.GN26410@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
	 <46CC3B27.10604@googlemail.com> <20070827212743.GN4121@stusta.de>
	 <8bd0f97a0708271434y2d0dac76v6ab4036cec0aadd9@mail.gmail.com>
	 <20070827213637.GN26410@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/27/07, Adrian Bunk <bunk@kernel.org> wrote:
> On Mon, Aug 27, 2007 at 05:34:21PM -0400, Mike Frysinger wrote:
> > On 8/27/07, Adrian Bunk <bunk@kernel.org> wrote:
> > > This patch makes the 64bit integers on 32bit architectures usable for
> > > all C parsers that know about "long long".
> >
> > ah, yet another attempt at this stuff
> >
> > you probably need to update linux/types.h as well
>
> What problems do you observe with linux/types.h?

just grep for __GNUC__ ...

#if defined(__GNUC__) && !defined(__STRICT_ANSI__)
typedef     __u64       uint64_t;
typedef     __u64       u_int64_t;
typedef     __s64       int64_t;
#endif

#if defined(__GNUC__) && !defined(__STRICT_ANSI__)
typedef __u64 __bitwise __le64;
typedef __u64 __bitwise __be64;
#endif

you've made available __u64 and __s64, but not the rest ...
-mike
