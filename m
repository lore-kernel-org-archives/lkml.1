Return-Path: <linux-kernel-owner+w=401wt.eu-S1762642AbXEPF3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762642AbXEPF3l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 01:29:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760068AbXEPF3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 01:29:35 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:35773
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757252AbXEPF3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 01:29:34 -0400
From: Rob Landley <rob@landley.net>
To: Dave Jones <davej@redhat.com>
Subject: Re: Weird hard disk noise on shutdown (bug #7674)
Date: Wed, 16 May 2007 01:29:15 -0400
User-Agent: KMail/1.9.1
Cc: Tejun Heo <htejun@gmail.com>, Francesco Pretto <ceztko@gmail.com>,
       Phillip Susi <psusi@cfl.rr.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <fa.Ia7dfo7Zd5kB6KhSYisfswa1aj4@ifi.uio.no> <46489D3B.8050805@gmail.com> <20070515210804.GG25902@redhat.com>
In-Reply-To: <20070515210804.GG25902@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705160129.16048.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 May 2007 5:08 pm, Dave Jones wrote:
> On Mon, May 14, 2007 at 07:32:43PM +0200, Tejun Heo wrote:
>  > Francesco Pretto wrote:
>  > > 2007/5/4, Tejun Heo <htejun@gmail.com>:
>  > >> Yeap, the third iteration of the patch just got submitted.
>  > >>
>  > >>   http://thread.gmane.org/gmane.linux.ide/18485
>  > >>
>  > >> Unfortunately, there doesn't seem to be an easy way out.  We'll need
>  > >> userland shutdown(8) update.
>  > >>
>  > >> -- 
>  > >> tejun
>  > >>
>  > > 
>  > > Ok, i can't understand if the patch will be included in 2.6.22 (i
>  > > didn't see it in the Andrew Morton merge plan). However, if you can
>  > > confirm the inclusion, i can send bug reports for ubuntu and gentoo. I
>  > > can even send an email to Miquel van Smoorenburg, who should be the
>  > > mainstream sysvinit developer (and probably the last maintainer).
>  > 
>  > Okay, the patch made upstream and webpage posted.
>  > 
>  >  http://linux-ata.org/shutdown.html
> 
> There's a typo..
> 
> "Check whether /sys/modules/libata/parameters/spindown_compat  exists. If it 
does, write 0 to it."
> 
> should be /sys/module/libata/parameters/spindown_compat
> 
> (no 's' after module)

Um, hang on.  So libata can't reliably turn the system off without data loss 
and potential damage to hardware unless userspace goes through a special song 
and dance?  And this is _not_ considered a defect in the kernel?

Why?

(Is there any other piece of hardware that needs userspace to quiesce it just 
so the _off_switch_ can take effect?  Yes, I read both the gmane thread and 
the linux-ata.org link.  I used to maintain the busybox halt/reboot/poweroff 
commands, although I don't anymore.  That just called reboot(), and this 
worked.)

Why on _earth_ does complicating software suspend add extra requirements to 
actual shutdown?  Since when does the shutdown command have to enumerate 
attached block devices?  If anything this would belong in umount -a, but that 
doesn't care about the hardware of the underlying block devices and 
SHOULDN'T...

I'm confused.  Could someone please explain?

Rob
