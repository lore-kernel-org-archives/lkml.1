Return-Path: <linux-kernel-owner+w=401wt.eu-S1754767AbZGWX7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767AbZGWX7w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 19:59:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754495AbZGWX7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 19:59:51 -0400
Received: from mail-yx0-f184.google.com ([209.85.210.184]:56698 "EHLO
	mail-yx0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927AbZGWX7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 19:59:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=rtTEDDlcM4sn0H3IJSIN9MB7jxo72qJuqk4osNIWbJO9KnNPZ3T/QvC1sLvx7NTkqa
         EpJUaXD68FBSsQsQqLR+4Yp9qOc7URRMrddPgyirfRK5Quy5dK0H6C82FXIURi4ah/25
         3s7f4fvPHVDwabdR4knT5zXB/IVMBKMnFT/7s=
From: Lamarque Vieira Souza <lamarque@gmail.com>
To: Anthony Waters <awaters1@gmail.com>
Subject: Re: [PATCH] Fix for Acer Bluetooth Optical Rechargeable Mouse
Date: Thu, 23 Jul 2009 20:59:33 -0300
User-Agent: KMail/1.11.4 (Linux/2.6.30.2-lvs; KDE/4.2.4; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-bluetooth@vger.kernel.org,
       linux-kernel@vger.kernel.org, marcel@holtmann.org
References: <200907170301.43807.lamarque@gmail.com> <200907231921.31121.lamarque@gmail.com> <2a91b6e50907231605t2b805a7avfbd313a96280af29@mail.gmail.com>
In-Reply-To: <2a91b6e50907231605t2b805a7avfbd313a96280af29@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907232059.33760.lamarque@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Quinta-feira 23 Julho 2009, Anthony Waters escreveu:
> The patch in the bug report[1] just undoes the part of the commit that
> causes the stutter/sluggishness with my mouse so it isn't really a fix

	Actually I have changed your patch to add a quirk for my bluetooth controller 
(0a5c:200a), so it only undoes the change for this particular bluetooth 
controller. The default link policy settings mentioned in commit "[Bluetooth] 
Make use of the default link policy settings" does not work properly with this 
mouse even in Windows. In Windows the mouse is slow to react even today, 
increasing acceleration in mouse settings helped but then the touchpad becomes 
to sensitive, the mouse had always worked better in Linux than in Windows 
until kernel 2.6.21. In 2.6.22 the input-to-hid change happened in hci_usb 
module and the mouse started to behave like in Windows. In 2.6.27 the stutter 
problem was introduced, in 2.6.29 hci_usb module was removed and only btusb 
was available, but with hid+btusb+2.6.2[89] the cursor gets stucked at upper-
left corner, with hid+hci_usb+2.6.28 there is only the stutter problem. 
Finally, after two years trying to find the causes of those problems it is 
working well again, better than in Windows, so please add those two patches to 
the kernel. I even got to the point to undo the input-to-hid change from 
kernels 2.6.22 until 2.6.26 and port the modified 2.6.26 bluetooth subsystem 
to kernels 2.6.2[789] until I find a better solution, which seems to be those 
two patches.

> [1] http://bugzilla.kernel.org/show_bug.cgi?id=13314
>
> On Thu, Jul 23, 2009 at 6:21 PM, Lamarque Vieira
>
> Souza<lamarque@gmail.com> wrote:
> > Em Quinta-feira 23 Julho 2009, Andrew Morton escreveu:
> >> On Thu, 23 Jul 2009 19:00:58 -0300
> >>
> >> Lamarque Vieira Souza <lamarque@gmail.com> wrote:
> >> > Em Quinta-feira 23 Julho 2009, Andrew Morton escreveu:
> >> > > On Thu, 23 Jul 2009 18:30:57 -0300
> >> > >
> >> > > Lamarque Vieira Souza <lamarque@gmail.com> wrote:
> >> > > > Em Quinta-feira 23 Julho 2009, Andrew Morton escreveu:
> >> > > > > On Fri, 17 Jul 2009 03:01:43 -0300
> >> > > > >
> >> > > > > Lamarque Vieira Souza <lamarque@gmail.com> wrote:
> >> > > > > >     This patch works around one problem with my Acer Bluetooth
> >> > > > > > Optical Rechargeable Mouse where the cursor gets stuck at
> >> > > > > > screen's upper-left corner. Even my notebook's touchpad is not
> >> > > > > > able to move cursor when the bluetooth mouse is connected to
> >> > > > > > my Acer Ferrari 4005 notebook. Using input session instead of
> >> > > > > > hid session solves this problem although the cursor still
> >> > > > > > moves a little sluggishly with the bluetooth mouse, cursor
> >> > > > > > moves correctly using the touchpad. My bluetooth mouse used to
> >> > > > > > work well (no sluggish) until kernel 2.6.21, since then the
> >> > > > > > problems are getting worse with each kernel release (it got
> >> > > > > > sluggish in 2.6.22 and this this upper-left corner problem
> >> > > > > > appeared in 2.6.28 or 2.6.27).
> >> > > >
> >> > > >         By the way, I have found that bug
> >> > > > http://bugzilla.kernel.org/show_bug.cgi?id=13314 is the cause of
> >> > > > the sluggish in my mouse.
> >> > >
> >> > > (cc's added)
> >> > >
> >> > > OK, thanks.  Did you test Anthony's patch on your system?
> >> >
> >> >     Yes,  I did.
> >>
> >> Did it fix the bug?
> >
> >        It fixed one of the two problems I had with this mouse.
> >
> >> If so, does that mean that you think we should merge Anthony's patch
> >> instead of yours?
> >
> >        I need both patches for my mouse to work properly. My patch fix
> > the problem of cursor stucked at upper-left corner. Anthony's fix the
> > cursor being sluggish (stutter). They are two different problems.
> >
> >> > > Also, you've determined that
> >> > > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=c
> >> > >omm it;h =e4e8e37c42bdaaefcb84eeaef0dc1bc3f696f8f6 caused the problem
> >> > > on your machine and that reverting it fixes things up.
> >> > >
> >> > > I'm all confused.
> >
> > --
> > Lamarque V. Souza
> > http://www.geographicguide.com/brazil.htm
> > Linux User #57137 - http://counter.li.org/


-- 
Lamarque V. Souza
http://www.geographicguide.com/brazil.htm
Linux User #57137 - http://counter.li.org/
