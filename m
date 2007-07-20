Return-Path: <linux-kernel-owner+w=401wt.eu-S1760477AbXGTF2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760477AbXGTF2n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 01:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751338AbXGTF2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 01:28:36 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:22077 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbXGTF2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 01:28:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dGOVXMsJzx95+uI666guVXuz2+OAhm7jK5Z9SxmRwNE+XAyXbyLMt0BBQfdrFNNXMFcGqVN36lLA8EXnRGA7lpjB2f9OF53TEWpzkD+ERud9/RTrW2os3juLNsY59VrD3y21vvEqp4zQgfAJTcJL9PtOMU3a4y+04PQjjdzBjZ4=
Message-ID: <a781481a0707192228r4c4e6bdfj53449d1fc67bc641@mail.gmail.com>
Date: Fri, 20 Jul 2007 10:58:34 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Christoph Hellwig" <hch@lst.de>
Subject: Re: [PATCH] kill DECLARE_MUTEX_LOCKED
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070719211135.GA32725@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070719211135.GA32725@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

On 7/20/07, Christoph Hellwig <hch@lst.de> wrote:
> DECLARE_MUTEX_LOCKED was used for semaphores used as completions and
> we've got rid of them.

Thanks, I'd been meaning to do this for months :-)
Had even audited the kernel for its usage ... just didn't make or
send out a patch, sorry.

> Well, except for one in libusual that the
> maintainer explicitly wants to keep as semaphore.

That comment in libusual is quite nonsensical, IMHO. Note that
usu_init_notify is declared as DECLARE_MUTEX_LOCKED and yet the
author wants us to believe (later, when he's doing that dummy

down();
/* nothing here */
up();

stuff at line no. 181) that the semaphore is somehow "counted" ...
Has anybody tried going through all the logic in that file? Looks totally
weird to me ... :-) Nothing in there that can't be serialized using proper
primitives.

> So convert that
> useage to an explicit sema_init and kill of DECLARE_MUTEX_LOCKED so that
> new code is reminded to use a completion.

and I guess nobody cares a whit for the #if 0'ed stuff in drivers/fc4/fc.c

> Signed-off-by: Christoph Hellwig <hch@lst.de>

Well, probably not worth much, but: Ack.

Satyam
