Return-Path: <linux-kernel-owner+w=401wt.eu-S1422985AbXBBTBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422985AbXBBTBb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 14:01:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423039AbXBBTBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 14:01:31 -0500
Received: from old-tantale.fifi.org ([64.81.251.130]:38118 "EHLO
	tantale.fifi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422985AbXBBTBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 14:01:30 -0500
To: Roland Kuhn <rkuhn@e18.physik.tu-muenchen.de>
Cc: "Guillaume Chazarain" <guichaz@gmail.com>,
       "Denis Vlasenko" <vda.linux@googlemail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: O_NONBLOCK setting "leak" outside of a process??
References: <200701272152.11087.vda.linux@googlemail.com>
	<87bqkhuqpp.fsf@tantale.fifi.org>
	<200702020000.40524.vda.linux@googlemail.com>
	<87abzxbhau.fsf@tantale.fifi.org>
	<E0CFA8EB-F706-49E8-A1D1-7BAF19C8D271@e18.physik.tu-muenchen.de>
	<3d8471ca0702020548n9455f4fre8c4ceea3f070a51@mail.gmail.com>
	<24DAE20A-F4CC-4A8F-902A-2A73D0DA2EB1@e18.physik.tu-muenchen.de>
Mail-Copies-To: nobody
From: Philippe Troin <phil@fifi.org>
Date: 02 Feb 2007 10:59:42 -0800
In-Reply-To: <24DAE20A-F4CC-4A8F-902A-2A73D0DA2EB1@e18.physik.tu-muenchen.de>
Message-ID: <87bqkc9yht.fsf@tantale.fifi.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Kuhn <rkuhn@e18.physik.tu-muenchen.de> writes:

> Hi Guillaume!
> 
> On 2 Feb 2007, at 14:48, Guillaume Chazarain wrote:
> 
> > 2007/2/2, Roland Kuhn <rkuhn@e18.physik.tu-muenchen.de>:
> >
> >> That's a bug, right?
> >
> > No, if you want something like: (echo toto; date; echo titi) > file
> > to work in your shell, you'll be happy to have the seek position
> > shared in the processes.

Absolutely right.  This has been part of Unix since the beginning.

> As a naive user I'd probably expect that each of the above adds to
> the output, which perfectly fits the O_APPEND flag (to be set by the
> shell, of course).

No, no, O_APPEND has slightly different semantics.

> The immediate point was about the flags, though, and having
> O_NONBLOCK on or off certainly is a _design_ choice when writing a
> program. If I remove O_NONBLOCK, I have a right to expect that I/O
> functions do not return EAGAIN!

Generally you don't want to mess with shared resouces like stdin,
stdout and stderr.

Phil.
