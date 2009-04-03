Return-Path: <linux-kernel-owner+w=401wt.eu-S1762288AbZDCJu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762288AbZDCJu0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 05:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755764AbZDCJuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 05:50:07 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:64851 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755719AbZDCJuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 05:50:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Xhno1IgeEDfdDJeiwt50vwoTKnUQ7Q/nZ25w0T+Ew4L+vG8g4taj6503KZWxmuDJwk
         qfMbmuww2I6+P05mqm5s8JAN6UcDr39nVqt5GI9qYC5IIFMGH1KN2OP/QsSg8G/O+IWa
         aAf07Ua3UovcuTfGP5xnikZuXJKYCbO9gHFh0=
Subject: Re: [PATCH 1/2] lib: add fast lzo decompressor
From: Andreas Robinson <andr345@gmail.com>
To: John Stoffel <john@stoffel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Alain Knaff <alain@knaff.lu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <18900.52255.798522.393088@stoffel.org>
References: <1238593252-3435-1-git-send-email-andr345@gmail.com>
	 <1238593252-3435-2-git-send-email-andr345@gmail.com>
	 <49D3927A.2050406@zytor.com> <1238613730.10514.35.camel@andreas-desktop>
	 <18900.52255.798522.393088@stoffel.org>
Content-Type: text/plain
Date: Fri, 03 Apr 2009 11:49:56 +0200
Message-Id: <1238752196.8118.185.camel@andreas-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-02 at 10:30 -0400, John Stoffel wrote:
> >>>>> "Andreas" == Andreas Robinson <andr345@gmail.com> writes:
> 
> Andreas> On Wed, 2009-04-01 at 09:12 -0700, H. Peter Anvin wrote:
> >> OK, I'm more than a bit nervous about that, especially since we're
> >> trying to make the decompression functions more generic.
> 
> Andreas> Perhaps the system can default to the safe decompressor for
> Andreas> normal use and choose the fast one if STATIC is defined or
> Andreas> when system_state == SYSTEM_BOOTING?
> 
> So how do you prove that data is trusted?

The kernel and initramfs images are implicitly trusted, but that is not
unique to this implementation. None of the decompressors check the data
e.g by comparing checksums, AFAICT.

> What happens on buffer overflow?

The overflow is detected and an error is returned to the caller ... or
the kernel just committed suicide by overwriting itself. *cough*.

Ok, I will put back the checks that actually prevents output overruns.
It is still faster, but could no longer crash the system directly.

There would remain a 3-byte overflow at the end of the output buffer, by
design. However, it can be managed to never be a problem.

>   I don't think that a 20% speedup on decompression, with a
> possibility of borking the boot completely is worth it.  Or are you
> suggesting that people pre-test their initramfs images with this
> compressor before deciding to boot from it?

The compressor (lzop) has been around for a long while so it's probably
ok.

In case I broke the decompressor the best I can offer is more testing.
In its present form it unpacks a 5 MB initramfs without errors. Does it
need to be tested with more data? In that case, do you have any
suggestions?

Thanks,
Andreas

