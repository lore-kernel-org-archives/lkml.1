Return-Path: <linux-kernel-owner+w=401wt.eu-S1754925AbYJWO5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925AbYJWO5s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 10:57:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbYJWO5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 10:57:39 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:36677 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbYJWO5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 10:57:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=vA/qGdJ44xBdX4DPwE/ZSCtTspNrPHCoS/F1eSZBaPM7zlL6WKF6MAXRrdkS4F79HF
         duYvnBaJbChvGEgwGgdz2f6yW92thpwH7MfteRWPKutYSgUMb59WbtPwOfN+8QL5BixJ
         Q2Mn5nXkgiqsYuX2H0ggIF/pXXq34ppGYpQgI=
Message-ID: <c62985530810230757r411b4e3dj4ecec649cf8cf0b3@mail.gmail.com>
Date: Thu, 23 Oct 2008 16:57:35 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Geert Uytterhoeven" <geert@linux-m68k.org>
Subject: Re: linux-next: kernel/trace/trace.c:658: error:
Cc: "Alexey Dobriyan" <adobriyan@gmail.com>,
       "Stephen Rothwell" <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <Pine.LNX.4.64.0810231635440.18978@anakin>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081023213637.eff9b414.sfr@canb.auug.org.au>
	 <20081023121145.GB27984@x200.localdomain>
	 <c62985530810230548t1b569f61g34d1900bb94fde83@mail.gmail.com>
	 <c62985530810230615s3252a54ao6488e763d72dc939@mail.gmail.com>
	 <49008D12.5090204@gmail.com>
	 <Pine.LNX.4.64.0810231635440.18978@anakin>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/23 Geert Uytterhoeven <geert@linux-m68k.org>:
> If kernel/trace/trace.c calls irqs_disabled_flags(), it should include
> the include that defines irqs_disabled_flags(). You should not add it to
> some other random include.
>
> It's also happening on m68k:
> http://kisskb.ellerman.id.au/kisskb/buildresult/50641/

The fact is that other archs include this header into their
asm/system.h. It seems that's because
they need some non-traced irq_save/restore .
I wanted to stay in the same approach because future use of
raw_local_irq could be used elsewhere
and seem to work perfectly whithout adding special headers on most
arch. But there will be some
bug report for each future use of these functions for alpha.... (and
even m68k as it seems).

What do you think? Should I let this patch as is or send a new one
(and one other for m68k).
