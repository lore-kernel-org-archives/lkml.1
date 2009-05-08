Return-Path: <linux-kernel-owner+w=401wt.eu-S1761384AbZEHHyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761384AbZEHHyR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 03:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752422AbZEHHyB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 03:54:01 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:7963 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756104AbZEHHyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 03:54:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=e/cLO2qeD1VKBy7BUuqpRM9LmJmnYcXFtYyzAD75tKov68wcZV5HOJ2YwAKQ9BSBl2
         wwD+1+6Zb/gfZIbCjOyHzvniKb9oeAEfiEUvvDQaBeXSitzgI2MWJiV3G1NnEzCvY8t8
         nB9aZEc5xdpDNsgkHjaxNiTyWayhzu7QT0z+M=
Date: Fri, 8 May 2009 11:53:54 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, vgoyal@redhat.com, hbabu@us.ibm.com,
       kexec@lists.infradead.org, ying.huang@intel.com, mingo@elte.hu,
       tglx@linutronix.de, ebiederm@xmission.com, sam@ravnborg.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 01/14] x86, boot: align the .bss section in the
	decompressor
Message-ID: <20090508075354.GA6132@lenovo>
References: <1241735222-6640-1-git-send-email-hpa@linux.intel.com> <1241735222-6640-2-git-send-email-hpa@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241735222-6640-2-git-send-email-hpa@linux.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[H. Peter Anvin - Thu, May 07, 2009 at 03:26:49PM -0700]
| From: H. Peter Anvin <hpa@zytor.com>
| 
| Aligning the .bss section makes it trivially faster, and makes using
| larger transfers for the clear slightly easier.
| 
| [ Impact: trivial performance enhancement, future patch prep ]
| 
| Signed-off-by: H. Peter Anvin <hpa@zytor.com>
| ---
|  arch/x86/boot/compressed/vmlinux.lds.S |    1 +
|  1 files changed, 1 insertions(+), 0 deletions(-)
| 
| diff --git a/arch/x86/boot/compressed/vmlinux.lds.S b/arch/x86/boot/compressed/vmlinux.lds.S
| index 0d26c92..27c168d 100644
| --- a/arch/x86/boot/compressed/vmlinux.lds.S
| +++ b/arch/x86/boot/compressed/vmlinux.lds.S
| @@ -42,6 +42,7 @@ SECTIONS
|  		*(.data.*)
|  		_edata = . ;
|  	}
| +	. = ALIGN(32);
|  	.bss : {
|  		_bss = . ;
|  		*(.bss)
| -- 
| 1.6.0.6
| 

Hi Peter, should not it be ALIGN(8) rather? I thought
we keep these sections as tight as possible in a sake
of limitation of setup code size. Perhaps I miss something.

	-- Cyrill
