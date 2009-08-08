Return-Path: <linux-kernel-owner+w=401wt.eu-S933989AbZHHKMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933989AbZHHKMe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 06:12:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933925AbZHHKMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 06:12:34 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:49485 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302AbZHHKMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 06:12:33 -0400
Subject: Re: [PATCH] fat: Read buffer overflow
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Roel Kluin <roel.kluin@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <87prb6pqdu.fsf@devron.myhome.or.jp>
References: <4A7CAF28.8020908@gmail.com>
	 <87y6pvi5qp.fsf@devron.myhome.or.jp>
	 <84144f020908072356r5cc3100dp79a6a508bafec7c7@mail.gmail.com>
	 <87prb6pqdu.fsf@devron.myhome.or.jp>
Date: Sat, 08 Aug 2009 13:12:32 +0300
Message-Id: <1249726352.8101.0.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-08-08 at 19:10 +0900, OGAWA Hirofumi wrote:
> Pekka Enberg <penberg@cs.helsinki.fi> writes:
> 
> > Yes, but we pass "ulen" to vfat_is_used_badchars(). The value of
> > "ulen" is a returned in the "longlen" argument of xlate_to_uni() which
> > in turn is calculated as follows for the UTF-8 case:
> >
> >   int name_len = strlen(name);
> >   *outlen = utf8s_to_utf16s(name, PATH_MAX, (wchar_t *) outname);
> >   *outlen -= (name_len - len);
> >   *longlen = *outlen;
> >
> > Maybe "*outlen" can never be negative because of some invariants that
> > I don't see but it's so non-obvious to me that I'd like to see the
> > explicit check in vfat_is_used_badchars().
> 
> Ah, good point. Sorry, I was looking my tree. I'm going to submit the
> attached patch on next merge window.
> 
> Is this enough for it?

Fine by me!

			Pekka

