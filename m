Return-Path: <linux-kernel-owner+w=401wt.eu-S940259AbXHIOJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940259AbXHIOJi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 10:09:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936769AbXHIOJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 10:09:26 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:30492 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932126AbXHIOJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 10:09:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GLS1fmRZnlvL1lK3Rv1Si+l0gNe7QaA2eZ3plmwmhQo23ZPLKCPjtaZ0rMR6pNn4wJTFu6/fw5MHa8hJRGAIUfbHg7TewhLSrzrSK72Gkc4bpJTk3iT1NiCe+aJ9csi4xhv/5OIAJd3lRKJyL16t4EyMdt+/PwVBCFd4pDCJ52c=
Message-ID: <851fc09e0708090709s4f4fbbf9r91a7300a773f985a@mail.gmail.com>
Date: Thu, 9 Aug 2007 22:09:23 +0800
From: "huang ying" <huang.ying.caritas@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [PATCH 5/5] x86_64 EFI support -v3: EFI document
Cc: "Etienne Lorrain" <etienne_lorrain@yahoo.fr>, linux-kernel@vger.kernel.org,
       ebiederm@xmission.com, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <200708091251.21726.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <183884.85434.qm@web26915.mail.ukl.yahoo.com>
	 <200708091251.21726.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/9/07, Andi Kleen <ak@suse.de> wrote:
> There is really no 32bit entry point today usable for external users. Or rather
> it might by chance work today, but if we change the zero page (and there
> is no guarantee it'll not be changed). I can pretty much guarantee it'll
> be changed at some point. And you'll break if you use it.

Yes, there is no official 32bit external entry point. But on EFI
platform, the 16bit entry point can not be used because there is no
16bit BIOS call available. So, I think it is necessary to define a
32bit external entry point.

> kexec can use the 32bit entry, but only because it is in tree so it can be fixed
> up for any changes.

The kexec uses the 32bit entry point in a user space tool named
kexec-tools, not in the kernel.

> If you want to use it you would need to define some versionable protocol
> first similar to the real mode boot protocol. That would require some work
> and some thought to make sure it is forwards and backwards compatible.

I think at least the following should be done to make it a external
boot protocol.

1. A version number field should be added.
2. The pointers (especially these come from firmware) should be 64bit
to make the entry point can be used for both 32bit and 64bit platform.
3. More complete and formal document.

Can you kindly tell me what's more should be done?

Best Regards,
Huang Ying
