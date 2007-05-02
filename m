Return-Path: <linux-kernel-owner+w=401wt.eu-S1766988AbXEBRxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766988AbXEBRxn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 13:53:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766985AbXEBRxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 13:53:43 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:27682 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766988AbXEBRxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 13:53:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=IDnsEX1AtWTtul/rob/tjktSmmAMZ5ukoqZWWAM8nkOY7Dks+6xmSBj2VfxY8jzgALOuMPMYQtIrmwHueEDlAI4iG71ocAU/0S2r8xXQJ1FUvBlhDa5TbO0MIZiYwQQdPh/vxLRC87PDXB5yqE4hc3AC1wnGI98sAOg9cmXCsMo=
Message-ID: <a36005b50705021053r2fcaf225l956921570dff20e8@mail.gmail.com>
Date: Wed, 2 May 2007 10:53:40 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Davide Libenzi" <davidel@xmailserver.org>
Subject: Re: [patch 14/22] pollfs: pollable futex
Cc: "Davi Arnaut" <davi@haxent.com.br>, "Eric Dumazet" <dada1@cosmosbay.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0705021028520.7176@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070502052235.914764000@haxent.com.br>
	 <20070502053427.123392000@haxent.com.br>
	 <a36005b50705020040l8874d64m1bcf25da5cae885d@mail.gmail.com>
	 <20070502095503.a06f5472.dada1@cosmosbay.com>
	 <a36005b50705020108o6fb7495ak2383ae64e49c48a0@mail.gmail.com>
	 <20070502104936.674a4b54.dada1@cosmosbay.com>
	 <a36005b50705020939j491ced9ekf3f4203fc8b865a3@mail.gmail.com>
	 <4638C37D.7050503@haxent.com.br>
	 <a36005b50705021010l5c7badc6ub61228f14fdbb28a@mail.gmail.com>
	 <Pine.LNX.4.64.0705021028520.7176@alien.or.mcafeemobile.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/2/07, Davide Libenzi <davidel@xmailserver.org> wrote:
> Is it? Please do tell me more...

Come on, we went through all this.  Having to do syscalls for event
retrieval plus the limited channel available for feedback (the POLL*
bits) is to limiting.  This is where the kevent stuff innovated and
really fixed the problems.  Userlevel ring buffers are more efficient.

Yes, a unifying event look is what is wanted.  But it does not have to
be poll based.  Given the right abstraction you can fit in the kevent
technology or similar things.

And seeing all these requirements of this approach: kevent is also
much more resource efficient.  No "one file desriptor per thread per
object".  These are important factors.
