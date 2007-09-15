Return-Path: <linux-kernel-owner+w=401wt.eu-S1754604AbXIOOyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604AbXIOOyv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 10:54:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750885AbXIOOyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 10:54:44 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:14017 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbXIOOyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 10:54:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=DFFJz9nHuTBweCNGyITddWEzXMLzxVM7zi9JcGsX1JFQuPxsbKebhfGIkYPGx2i3wr3gxbQx2wXW1yg++GAxhtH7f3hdQmKg2mA5sHZJx5Ys+SrQ3JrmHbaw3WUtOXVhZ0l95NAPlEEiz9+yfgv0BLDpGR8xA+9Ywfub2B3yn+I=
Message-ID: <2c0942db0709150754j563dfb3ahc1aeabe4661e1ced@mail.gmail.com>
Date: Sat, 15 Sep 2007 07:54:41 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Heikki Orsila" <shdl@zakalwe.fi>
Subject: Re: On thread scheduling
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070914224000.GI3400@zakalwe.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070914224000.GI3400@zakalwe.fi>
X-Google-Sender-Auth: fd2e709f4b0e09bc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/14/07, Heikki Orsila <shdl@zakalwe.fi> wrote:
> Consider a simple embedded system:
>
> void interrupt_handler(void)
> int main(void)
>
> I would like to "emulate" this system with a workstation to make
> development faster. I would create two threads, one executing the
> main() function, and the other occasionally calling interrupt_handler().
> Before interrupt_handler() is called, the main() thread should be
> stopped asynchronously.

Are you open to doing something other than pthreads? Using fork() to
get real processes, and then sending a SIGSTOP (and SIGCONT) to the
one running main() should work.

Or emulating the interrupt arrival with a signal, and having
interrupt_handler() be registered as the signal handler. Of course,
you then have to deal with the constraints that come with signal
handlers, so that can be a bit of a pain depending on what you're
trying to do.

Ray
