Return-Path: <linux-kernel-owner+w=401wt.eu-S1754806AbYIXQ6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806AbYIXQ6R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 12:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751681AbYIXQ6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 12:58:05 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:47385 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbYIXQ6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 12:58:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=S7cnGXJeqc3PRkW4WKmPRTNARAU70efyePL4K8lNMyKR2aipRMvRi8JE6M4f4e1eXT
         N5Yd5t02RBrKGHpH7zPu0Wax4jDHiI9CsJ8DPn9aEaPeqMJ/tt02DcjR8FkDWLRaX+QE
         D5QcGEzwSdjxewRfzjPEZ6nSIUnXPqno5a87g=
Message-ID: <e9c3a7c20809240958i3ed4b7fbv3c13b6bbc31ac6ee@mail.gmail.com>
Date: Wed, 24 Sep 2008 09:58:02 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Timur Tabi" <timur@freescale.com>
Subject: Re: [PATCH] fsldma: remove internal self-test from Freescale Elo DMA driver
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       scottwood@freescale.com, galak@kernel.crashing.org, leoli@freescale.com
In-Reply-To: <1222201756-21374-1-git-send-email-timur@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1222201756-21374-1-git-send-email-timur@freescale.com>
X-Google-Sender-Auth: a117085906d158b4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2008 at 1:29 PM, Timur Tabi <timur@freescale.com> wrote:
> The Freescale Elo DMA driver runs an internal self-test before registering
> the channels with the DMA engine.  This self-test has a fundemental flaw in
> that it calls the DMA engine's callback functions directly before the
> registration.  However, the registration initializes some variables that the
> callback functions uses, namely the device struct.
>
> The code works today because there are two device structs: the one created
> by the DMA engine, and one created by the Open Firmware (OF) subsystem.  The
> self-test currently uses the device struct created by OF.  However, in the
> future, some of the device structs created by OF will be eliminated.
> This means that the self-test will only have access to the device struct
> created by the DMA engine.  But this device struct isn't initialized when
> the self-test runs, and this causes a kernel panic.
>
> Since there is already a DMA test module (dmatest), the internal self-test
> code is not useful anyway.  It is extremely unlikely that the test will fail
> in normal usage.  It may have been helpful during development, but not any more.
>
> Signed-off-by: Timur Tabi <timur@freescale.com>
> ---
>
> This patch is for 2.6.28.

Applied to the 'next' [1] branch.

Thanks,
Dan

[1] http://git.kernel.org/?p=linux/kernel/git/djbw/async_tx.git;a=shortlog;h=next
