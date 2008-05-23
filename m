Return-Path: <linux-kernel-owner+w=401wt.eu-S1757563AbYEWQUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757563AbYEWQUb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 12:20:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750891AbYEWQUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 12:20:24 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:43209 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846AbYEWQUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 12:20:23 -0400
Date: Fri, 23 May 2008 18:21:01 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, aoliva@redhat.com, alan@lxorguk.ukuu.org.uk,
       Abhay Salunke <Abhay_Salunke@dell.com>, kay.sievers@vrfy.org,
       Haroldo Gamal <gamal@alternex.com.br>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH 1/3] firmware: allow firmware files to be built into kernel image
Message-ID: <20080523162101.GA31107@uranus.ravnborg.org>
References: <1211550282.28967.8.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1211550282.28967.8.camel@pmac.infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David.

> +extern struct builtin_fw __start_builtin_fw[];
> +extern struct builtin_fw __end_builtin_fw[];

Could have these in include/linux/sections.h where we
collect other linker symbols?

> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index f054778..8d71a40 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -86,6 +86,13 @@
>  		VMLINUX_SYMBOL(__end_pci_fixups_resume) = .;		\
>  	}								\
>  									\
> +	/* Built-in firmware blobs */					\
> +	.builtin_fw        : AT(ADDR(.builtin_fw) - LOAD_OFFSET) {	\
> +		VMLINUX_SYMBOL(__start_builtin_fw) = .;			\
> +		*(.builtin_fw)						\
> +		VMLINUX_SYMBOL(__end_builtin_fw) = .;			\
> +	}								\
> +									\
Looks good.
But do we need the firmware after init?
In other owrds could it be inside a discard after init block?


> +
> +#define DECLARE_BUILTIN_FIRMWARE_SIZE(name, blob, size)			     \
> +	static const struct builtin_fw __fw_concat(__builtin_fw,__COUNTER__) \
> +	__used __attribute__((__section__(".builtin_fw"))) =		     \

Use __section():

> +	__used __section(.builtin_fw))) =		     \
(See compiler.h IIRC).

	Sam
