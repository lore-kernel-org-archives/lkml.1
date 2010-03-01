Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab0CAXnv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 18:43:51 -0500
Received: from mail-ww0-f46.google.com ([74.125.82.46]:50248 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab0CAXnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 18:43:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Gr7/147RAMsPaeR/YeqQy6T/gFH++rVsbW6jcoe/R9t/nLM0npcLs6lAQ0BFP0qvBu
         NaUL/L97P/EyFp5/t3qdjMu18wuRXZN7BH6ZYfK66pPTl7bDfa2wJVi67NrzHbkxSSez
         wKDYCYZLxnHK70nezmD4/SoesiJ6BKkgZdstI=
MIME-Version: 1.0
In-Reply-To: <40101cc31003011403x4423cb3em1f6fcb04d64dd2bb@mail.gmail.com>
References: <40101cc31003011403x4423cb3em1f6fcb04d64dd2bb@mail.gmail.com>
Date: Mon, 1 Mar 2010 18:43:48 -0500
Message-ID: <73c1f2161003011543q41197be9vbc79e0c86753f0d4@mail.gmail.com>
Subject: Re: AMD Geode i686
From: Brian Gerst <brgerst@gmail.com>
To: Matteo Croce <technoboy85@gmail.com>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 1, 2010 at 5:03 PM, Matteo Croce <technoboy85@gmail.com> wrote:
> Hi,
> I have refreshed my AMD Geode i686 patch with NOPL and I have added a
> new nice feature.
> When a NOPL is found the parser looks for any NOPL after the current
> one, so they are emulated in bulk.
> Tested ok on a Pcengines Alix.
>
> Signed-off-by: Matteo Croce <technoboy85@gmail.com>

1. Since this can possibly touch userspace, you must use get_user() to
read the instruction bytes.

2. This parser is too simple to cover all the possible encodings, not
just the recommended ones from the Intel manual.  You really should be
decoding:
- all prefixes (like segment overrides), which can be repeated.
- the 0f 1f opcode.
- the Mod R/M byte.
- the SIB byte (if present).
- the displacement.

This should probably be part of a more general instruction emulator.

--
Brian Gerst
