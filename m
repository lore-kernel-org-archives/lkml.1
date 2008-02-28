Return-Path: <linux-kernel-owner+w=401wt.eu-S1757715AbYB1IDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757715AbYB1IDj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 03:03:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753062AbYB1IDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 03:03:30 -0500
Received: from ti-out-0910.google.com ([209.85.142.189]:21157 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660AbYB1ID3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 03:03:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DQCrOoSMPvO+w0hqCHYhpNvKBniOFAUhZGM4bx2CeeVcJGh+3zXLR4wVj/Iah2x0KIjCD2coY6N9vTLUC0tMoGj77UzdseWaAXivxJwhfpv3cM6NoCca/CnbkDSF3WugvjybaAMtlw4pw1ufp+QAZZDDbtunVM7h/TrKGBDcZ6k=
Message-ID: <a8e1da0802280003j76a55421q9bb4aeb70b03f30f@mail.gmail.com>
Date: Thu, 28 Feb 2008 16:03:22 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: boot_delay broken ?
Cc: akpm <akpm@linux-foundation.org>, "Dave Jones" <davej@codemonkey.org.uk>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <a8e1da0802261801m4bd05b32rc8e97bc0f83773ff@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080224004615.GA31012@codemonkey.org.uk>
	 <a8e1da0802241814x48e169f2v82823c55412fc534@mail.gmail.com>
	 <20080225212251.18c4659e.randy.dunlap@oracle.com>
	 <a8e1da0802252148p43d7b899t25ed0a9f994fae35@mail.gmail.com>
	 <a8e1da0802252159u2dc21fc3vbd8a4e0f7e31b471@mail.gmail.com>
	 <20080226090948.GA2794@darkstar.te-china.tietoenator.com>
	 <20080226093323.71ae516b.randy.dunlap@oracle.com>
	 <a8e1da0802261801m4bd05b32rc8e97bc0f83773ff@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2008 at 10:01 AM, Dave Young <hidave.darkstar@gmail.com> wrote:
>
> On Wed, Feb 27, 2008 at 1:33 AM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>  >
>  > On Tue, 26 Feb 2008 17:09:48 +0800 Dave Young wrote:
>  >
>  >  > On Tue, Feb 26, 2008 at 01:59:31PM +0800, Dave Young wrote:
>  >  > > On Tue, Feb 26, 2008 at 1:48 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
>  >  > > > On Tue, Feb 26, 2008 at 1:22 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>  >  > > >  > On Mon, 25 Feb 2008 10:14:36 +0800 Dave Young wrote:
>  >  > > >  >
>  >  > > >  >  > On Sun, Feb 24, 2008 at 8:46 AM, Dave Jones <davej@codemonkey.org.uk> wrote:
>  >  > > >  >  > > The boot_delay switch seems to be behaving strangely in the
>  >  > > >  >  > >  current -git.  Setting it to =10 makes the output 'bursty'
>  >  > > >  >  > >  it becomes slow for some printk's whilst others scroll by
>  >  > > >  >  > >  at regular speed.
>  >  > > >  >  > >  Setting it any higher than that seems to make it pause for
>  >  > > >  >  > >  a really long time before it outputs any text at all.
>  >  > > >  >  >
>  >  > > >  >  > On my side there's this issue for a long time
>  >  > > >  >  > http://lkml.org/lkml/2007/8/8/79
>  >  > > >  >
>  >  > > >  >  [http://marc.info/?l=linux-kernel&m=118655896515049&w=2]
>  >  > > >  >
>  >  > > >  >  You asked questions and they were answered.  Perhaps you didn't like
>  >  > > >  >  the answers.
>  >  > > >
>  >  > > >  No, I like it.  Thanks.
>  >  > > >
>  >  > > >  But I still want to know why mdelay can not be used.
>  >  > > >  is it not available for all archs or something else?
>  >  > > >
>  >  > > >
>  >  > > >  >
>  >  > > >  >  Here's a question for you.  What kernel boot options did you use?
>  >  > > >  >  Specifically, for lpj= and boot_delay= ?
>  >  > > >
>  >  > > >  I tried boot_delay=100 and boot_delay=200 without lpj set, The result
>  >  > > >  was really slow. It was better with lpj copied from dmesg, but was
>  >  > > >  still slower then mdelay.
>  >  > >
>  >  > > Especially at the very beginning after the message "Booting the kernel",
>  >  > > I need to wait several minutes to see the afterwards messages

Answer to myself : It's due to the first delayed printk.

>  >  > >
>  >  > > >
>  >  > > >  I think we can firstly use preset lpj, after delay calibrating just
>  >  > > >  use the system lpj
>  >  > > >
>  >  > > >
>  >  > > >
>  >  > > >  >
>  >  > > >  >  > >
>  >  > > >  >  > >  x86 timer changes perhaps ?
>  >  > > >  >
>  >  > > >  >
>  >  > > >  >  ---
>  >  > > >  >  ~Randy
>  >  > > >  >
>  >  > > >
>  >  >
>  >  > How about use loops_per_jiffy as following? With this patch at least
>  >  > for me the very long delay at the very begining does not occur.

It does impoving the code, but does not resolve problem here.

It looks ok because the loops_per_jiffy initial value is 4096, with
this value the delay result is much better than with values copied
from calibrated results.

BTW, Pavel's suggest (nohz=off highres=off notsc) does not help me.

>  >  >
>  >  > kernel/printk.c |   15 ++++-----------
>  >  > 1 file changed, 4 insertions(+), 11 deletions(-)
>  >  >
>  >  > diff -upr linux/kernel/printk.c linux.new/kernel/printk.c
>  >  > --- linux/kernel/printk.c     2008-02-26 16:54:23.000000000 +0800
>  >  > +++ linux.new/kernel/printk.c 2008-02-26 16:59:02.000000000 +0800
>  >  > @@ -173,24 +173,14 @@ __setup("log_buf_len=", log_buf_len_setu
>  >  >  #ifdef CONFIG_BOOT_PRINTK_DELAY
>  >  >
>  >  >  static unsigned int boot_delay; /* msecs delay after each printk during bootup */
>  >  > -static unsigned long long printk_delay_msec; /* per msec, based on boot_delay */
>  >  >
>  >  >  static int __init boot_delay_setup(char *str)
>  >  >  {
>  >  > -     unsigned long lpj;
>  >  > -     unsigned long long loops_per_msec;
>  >  > -
>  >  > -     lpj = preset_lpj ? preset_lpj : 1000000;        /* some guess */
>  >  > -     loops_per_msec = (unsigned long long)lpj / 1000 * HZ;
>  >  > -
>  >  >       get_option(&str, &boot_delay);
>  >  >       if (boot_delay > 10 * 1000)
>  >  >               boot_delay = 0;
>  >  >
>  >  > -     printk_delay_msec = loops_per_msec;
>  >  > -     printk(KERN_DEBUG "boot_delay: %u, preset_lpj: %ld, lpj: %lu, "
>  >  > -             "HZ: %d, printk_delay_msec: %llu\n",
>  >  > -             boot_delay, preset_lpj, lpj, HZ, printk_delay_msec);
>  >  > +     printk(KERN_DEBUG "boot_delay: %u\n", boot_delay);
>  >  >       return 1;
>  >  >  }
>  >  >  __setup("boot_delay=", boot_delay_setup);
>  >  > @@ -199,6 +189,9 @@ static void boot_delay_msec(void)
>  >  >  {
>  >  >       unsigned long long k;
>  >  >       unsigned long timeout;
>  >  > +     unsigned long long printk_delay_msec;
>  >  > +
>  >  > +     printk_delay_msec = (unsigned long long)loops_per_jiffy / 1000 * HZ;
>  >  >
>  >  >       if (boot_delay == 0 || system_state != SYSTEM_BOOTING)
>  >  >               return;
>  >  > --
>  >
>  >  Hi Dave,
>  >
>  >  That might work, but IMO it requires someone to audit all
>  >  architectures to make sure that loops_per_jiffy has been calibrated
>  >  at that point in time
>  >(as I mentioned in http://lkml.org/lkml/2007/8/11/153).
>
>  Sorry for missing your words about this.
>
>
>  >
>  >  I didn't do that and you said that you tested i386 only.
>  >
>  >  Maybe you can get Andrew to merge it into -mm for testing...
>
>  Andrew, what's your opinon?
>
>
>  >
>  >  However, setting boot_delay=N without setting lpj=M is just not
>  >  advisable.  The Kconfig help text for BOOT_PRINTK_DELAY tries to
>  >  say that.  Maybe it needs to be stronger?
>
>  I think it's enough now.
>
>  I tested boot_delay yestoday, and found the result is different with
>  before version.
>  Even with lpj preset the delay is very slow, 5-10 seconds for every printk.
>  Maybe this is what davej said.
>
>  I will do some more test and hack about this today.
>
>
>
>  >
>  >           It is likely that you would also need to use "lpj=M" to preset
>  >           the "loops per jiffie" value.
>  >           See a previous boot log for the "lpj" value to use for your
>  >           system, and then set "lpj=M" before setting "boot_delay=N".
>  >
>  >
>  >  ---
>  >  ~Randy
>  >
>
