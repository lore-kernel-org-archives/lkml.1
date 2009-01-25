Return-Path: <linux-kernel-owner+w=401wt.eu-S1756060AbZAYRMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060AbZAYRMd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 12:12:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751923AbZAYRMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 12:12:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:44737 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609AbZAYRMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 12:12:21 -0500
Subject: Re: [PATCH 09/10] HID: add compat support
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>,
       Jiri Slaby <jirislaby@gmail.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org, marcel@holtmann.org,
       linux-kernel@vger.kernel.org, anssi.hannula@gmail.com, gregkh@suse.de,
       Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <alpine.LNX.1.10.0901251756200.5377@jikos.suse.cz>
References: <1210931362-18422-1-git-send-email-jirislaby@gmail.com>
	 <1210931362-18422-2-git-send-email-jirislaby@gmail.com>
	 <1210931362-18422-3-git-send-email-jirislaby@gmail.com>
	 <1210931362-18422-4-git-send-email-jirislaby@gmail.com>
	 <1210931362-18422-5-git-send-email-jirislaby@gmail.com>
	 <1210931362-18422-6-git-send-email-jirislaby@gmail.com>
	 <1210931362-18422-7-git-send-email-jirislaby@gmail.com>
	 <1210931362-18422-8-git-send-email-jirislaby@gmail.com>
	 <1210931362-18422-9-git-send-email-jirislaby@gmail.com>
	 <3f9a31f40901232155q7f898f00l9a1cf16ca6c8fb75@mail.gmail.com>
	 <alpine.LNX.1.10.0901251756200.5377@jikos.suse.cz>
Content-Type: text/plain
Date: Sun, 25 Jan 2009 22:41:38 +0530
Message-Id: <1232903498.10995.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-01-25 at 17:57 +0100, Jiri Kosina wrote:
> On Sat, 24 Jan 2009, Jaswinder Singh Rajput wrote:
> 
> > This leads to 3 headers_check warnings:
> > 
> >  usr/include/linux/hid.h:66: leaks CONFIG_HID to userspace where it is not valid
> >  usr/include/linux/hid.h:69: extern's make no sense in userspace
> >  usr/include/linux/hid.h:76: extern's make no sense in userspace
> > 
> > So I  am moving whole above block in #ifdef __KEREL__
> > 
> > If you have any objections, then let me know, now it will look like this:
> > 
> >  #endif /* HID_FF */
> > 
> > +#ifdef __KERNEL__
> >  #ifdef CONFIG_HID_COMPAT
> >  #define HID_COMPAT_LOAD_DRIVER(name)   \
> >  /* prototype to avoid sparse warning */        \
> > @@ -804,6 +805,7 @@ EXPORT_SYMBOL(hid_compat_##name)
> >         extern void hid_compat_##name(void);    \
> >         hid_compat_##name();                    \
> >  } while (0)
> > +#endif /* __KERNEL__ */
> > 
> >  #endif
> 
> Thanks for catching this. Could you please resend the patch to me, with 
> proper changelog and Signed-off-by: line? Thanks.
> 

I have already send the patchset to Ingo "Re: [GIT PULL -tip] fix 22
make headers_check - 200901" and I also CCed to you jirislaby@gmail.com

--
JSR

