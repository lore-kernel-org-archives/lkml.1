Return-Path: <linux-kernel-owner+w=401wt.eu-S967086AbXEGWT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967086AbXEGWT1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 18:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966631AbXEGWTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 18:19:24 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:9550 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966583AbXEGWTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 18:19:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=us389KqVG1r1/Ci4l9DL59MaUP71Suq45w8K/RDK+D7QKfvgd90nY3J6htzp2Ws9CSaOa9dNiDgSm7DfqhXHHIc7NK5EjMWBXJANPDfPjaWFtylCZnNeJWgOhn40rLnQKLVAcQf+ezRUMhx/CbpejZiI5UjepzlCmT1UVd/oh/I=
Message-ID: <a36005b50705071519k40449ed2p7b9ece22cc19219a@mail.gmail.com>
Date: Mon, 7 May 2007 15:19:22 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Davi Arnaut" <davi@haxent.com.br>
Subject: Re: [PATCH] rfc: threaded epoll_wait thundering herd
Cc: "Davide Libenzi" <davidel@xmailserver.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <463F9B68.305@haxent.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070504225730.490334000@haxent.com.br>
	 <463BC3CA.6050109@haxent.com.br>
	 <Pine.LNX.4.64.0705051155210.19104@alien.or.mcafeemobile.com>
	 <463CFA37.3020809@haxent.com.br>
	 <a36005b50705071400p5302da05n7d27ec1995b9d4dc@mail.gmail.com>
	 <463F9B68.305@haxent.com.br>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/7/07, Davi Arnaut <davi@haxent.com.br> wrote:
> See Linus's message on this same thread.

No.  I'm talking about the userlevel side, not kernel side.

If a thread is canceled *after* it returns from the syscall but before
it reports the event to the call (i.e., while still in the syscall
wrapper, thread cancellation rules require a check there) the event is
lost.

Linus was only talking about the kernel side and how in the exit path
such events are not lost.
