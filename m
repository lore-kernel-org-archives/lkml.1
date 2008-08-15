Return-Path: <linux-kernel-owner+w=401wt.eu-S1760045AbYHOVkQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760045AbYHOVkQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 17:40:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753983AbYHOVkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 17:40:04 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58247 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753803AbYHOVkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 17:40:01 -0400
Date: Fri, 15 Aug 2008 22:17:14 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kenneth Goldman <kgoldman@us.ibm.com>
Cc: "Peter Dolding" <oiaohm@gmail.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 1/4] integrity: TPM internel kernel interface
Message-ID: <20080815221714.50d709ee@lxorguk.ukuu.org.uk>
In-Reply-To: <OF1D7319B5.AB5A1EFB-ON852574A6.0066E026-852574A6.006775BA@us.ibm.com>
References: <e7d8f83e0808150337t5e699647wcc6ae296b3fa8c23@mail.gmail.com>
	<OF1D7319B5.AB5A1EFB-ON852574A6.0066E026-852574A6.006775BA@us.ibm.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Aug 2008 14:50:01 -0400
Kenneth Goldman <kgoldman@us.ibm.com> wrote:

> "Peter Dolding" <oiaohm@gmail.com> wrote on 08/15/2008 06:37:27 AM:
> 
> > Remember even soldered on stuff can fail.   How linux handles the
> > death of the TPM module needs to be covered.
> 
> Is fault tolerance a requirement just for the TPM, or is it a general>
> Linux requirement?  Has it always been there, or is it new?

We try very very hard to not crash on failure.

> For example, does kernel software have to gracefully handle
> failures in the disk controller, processor, memory controller, BIOS
> flash memory, etc?

Our disk layer will retry, reset, change cable speeds and if that fails
and you are running raid with multipaths or sufficient mirrors continue.
We capture processor exceptions and when possible log and continue
although most CPU failures report with the context corrupt. We log and
the EDAC layer handles as much as it possible can for memory errors
(actually we could be a bit more selective here and there are proposals
to go  further)

> I'd think it would be quite hard to code around motherboard
> failures in a commodity platform not designed for fault tolerance.

The Linux userbase ranges from fault tolerant systems like Stratus to
dodgy cheapo boards from iffy cheap and cheerful computer merchants so it
makes sense to try and be robust.

In your TPM case being robust against the TPM ceasing to respond
certainly is worthwhile so that at least you return an error on failure
rather than the box dying. You may well not be able to get the chip back
in order without a hardware change/reboot.

Alan
