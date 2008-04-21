Return-Path: <linux-kernel-owner+w=401wt.eu-S1754844AbYDUEyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844AbYDUEyq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 00:54:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751383AbYDUEyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 00:54:39 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:37685 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbYDUEyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 00:54:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JgMFA4QG3UIJe+u5WGzEGd63lOqYHsl6o1vUNIDKCJ2jwDU+f2JoHT2qdX6eMod+aqIbFDUzwvZhygDcjSWO6lQ6ty6E5pvbR76C3CRuANBONi0m2syXGGqt6kuNlU8k4nTbI+KmqS4jtUijL6ksTrtZJm1VmGiEvdmalfeTq8c=
Message-ID: <86802c440804202154t184671d5t33b44fffc4d88cd5@mail.gmail.com>
Date: Sun, 20 Apr 2008 21:54:13 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Mitch Bradley" <wmb@firmworks.com>
Subject: Re: [PATCH 1/2] OLPC: Add support for calling into Open Firmware
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Andres Salomon" <dilinger@queued.net>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Joseph Fannin" <jfannin@gmail.com>, linux-kernel@vger.kernel.org,
       jordan.crouse@amd.com
In-Reply-To: <480C0C5B.2050403@firmworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080418014757.52fb4a4f.akpm@linux-foundation.org>
	 <20080418202925.b18452c5.akpm@linux-foundation.org>
	 <20080419092544.378664a8@ephemeral>
	 <20080419133909.5aa6b63e@ephemeral>
	 <86802c440804200334t5cdcd100rfc41e9b1bf379109@mail.gmail.com>
	 <480B321B.5020802@zytor.com> <20080420135948.61bdb4c9@ephemeral>
	 <480B8E9F.8000701@firmworks.com> <480B95B4.5030203@zytor.com>
	 <480C0C5B.2050403@firmworks.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 20, 2008 at 8:39 PM, Mitch Bradley <wmb@firmworks.com> wrote:
>
> H. Peter Anvin wrote:
>
> > Mitch Bradley wrote:
> >
> > >
> > > The x86 architecture doesn't make this problem easy.
> > >
> > >
> >
> > [long rant about the x86 architecture]
> >
> > It would be more useful if you described the actual defined entry
> conditions from OpenFirmware look like, including if they are well-defined
> for all OF implementations or only for OLPC.
> >
> >    -hpa
> >
>
>  Fair enough...
>
>  To get the second subquestion out of the way:  At the present time, on the
> x86 architecture, "all OF implementations" and "OLPC" are effectively the
> same.  I am unaware of any other x86 OFW deployments in current use.  There
> have been some in the past, on bespoke systems such as Network Appliance
> servers and at least one settop box, but those have fallen by the wayside as
> those companies have shifted over to commodity PC hardware.  The current
> market status quo is that x86 boards are primarily designed for Windows, and
> thus must run legacy BIOS, with some recent migration to EFI, neither of
> which are open source in the strong sense.  While I would like to see more
> OFW penetration into the larger x86 market, I don't really expect it.  x86
> motherboard manufacturing is becoming more and more difficult as signal
> speeds increase, leading to a decline in the number of manufacturers.  The
> existing manufacturers depend on Windows for sales volume and their internal
> procedures and working knowledge are based on legacy BIOS.
>
>  Once upon a time, we had an OFW "binding" document that stipulated the
> interface conditions, with the intention of making that "standard" across
> all OFW-on-x86 systems.  However, by the time OLPC came around, there were
> no other systems to consider, so I felt free to make some changes in the
> interface.  I ended up choosing an ABI that resulted in a simple (in the
> sense of not much code, and no complex state transitions) interface with 2.6
> Linux kernels.
>
>  The interface defined below is not inherently OLPC-specific - it would be
> suitable for any ia32 system that used OFW.  (At a higher level, the set of
> OFW callback functions is architecture-neutral; in this message I am
> focusing on the very low-level details of the ia32 ABI)
>
>  The system conditions for the OFW to Linux kernel transition are as
> follows:
>
>  a) OFW can load the Linux kernel from either bzimage format or ELF format
> (either uncompressed or zlib-compressed.)  If the kernel is in ELF format
> with symbols, OFW can do symbolic kernel debugging.  Further discussion will
> focus on bzimage format, as that is what OLPC uses and is also the "greased
> path" for kernel builds.
>
>  b) OFW loads the bzimage kernel at 0x100000 and the ramdisk image, if any,
> at 0x800000.

so you are assuming that your uncompressed vmlinux only use less 8M space?

you are supposed to check the bzImage to get uncompressed vmlinux size.

YH
