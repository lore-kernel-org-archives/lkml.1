Return-Path: <linux-kernel-owner+w=401wt.eu-S1754752AbYCOVG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752AbYCOVG5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 17:06:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752732AbYCOVGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 17:06:45 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:58031 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754401AbYCOVGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 17:06:33 -0400
Message-Id: <1205615192.29139.1242596503@webmail.messagingengine.com>
X-Sasl-Enc: U0vUiVhxmsYXdVw/JVqXl+AZPuAfw7BsOZwyLe0Mcq6V 1205615192
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "H. Peter Anvin" <hpa@zytor.com>,
       "Alexander van Heukelum" <heukelum@mailshack.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andi Kleen" <andi@firstfloor.org>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "LKML" <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <20080312200128.GA24983@mailshack.com> <47DABEFB.3050704@goop.org>
   <1205523826.7441.1242464129@webmail.messagingengine.com>
   <20080314195520.GV2522@one.firstfloor.org>
   <1205530409.27413.1242484373@webmail.messagingengine.com>
   <20080315191946.GA21817@mailshack.com> <47DC2F08.9080004@zytor.com>
Subject: Re: K8, EFFICEON and CORE2 support the cmovxx instructions.
In-Reply-To: <47DC2F08.9080004@zytor.com>
Date: Sat, 15 Mar 2008 22:06:32 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Mar 2008 21:18:16 +0100, "H. Peter Anvin" <hpa@zytor.com>
said:
> Alexander van Heukelum wrote:
> > K8, EFFICEON and CORE2 support the cmovxx instructions.
> > 
> > Instead of listing the cpu's that have support for the
> > cmovxx instructions, list the cpu's that don't.
> > 
> > Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
> > ---
> > 
> > A bit of playing resulted in:
> > 
> > CPUS="M386 M486 M586 M586TSC M586MMX M686 MPENTIUMII MPENTIUMIII"
> > CPUS=$CPUS" MPENTIUMM MPENTIUM4 MK6 MK7 MK8 MCRUSOE MEFFICEON"
> > CPUS=$CPUS" MWINCHIPC6 MWINCHIP2 MWINCHIP3D MGEODEGX1 MGEODE_LX"
> > CPUS=$CPUS" MCYRIXIII MVIAC3_2 MVIAC7 MPSC MCORE2"
> > 
> > for cpu in $CPUS
> > do
> >         echo "CONFIG_${cpu}=y" > testconfig
> >         make ARCH=i386 allnoconfig KCONFIG_ALLCONFIG=testconfig > /dev/null
> >         echo ${cpu} >> result
> >         grep X86_CMOV .config >> result
> >         echo >> result
> > done
> > 
> > I'm quite sure that K8, EFFICEON and CORE2 support HAVE_CMOV, but
> > they did not set X86_CMOV.
> > 
> 
> Crusoe has CMOV as well.

Hi hpa,

I believe you... and the Makefile_32.cpu: it gets a -march=i686. I
also found out that I missed X86_ELAN, which is treated as a i486.

Also, MGEODE_LX does not get any optimization flags. I think that
is unintentional, but what should they be?

And MPSC (Intel P4 / older Netburst based Xeon) depends on X86_64.
I would be very surprised if that one could not run 32-bit code,
though. What flags should that one get?

Thanks for pointing out I missed Crusoe. As a punishment you
can answer my questions ;).

Greetings,
    Alexander
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - Send your email first class

