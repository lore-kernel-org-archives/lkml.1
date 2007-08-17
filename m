Return-Path: <linux-kernel-owner+w=401wt.eu-S1758819AbXHQV36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758819AbXHQV36 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 17:29:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759614AbXHQV3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 17:29:35 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:24230 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758898AbXHQV3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 17:29:34 -0400
X-IronPort-AV: i="4.19,277,1183348800"; 
   d="scan'208"; a="48705938:sNHT35983360"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Mike Frysinger" <vapier.adi@gmail.com>
Subject: Re: Early printk behaviour
Date: Fri, 17 Aug 2007 17:29:33 -0400
User-Agent: KMail/1.9.5
Cc: "Gerd Hoffmann" <kraxel@redhat.com>, linux-kernel@vger.kernel.org
References: <200708152234.06734.rgetz@blackfin.uclinux.org> <200708171700.29647.rgetz@blackfin.uclinux.org> <8bd0f97a0708171409l39166daep185e89438f4104f0@mail.gmail.com>
In-Reply-To: <8bd0f97a0708171409l39166daep185e89438f4104f0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708171729.33621.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 17 Aug 2007 21:29:32.0946 (UTC) FILETIME=[B3BD9F20:01C7E115]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 17 Aug 2007 17:09, Mike Frysinger pondered:
> On 8/17/07, Robin Getz <rgetz@blackfin.uclinux.org> wrote:
> >
> > Something like:
> >
> > Index: kernel/printk.c
> > ===================================================================
> > --- kernel/printk.c     (revision 3568)
> > +++ kernel/printk.c     (working copy)
> > @@ -1104,6 +1104,22 @@
> >  }
> >  EXPORT_SYMBOL(unregister_console);
> >
> > +int __init disable_boot_consoles(void)
> > +{
> > +       struct console *con;
> > +
> > +       for (con = console_drivers; con; con = con->next) {
> > +               if (con->flags & CON_BOOT) {
> > +                       printk(KERN_INFO "Unregister BootConsole %s%d\n",
> > +                               con->name, con->index);
> > +                       unregister_console(con);
> > +               }
> > +       }
> > +       return 0;
> > +}
> > +late_initcall(disable_boot_consoles);
> 
> is there any need for a return value then ?
> void __init disable_boot_consoles(void);

So, we don't get compiler warnings?

Otherwise:
kernel/printk.c:1119: warning: initialization from incompatible pointer type

> and if we dont think anyone else wants to call it ...
> static void __init disable_boot_consoles(void);

So I think static is Ok, but it needs to be int - that is the proper prototype

-Robin
