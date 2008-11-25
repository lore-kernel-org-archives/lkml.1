Return-Path: <linux-kernel-owner+w=401wt.eu-S1753190AbYKYPal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190AbYKYPal (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 10:30:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751550AbYKYPac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 10:30:32 -0500
Received: from wf-out-1314.google.com ([209.85.200.173]:57139 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbYKYPab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 10:30:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=NqvebWsnUFbglqyCilMkWhQv8NsGnOor0swNK9yMK9TU+KEXxCL3bRhHpgyZQ2D+xQ
         tY2/dck56Fek1cl5JvMK7yVu+R4G52r+x6ddctxhYFB3ijoVjybA6HTwaxyK9I22ejd7
         IkJ4BEMYxZE6oX/qOTJoxSJYK16+5kbdKEV0o=
Date: Wed, 26 Nov 2008 00:30:25 +0900
From: Hitoshi Mitake <h.mitake@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Luck, Tony" <tony.luck@intel.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Ralf Baechle <ralf@linux-mips.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Doug Thompson <norsk5@yahoo.com>,
       "dougthompson@xmission.com" <dougthompson@xmission.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: Re: [PATCH 1/1] edac x38: new MC driver module
Message-Id: <20081126003025.85f19670.h.mitake@gmail.com>
In-Reply-To: <492B8996.2020302@zytor.com>
References: <20081105222911.d76e7e1c.mitake@clustcom.com>
	<413709.12821.qm@web50106.mail.re2.yahoo.com>
	<20081106164641.ed369060.akpm@linux-foundation.org>
	<20081107152830.a42766f3.mitake@clustcom.com>
	<20081106223122.8a255211.akpm@linux-foundation.org>
	<20081107153824.0ec934e6.mitake@clustcom.com>
	<20081106231102.aab83cd4.akpm@linux-foundation.org>
	<a6b9f31a0811090710y17e956bawf20675d6678b145e@mail.gmail.com>
	<20081109112646.97c594b5.akpm@linux-foundation.org>
	<20081118121620.GB8625@linux-mips.org>
	<20081118123215.GB30509@flint.arm.linux.org.uk>
	<20081121011941.26e05a25.h.mitake@gmail.com>
	<4929ECB7.8080108@zytor.com>
	<57C9024A16AD2D4C97DC78E552063EA35C517F42@orsmsx505.amr.corp.intel.com>
	<492AEC40.5060009@zytor.com>
	<20081125115510.108fa886.h.mitake@gmail.com>
	<492B8996.2020302@zytor.com>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Nov 2008 21:13:58 -0800
"H. Peter Anvin" <hpa@zytor.com> wrote:

> Hitoshi Mitake wrote:
> > I think which need __ is variable type name, not each variable name.
> > Name of each local variables can't effect namespace.
> 
> Wrong.  It affects the namespace in the sense that it can interfere with
> user-created macros.  Again, this is only an issue for user space.

Sorry, I've misunderstood. I didn't think about macros.

> 
> > And I found this comment in asm-generic/int-ll64.h,
> > /*
> >  * __xx is ok: it doesn't pollute the POSIX namespace. Use these in the
> >  * header files exported to user space
> >  */
> > 
> > According to your advice, I rewrote the patch, how is this?
> 
> Are you planning to add writeq() as well?
> 

Yes, I want to add writeq().
But there's a problem that
I don't have a plan to use writeq() now, so I can't test writeq() soon.

How is this? I think it isn't bad. I want to hear your opinion.

static inline void writeq(__u64 val, volatile void __iomem *addr)
{
	writel((unsigned int)val, addr);
	writel((unsigned int)(val >> 32), addr+1);
}

