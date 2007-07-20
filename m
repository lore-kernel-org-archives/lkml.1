Return-Path: <linux-kernel-owner+w=401wt.eu-S935606AbXGTITG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935606AbXGTITG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 04:19:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933276AbXGTIS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 04:18:28 -0400
Received: from wr-out-0506.google.com ([64.233.184.227]:51953 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932799AbXGTISX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 04:18:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=i8QrG2p5zUTPhNG+7Vp9/gAMLMGnvZMdx8N0CMMt7UN7W+zv4k9B7dm3/NOWI9xObLMQahaTAPRDUWlCP2dT0lQ+s/6MqUDM786VI7XovTAE4kWLUoAXyshVavtESmC9FQkgbk8FCxR7juxpTt2nDCQIl5FzSrKaqwebx1celQo=
Message-ID: <a781481a0707200118k7aa29175g5ae926e4b28e20c0@mail.gmail.com>
Date: Fri, 20 Jul 2007 13:48:22 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Christoph Hellwig" <hch@lst.de>
Subject: Re: [PATCH] kill DECLARE_MUTEX_LOCKED
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070720071742.GB25717@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070719211135.GA32725@lst.de>
	 <a781481a0707192228r4c4e6bdfj53449d1fc67bc641@mail.gmail.com>
	 <20070720071742.GB25717@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 7/20/07, Christoph Hellwig <hch@lst.de> wrote:
> On Fri, Jul 20, 2007 at 10:58:34AM +0530, Satyam Sharma wrote:
> > That comment in libusual is quite nonsensical, IMHO. Note that
> > usu_init_notify is declared as DECLARE_MUTEX_LOCKED and yet the
> > author wants us to believe (later, when he's doing that dummy
>
> Given that no one should use libusual and we should kill it and the
> abomination called ub I don't really care about fixing this up.

I was actually referring to _this_ "comment":

/* A completion does not work here because it's counted. */

at libusual.c:181, and not yours :-)

It's a bogus comment, because the logic in there (usu_init_notify
set to 0 i.e. locked at build time, unlocked to 1 by usb_usual_init()
after usb_register() and the the dummy "down(); up();" by the
probe threads would mean that the semaphore will *never* ever
have a value other than {0, 1}. So contrary to what the author
thought, it's not a counted semaphore.

Satyam
