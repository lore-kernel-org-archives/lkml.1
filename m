Return-Path: <linux-kernel-owner+w=401wt.eu-S1755987AbZAYQ5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987AbZAYQ5W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 11:57:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751923AbZAYQ5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 11:57:13 -0500
Received: from styx.suse.cz ([82.119.242.94]:47269 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751839AbZAYQ5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 11:57:12 -0500
Date: Sun, 25 Jan 2009 17:57:10 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
cc: Jiri Slaby <jirislaby@gmail.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org, marcel@holtmann.org,
       linux-kernel@vger.kernel.org, anssi.hannula@gmail.com, gregkh@suse.de,
       Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 09/10] HID: add compat support
In-Reply-To: <3f9a31f40901232155q7f898f00l9a1cf16ca6c8fb75@mail.gmail.com>
Message-ID: <alpine.LNX.1.10.0901251756200.5377@jikos.suse.cz>
References: <1210931362-18422-1-git-send-email-jirislaby@gmail.com>  <1210931362-18422-2-git-send-email-jirislaby@gmail.com>  <1210931362-18422-3-git-send-email-jirislaby@gmail.com>  <1210931362-18422-4-git-send-email-jirislaby@gmail.com> 
 <1210931362-18422-5-git-send-email-jirislaby@gmail.com>  <1210931362-18422-6-git-send-email-jirislaby@gmail.com>  <1210931362-18422-7-git-send-email-jirislaby@gmail.com>  <1210931362-18422-8-git-send-email-jirislaby@gmail.com> 
 <1210931362-18422-9-git-send-email-jirislaby@gmail.com> <3f9a31f40901232155q7f898f00l9a1cf16ca6c8fb75@mail.gmail.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Jan 2009, Jaswinder Singh Rajput wrote:

> This leads to 3 headers_check warnings:
> 
>  usr/include/linux/hid.h:66: leaks CONFIG_HID to userspace where it is not valid
>  usr/include/linux/hid.h:69: extern's make no sense in userspace
>  usr/include/linux/hid.h:76: extern's make no sense in userspace
> 
> So I  am moving whole above block in #ifdef __KEREL__
> 
> If you have any objections, then let me know, now it will look like this:
> 
>  #endif /* HID_FF */
> 
> +#ifdef __KERNEL__
>  #ifdef CONFIG_HID_COMPAT
>  #define HID_COMPAT_LOAD_DRIVER(name)   \
>  /* prototype to avoid sparse warning */        \
> @@ -804,6 +805,7 @@ EXPORT_SYMBOL(hid_compat_##name)
>         extern void hid_compat_##name(void);    \
>         hid_compat_##name();                    \
>  } while (0)
> +#endif /* __KERNEL__ */
> 
>  #endif

Thanks for catching this. Could you please resend the patch to me, with 
proper changelog and Signed-off-by: line? Thanks.

-- 
Jiri Kosina
SUSE Labs
