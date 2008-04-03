Return-Path: <linux-kernel-owner+w=401wt.eu-S1759604AbYDCOrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759604AbYDCOrS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 10:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757415AbYDCOrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 10:47:05 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:63851 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757552AbYDCOrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 10:47:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=a/e94U5WnUYdB/n8dIb18jmH2RhyyJsCmjxBxpBXwnCmmJxExTaK8+ZAc4VMMNkzXc0LOjrx4LfWtN0ooGBK7ozMJ1rAbSvGMQZaR3RwPtrhJa/c/Gih2LM62kECRsTy6wrXGGl/UZLNzSBAul41AWPqtwnG8jkNvcnoK3J7XkE=
Message-ID: <8bd0f97a0804030746k155a716tb1ced0d1aec6047f@mail.gmail.com>
Date: Thu, 3 Apr 2008 10:46:55 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Bernd Schmidt" <bernds_cb1@t-online.de>
Subject: Re: nommu: handling anonymous mmap clearing in userspace rather than kernel
Cc: "David Howells" <dhowells@redhat.com>, "Greg Ungerer" <gerg@snapgear.com>,
       "David McCullough" <David_Mccullough@securecomputing.com>,
       LKML <linux-kernel@vger.kernel.org>, "Bryan Wu" <Bryan.Wu@analog.com>,
       "Robin Getz" <rgetz@blackfin.uclinux.org>
In-Reply-To: <47F4BA31.1080702@t-online.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8bd0f97a0804011434r4869fbe8t89ade12c04c97f2@mail.gmail.com>
	 <5516.1207146014@redhat.com>
	 <8bd0f97a0804020747r2d7c2802pa18cf08eced3821b@mail.gmail.com>
	 <47F3A02B.5070302@t-online.de>
	 <8bd0f97a0804020807o21f69b7due910563b9dad03e8@mail.gmail.com>
	 <47F4BA31.1080702@t-online.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 3, 2008 at 7:06 AM, Bernd Schmidt <bernds_cb1@t-online.de> wrote:
> Mike Frysinger wrote:
> > i also expected MAP_UNINITIALIZE to be unacceptable to LKML.  and
> > afaik, there doesnt seem to be a way to distinguish in the kernel
> > whether the call is coming from userspace or kernel space, so the
> > memset() call will still be called for the kernel.  ideally the code
> > would read:
> > if (!kernel && !(flags & MAP_UNINITIALIZE))
> >    memset(base, 0, len);
> >
>
>  Have you examined all callers in the kernel whether they can take
> uninitialized memory?

if they cant, they're broken, and need to get fixed.  i see these
crashes then as a good thing :).

> (Your code doesn't match your description btw, so I'm
> only guessing what you actually want to achieve.)

doesnt it ?  the memset should only be called for userspace when it
hasnt given the uninitialize flag.  if it's kernel space, we want to
skip it.  if the uninitialize flag is given, we want to skip it.

>  Really, if MAP_UNINITIALIZE is unacceptable, then that's too bad and we'll
> carry it as a local patch, but all the other proposed mechanisms are
> non-solutions because they break an established interface.

i'm just airing out the different solutions so people get a better
idea of what's going on.  i dont think the userspace <-> kernelspace
breakage is important, as the ABI is maintained at the important
layer: user application <-> C library.
-mike
