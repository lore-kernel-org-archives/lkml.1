Return-Path: <linux-kernel-owner+w=401wt.eu-S1755204AbXEGXrv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204AbXEGXrv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 19:47:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754757AbXEGXrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 19:47:46 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:54674 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586AbXEGXrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 19:47:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KWUUWTV3tePIH7Bhli8EjVbuz15cRxuYYR3MRPlsXLMsUyC2VHwRS96DVOwFiC4gfOvL6QgBjELiQ6hcx4Fzwi0eS/uVEgHDucaTlBIs69xEbsnFyf5SnUAduoMmrSbQdgf1CEw5ddqzPDFTUtapWcc8qzBKqB9kddH6TuTekBU=
Message-ID: <8bd0f97a0705071647w58c6055ehc54dd6b520a8e227@mail.gmail.com>
Date: Mon, 7 May 2007 19:47:44 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [spi-devel-general] adding bits_per_word to struct spi_board_info to mirror struct spi_device
Cc: spi-devel-general@lists.sourceforge.net, "Wu, Bryan" <Bryan.Wu@analog.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <200704250813.30999.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8bd0f97a0704250305qe6175cdm8e1a0cd7844f67bc@mail.gmail.com>
	 <200704250813.30999.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/25/07, David Brownell <david-b@pacbell.net> wrote:
> On Wednesday 25 April 2007, Mike Frysinger wrote:
> > the spi_device structure has a bits_per_word so that you can change
> > the value on a per-device setting, yet the spi_board_info structure
> > does not ... this means that the bus-specific structure has to have a
> > bits_per_word member which the spi bus driver will copy into the spi
> > device bits_per_word member
>
> Actually that's more likely a driver-specific characteristic than
> something related to board wiring/configuration ... a characteristic
> of the particular protocol requests being made.  That's why for
> example bits_per_word has a per-transfer override, and drivers are
> able to call spi_setup(spi).

hmm, true ...

> > is there something obvious i'm missing ?  seems to me that if the
> > generic spi framework respects bits_per_word on a per-spi device
> > basis, then it should be exposed in the generic info structure so that
> > the setting can be tracked in the boards file ...
>
> The initial driver set didn't need it, that's all.  ISTR someone
> else pointed out this quirk, but never provided a patch to resolve
> the issue.

so which direction should it be ?  or should it be both ? :)

Blackfin at the moment is doing DMA/bits_per_word setup in the boards
... we could move these to the drivers and have each one just call
spi_setup() at init, or i could post a patch for the common framework
if you think that's an OK direction to [also] go ...
-mike
