Return-Path: <linux-kernel-owner+w=401wt.eu-S1758376AbYEWPU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758376AbYEWPU4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 11:20:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753655AbYEWPUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 11:20:49 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51618 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505AbYEWPUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 11:20:48 -0400
Subject: Re: [PATCH 1/3] firmware: allow firmware files to be built into
	kernel image
From: David Woodhouse <dwmw2@infradead.org>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: linux-kernel@vger.kernel.org, aoliva@redhat.com, alan@lxorguk.ukuu.org.uk,
       Abhay Salunke <Abhay_Salunke@dell.com>, kay.sievers@vrfy.org,
       Takashi Iwai <tiwai@suse.de>
In-Reply-To: <4836DBF3.1030307@ladisch.de>
References: <1211550282.28967.8.camel@pmac.infradead.org>
	 <4836DBF3.1030307@ladisch.de>
Content-Type: text/plain
Date: Fri, 23 May 2008 16:20:44 +0100
Message-Id: <1211556044.28967.32.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-05-23 at 17:00 +0200, Clemens Ladisch wrote:
> David Woodhouse wrote:
> > --- a/include/asm-generic/vmlinux.lds.h
> > +++ b/include/asm-generic/vmlinux.lds.h
> > +	/* Built-in firmware blobs */					\
> > +	.builtin_fw        : AT(ADDR(.builtin_fw) - LOAD_OFFSET) {	\
> > +		VMLINUX_SYMBOL(__start_builtin_fw) = .;			\
> > +		*(.builtin_fw)						\
> > +		VMLINUX_SYMBOL(__end_builtin_fw) = .;			\
> > +	}								\
> > +									\
> 
> Most drivers, when built as a module, would want their firmware images
> to be in the module and not in the kernel image.
> 
> This would require some (un)register_builtint_firmware() function.

If you're willing to build the driver as a module, surely you can use
the proper firmware loader too? We have MODULE_FIRMWARE to make sure
that the firmware ends up in the right place with it, after all.

-- 
dwmw2

