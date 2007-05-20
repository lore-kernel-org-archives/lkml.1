Return-Path: <linux-kernel-owner+w=401wt.eu-S1758257AbXETRcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758257AbXETRcS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 13:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756346AbXETRcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 13:32:10 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:23072 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755659AbXETRcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 13:32:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Y7ifN6bV6enMLRbvjWCNAwa3LhOyc/4lGmZU6mzNNhREpi8YAsp8Iv1RjN3IDcsMMn414Q9LBTWLovioFndQWTGnvOIfux73/WMyQAbH0o2U18bpXQroeUWzS54ae6WmJ7v8EFE7eC7NRxCqwnHHPd0xwJwmrkWCTwsvxTX5LTs=
Message-ID: <4650860A.4000601@gmail.com>
Date: Sun, 20 May 2007 19:31:54 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: l.genoni@oltrelinux.com
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: something strange in libata-core.c for kernel 2.6.22-rc3
References: <Pine.LNX.4.64.0704181704270.1663@Phoenix.oltrelinux.com> <20070418162525.423b2e7e@the-village.bc.nu> <Pine.LNX.4.64.0705201434380.30264@Phoenix.oltrelinux.com>
In-Reply-To: <Pine.LNX.4.64.0705201434380.30264@Phoenix.oltrelinux.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

l.genoni@oltrelinux.com wrote:
> 
> Mybe I am wrong, but if you are detecting 40-wire cable to set them to
> DMA/33, why the check includes also 80-wire cables configuring them to
> DMA/33 too?
> 
> With this patch my nvidia4 IDE controllers detects correctly and
> configure correctly DMA/100 for my HD and DMA/33 for my DVD (the first
> uses a 80-wire cable, the second a 40-wire cable).
> 
> Am I wrong somewhere?

That's the drive side verification of 80c cable check, so if the
condition triggers we downgrade 80c or unknown to 40c.  Cable detection
on nvidia PATA is a disaster.  You're supposed to do some ACPI dancing
and drive side detection is completely bogus.  Eeeek....

Alan, did you have a chance to test the ACPI cable detection?  It just
didn't work when I tried it.  It always returned 80c on my machine.

-- 
tejun
