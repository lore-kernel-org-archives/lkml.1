Return-Path: <linux-kernel-owner+w=401wt.eu-S1759506AbZAMNKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759506AbZAMNKc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 08:10:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754413AbZAMNKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 08:10:24 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:13853 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662AbZAMNKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 08:10:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tKcnJ25arkpf7cEmKRM8PRgn3Rh9TEk2SpEHPt4XRihbHn7/5hK/REY2Feet5Td2cl
         9Wb93n+kcYRjqkpFAk5e5nollf9vqpQu9Ox+1terOWdoApsvc3C6rHvQrP9KKakl7q7y
         oCVLMWIb8sBwyZdmZSKtL+EeoWgUVDlOQzWC8=
Date: Tue, 13 Jan 2009 16:10:20 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Subject: Re: [PATCH -tip] x86: headers - include linux/types.h instead of
	asm/types.h
Message-ID: <20090113131020.GD7682@localhost>
References: <20090113120905.GB7682@localhost> <20090113125705.GC7682@localhost> <20090113125928.GA31147@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090113125928.GA31147@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Tue, Jan 13, 2009 at 01:59:28PM +0100]
| 
| * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| 
| > [Cyrill Gorcunov - Tue, Jan 13, 2009 at 03:09:05PM +0300]
| > | Impact: cleanup
| > | 
| > | 'make headers_check' warns that linux/types.h is
| > | preferred over asm/types.h. So be it.
| > | 
| > | Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
| > | CC: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
| > | CC: Sam Ravnborg <sam@ravnborg.org>
| > | CC: Harvey Harrison <harvey.harrison@gmail.com>
| > | ---
| > | 
| > |  arch/x86/include/asm/e820.h       |    2 ++
| > |  arch/x86/include/asm/kvm.h        |    2 +-
| > |  arch/x86/include/asm/mce.h        |    2 +-
| > |  arch/x86/include/asm/mtrr.h       |    1 +
| > |  arch/x86/include/asm/ptrace-abi.h |    2 +-
| > |  arch/x86/include/asm/sigcontext.h |    2 +-
| > |  arch/x86/include/asm/swab.h       |    2 +-
| > |  7 files changed, 8 insertions(+), 5 deletions(-)
| > |
| > ...
| > 
| > well... on the other hand I'm not sure if it's really
| > a good idea to include linux/types.h where we need only
| > __u[8,16] and so on definitions.
| 
| Well, linux/types.h is supposed to be a 'lightweight', 'core data types 
| only' kind of header file, so including it is not wrong per se.
| 
| Sam, is there some other preferred way perhaps to resolve these?
| 
| 	Ingo
| 

Until such a file not passed to some *.S. For example for e820.h
we have it included to arch/x86/boot/header.S but fortunately
we're bound by __ASSEMBLY__. So there linux/types.h shouldn't hurt.
Will check others and report then.

		- Cyrill -
