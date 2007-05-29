Return-Path: <linux-kernel-owner+w=401wt.eu-S1762772AbXE2OKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762772AbXE2OKg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 10:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750792AbXE2OK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 10:10:26 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:7607 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbXE2OKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 10:10:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=YHib9s6noxxp7zEW5ipaBRkHBTKCXXxHlvokLNRz4z5vPNyr9krWO0kx3JfKd+cZPx2Oe/1/dHo+1p/jgCBtghpqcALHDZBLNrRgzIat5ULAMatGilvJeJ80aCdjsGekV7bh/QH2NMKrFBiBPbOUfH6K+BvLmI8HlR/PJr/VdhY=
Message-ID: <465C3446.5020603@googlemail.com>
Date: Tue, 29 May 2007 16:10:14 +0200
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
CC: LKML <linux-kernel@vger.kernel.org>, lenb@kernel.org,
       us15@os.inf.tu-dresden.de, gregkh@suse.de, davej@redhat.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] reduce AER init error information
References: <1177832284.14017.270.camel@ymzhang>
In-Reply-To: <1177832284.14017.270.camel@ymzhang>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Zhang, Yanmin napisał(a):
> PCI-Express AER support in kernel requires BIOS to provide _OSC support
> to allow the AER Root port service driver to request for native control
> of AER. If a root port supports AER capablity, but BIOS doesn't provide
> _OSC for it, aerdriver will print many debug information to system console.
> Below is a log example.
> 
> *******************Error information example************
> Evaluate _OSC Set fails. Status = 0x0005
> Evaluate _OSC Set fails. Status = 0x0005
> aer_init: AER service init fails - Run ACPI _OSC fails
> aer: probe of 0000:00:02.0:pcie01 failed with error 2
> Evaluate _OSC Set fails. Status = 0x0005
> Evaluate _OSC Set fails. Status = 0x0005
> aer_init: AER service init fails - Run ACPI _OSC fails
> aer: probe of 0000:00:04.0:pcie01 failed with error 2
> Evaluate _OSC Set fails. Status = 0x0005
> Evaluate _OSC Set fails. Status = 0x0005
> aer_init: AER service init fails - Run ACPI _OSC fails
> aer: probe of 0000:00:06.0:pcie01 failed with error 2
> ******************End of Error information example******
> 
> 
> As _OSC is an optional capability of BIOS, such error information looks
> like overly-verbosed. The patch against kernel 2.6.21 changes it to just
> print one line report messages if aerdriver fails to attach the root port
> service device.
> 
> Below is an example of new output.
> AER service couldn't init device 0000:00:02.0:pcie01 - no _OSC support
> 
> 
> Signed-off-by: Zhang Yanmin <yanmin.zhang@intel.com>
> 
> ---
> 
[..]

This patch fixes a 2.6.21 regression. Please add this to the -stable and mainline queue.

Regards,
Michal

-- 
"Najbardziej brakowało mi twojego milczenia."
-- Andrzej Sapkowski "Coś więcej"
