Return-Path: <linux-kernel-owner+w=401wt.eu-S1752204AbZGTBCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204AbZGTBCw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 21:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbZGTBCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 21:02:50 -0400
Received: from mail-yx0-f184.google.com ([209.85.210.184]:41508 "EHLO
	mail-yx0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbZGTBCt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 21:02:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qrptD/zKDW01/+yDNo/dbcuOMmmWvtSYFYD2GXiI6J2xO20tJEavf8GY4HYHwm75MC
         JZY+CrLLFD3oNLC4+zz6DwXc7T5yhW2SEdCQcF/12ne6fo3OzPMkP875QifctNLxB9qc
         tx548/Fd+gG6X5gDTwMfXSq6h/Q4/ApQtRzgQ=
MIME-Version: 1.0
In-Reply-To: <4A63C00A.2070805@zytor.com>
References: <817ecb6f0907191742i13df19afmc4e258a857c3b465@mail.gmail.com>
	 <4A63C00A.2070805@zytor.com>
Date: Sun, 19 Jul 2009 21:02:47 -0400
Message-ID: <817ecb6f0907191802g4fd0970dj9e8327d44cf7e5a@mail.gmail.com>
Subject: Re: [PATCH] x86: Reducing footprint of BIOS32 service mappings
From: Siarhei Liakh <sliakh.lkml@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Andi Kleen <andi@firstfloor.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Ingo Molnar <mingo@elte.hu>, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Thomas Gleixner <tglx@linutronix.de>, linux-cris-kernel@axis.com,
       Roland Dreier <rdreier@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For now I have only tested it on my home system and qemu. Actuallym in
both cases, I had to compile kernel with only CONFIG_PCI_GOBIOS=y,
since Kernel prefers other ways to access PCI when possible (with
CONFIG_PCI_GOANY=y).

On Sun, Jul 19, 2009 at 8:53 PM, H. Peter Anvin<hpa@zytor.com> wrote:
> Siarhei Liakh wrote:
>> According to BIOS32 specification
>> (http://members.datafast.net.au/dft0802/specs/bios32.pdf), at most two
>> pages per BIOS32 service should be set executable and no pages need to
>> be writeable. This patch modifies bios32_service() to set proper page
>> access permissions at time of service discovery, as described in the
>> specification.
>> Further, hardcoded protection of memory area between 640k to 1Mb have
>> been removed from static_protections(), since only pages mentioned
>> above need to be executable, not whole BIOS region.
>>
>> The patch have been developed for Linux 2.6.30 x86 by Siarhei Liakh
>> <sliakh.lkml@gmail.com> and Xuxian Jiang <jiang@cs.ncsu.edu>.
>>
>
> Specifications mean little in the BIOS space, unfortunately.  Do we have
> any notion about how many machines this has been tested on?
>
>        -hpa
>
> --
> H. Peter Anvin, Intel Open Source Technology Center
> I work for Intel.  I don't speak on their behalf.
>
>
