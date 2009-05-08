Return-Path: <linux-kernel-owner+w=401wt.eu-S1763373AbZEHRHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763373AbZEHRHr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 13:07:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753758AbZEHRHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 13:07:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58590 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596AbZEHRHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 13:07:37 -0400
Message-ID: <4A0465E6.9000401@zytor.com>
Date: Fri, 08 May 2009 10:03:34 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
       vgoyal@redhat.com, hbabu@us.ibm.com, kexec@lists.infradead.org,
       ying.huang@intel.com, mingo@elte.hu, tglx@linutronix.de,
       ebiederm@xmission.com, sam@ravnborg.org
Subject: Re: [PATCH 01/14] x86, boot: align the .bss section in the	decompressor
References: <1241735222-6640-1-git-send-email-hpa@linux.intel.com> <1241735222-6640-2-git-send-email-hpa@linux.intel.com> <20090508075354.GA6132@lenovo>
In-Reply-To: <20090508075354.GA6132@lenovo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> | 
> | diff --git a/arch/x86/boot/compressed/vmlinux.lds.S b/arch/x86/boot/compressed/vmlinux.lds.S
> | index 0d26c92..27c168d 100644
> | --- a/arch/x86/boot/compressed/vmlinux.lds.S
> | +++ b/arch/x86/boot/compressed/vmlinux.lds.S
> | @@ -42,6 +42,7 @@ SECTIONS
> |  		*(.data.*)
> |  		_edata = . ;
> |  	}
> | +	. = ALIGN(32);
> |  	.bss : {
> |  		_bss = . ;
> |  		*(.bss)
> | -- 
> | 1.6.0.6
> | 
> 
> Hi Peter, should not it be ALIGN(8) rather? I thought
> we keep these sections as tight as possible in a sake
> of limitation of setup code size. Perhaps I miss something.
> 

This isn't the setup code at all.  This is the actual kernel, although
in its compressed form.  Furthermore, this is the bss, so it doesn't
affect the compressed image size.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

