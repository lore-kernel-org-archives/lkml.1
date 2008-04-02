Return-Path: <linux-kernel-owner+w=401wt.eu-S1757849AbYDBO7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757849AbYDBO7S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 10:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754729AbYDBO7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 10:59:09 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:25591 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754974AbYDBO7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 10:59:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=sJZIIly9KYHUs/lyAygThv5xz3ifTjyhEROIhkiZvFOiIobeTtsyES0i/r5zeZf6Bz/k0Npm+YhgL6TI6VN97k7pk4+z186we5zVLocibU4hDEo7he9x9VNe75vcjKnanYhpSmsc2e5V0FpTCGq9mSxod9FUY7owxgj3ds6Jtbk=
Date: Wed, 2 Apr 2008 10:59:00 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Yanko Kaneti <yaneti@declera.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Balaji Rao <balajirrao@gmail.com>, mingo@elte.hu,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.25-rc5.git4 regression PS/2 mouse not detected/working
Message-ID: <20080402105253.ZZRA012@mailhub.coreip.homeip.net>
References: <1205775229.25146.11.camel@indigo.declera.com> <20080317145429.ZZRA012@mailhub.coreip.homeip.net> <1205780323.25146.13.camel@indigo.declera.com> <20080318114711.ZZRA012@mailhub.coreip.homeip.net> <1207091851.3306.6.camel@d2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1207091851.3306.6.camel@d2>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yanko,

On Wed, Apr 02, 2008 at 02:17:31AM +0300, Yanko Kaneti wrote:
> On Tue, 2008-03-18 at 11:54 -0400, Dmitry Torokhov wrote:
> > On Mon, Mar 17, 2008 at 08:58:43PM +0200, Yanko Kaneti wrote:
> > > On Mon, 2008-03-17 at 14:55 -0400, Dmitry Torokhov wrote:
> > > > On Mon, Mar 17, 2008 at 07:33:49PM +0200, Yanko Kaneti wrote:
> > > > >
> > > > > My PS/2 mouse stops being detected between kernels 2.6.24.3-12.fc8 and
> > > > > 2.6.25-0.121.rc5.git4.fc9 (which I believe do not carry any patches in
> > > > > that area). Its an ASUS P5E-VM DO motherboard , bios revision 0506. The
> > > > > PS/2 keyboard still works.
> > > > > 
> > > > > Attached are both dmesg logs with i8042.debug=1, dmidecode, lspci -vvnn
> > > > > Tried i8042.noloop and both the mouse and keyboard stop working.
> > > > > 
> > > > 
> > > > Could you please send me dmesg from booting with i8042.noloop. I would
> > > > expect this option to help in your case so I am curious what went wrong.
> > > 
> > > Attached
> > > 
> > 
> > Hmm, it looks the kernel does the right thing in case of i8042.noloop,
> > except that it does not work :(. Kernel triest to query the mouse but
> > it does not respond.
> > 
> > Can you try taking contents of drivers/input/serio from 2.6.25 and
> > copy it in .24? It will most likely compile... If that works I'm
> > afraid I will ahve to ask you to do git biscect to find the offending
> > commit.
> 
> Hey again,
> 
> I finally did the bisecting. It found the cuplrit to be
> 
> commit e3f37a54f690d3e64995ea7ecea08c5ab3070faf
> Author: Balaji Rao <balajirrao@gmail.com>
> Date:   Wed Jan 30 13:30:03 2008 +0100
> 
>     x86: assign IRQs to HPET timers
>     
> 
> I tried reverting the change on the latest git with the attached patch
> and my mouse and keyboard appear to be detected and working fine now.
> The patch had to be stiched by hand and due to my lack of understanding
> of the code might be breaking random other stuff.
> 
> FWIW the bios on this board has no knobs for HPET that I could find.
> 
> What gives?
> 

Hmm, this is wierd and really outsize of my knowledge... Lets try copying
Ingo, Thomas and Balaji, maybe they can help us out here.

Btw, what is in your /proc/interrupts?

-- 
Dmitry
