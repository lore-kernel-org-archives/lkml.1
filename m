Return-Path: <linux-kernel-owner+w=401wt.eu-S1760479AbZEHRQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760479AbZEHRQS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 13:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753606AbZEHRQD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 13:16:03 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:37629 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323AbZEHRQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 13:16:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HQZS4UkWenmyflqCt7j6TSQYXSu8711yljr3EyRQkBs6Wu/X5UlTNZPqQmo9yrQ4mp
         GwrLJk9G6Llq5lC5oUASkauwbA98hZCgbpDAjHDeWMpNtGQiHhiMNpJp2gq6sdJjoYCI
         xXWqY4af5aSds3SLel+9afsX6SgIHMKH1TNfI=
Date: Fri, 8 May 2009 21:15:56 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
       vgoyal@redhat.com, hbabu@us.ibm.com, kexec@lists.infradead.org,
       ying.huang@intel.com, mingo@elte.hu, tglx@linutronix.de,
       ebiederm@xmission.com, sam@ravnborg.org
Subject: Re: [PATCH 01/14] x86, boot: align the .bss section in the
	decompressor
Message-ID: <20090508171556.GN6132@lenovo>
References: <1241735222-6640-1-git-send-email-hpa@linux.intel.com> <1241735222-6640-2-git-send-email-hpa@linux.intel.com> <20090508075354.GA6132@lenovo> <4A0465E6.9000401@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A0465E6.9000401@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[H. Peter Anvin - Fri, May 08, 2009 at 10:03:34AM -0700]
| Cyrill Gorcunov wrote:
| > | 
| > | diff --git a/arch/x86/boot/compressed/vmlinux.lds.S b/arch/x86/boot/compressed/vmlinux.lds.S
| > | index 0d26c92..27c168d 100644
| > | --- a/arch/x86/boot/compressed/vmlinux.lds.S
| > | +++ b/arch/x86/boot/compressed/vmlinux.lds.S
| > | @@ -42,6 +42,7 @@ SECTIONS
| > |  		*(.data.*)
| > |  		_edata = . ;
| > |  	}
| > | +	. = ALIGN(32);
| > |  	.bss : {
| > |  		_bss = . ;
| > |  		*(.bss)
| > | -- 
| > | 1.6.0.6
| > | 
| > 
| > Hi Peter, should not it be ALIGN(8) rather? I thought
| > we keep these sections as tight as possible in a sake
| > of limitation of setup code size. Perhaps I miss something.
| > 
| 
| This isn't the setup code at all.  This is the actual kernel, although
| in its compressed form.  Furthermore, this is the bss, so it doesn't
| affect the compressed image size.
| 
| 	-hpa
| 

yeah, unfortunately I reveal that when my mail already gone.
though I don't understand why 32 is there... could you please?

	-- Cyrill
