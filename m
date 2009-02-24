Return-Path: <linux-kernel-owner+w=401wt.eu-S1758440AbZBXRFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758440AbZBXRFH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 12:05:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754584AbZBXREz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 12:04:55 -0500
Received: from web53302.mail.re2.yahoo.com ([206.190.49.92]:47116 "HELO
	web53302.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754522AbZBXREy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 12:04:54 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Message-ID;
  b=Qr3xS6K7uuE/HXF/UKQ0IbaRFyNc0/5M9Ygkg2bzqI+qc0N4WTt4SfeAFIQqDelpOkVnVvXf6uUTdfUZZsuFeBcafjMD/0rqpXNzgkEwBdTQdcmWyhOAzGV+VT9yYrkOer/CIr4x//h3Jx31UA4UNcElfD6S6+L+jZvhkjdvRSE=;
X-YMail-OSG: 54mAJZ8VM1ljsfA2dkxL_g_hhGUefrYQJqsYQpBqdC1koq0p7pJZdjCZHq_GGsyELAzKflq8S2lsqZhkuAjurwlWMStrvUm7hjclw.BPH5unzuspfk113L2_BpmW8nxyCevXCPHgOYsRG0oHRkJKjcqILKdwcVWONRuDwzfdez3ZwpRWOCnpJq9XZFxIivKQW8mV5asUD0j4WXHycg0yNZg-
X-Mailer: YahooMailWebService/0.7.260.1
Date: Tue, 24 Feb 2009 09:04:52 -0800 (PST)
From: Alberto Gonzalez <luis6674@yahoo.com>
Reply-To: luis6674@yahoo.com
Subject: Re: [Bug #12337] ~100 extra wakeups reported by powertop
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Eric Anholt <eric@anholt.net>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
In-Reply-To: <200902240824.32155.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <405946.86220.qm@web53302.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




--- On Tue, 2/24/09, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> > Steps:
> > - Boot into Fedora 10 Live CD (obviously, into the
> default graphical mode)
> > - Install Powertop (yum install powertop) and run it
> > - I get about 60 wakeups per second from i915@pci....
> leaving the system
> > idle - Switch to console and back to X. The wakeups
> are gone.
> 
> Ah ok, it sounds like you're getting vblank interrupts
> at startup time, but 
> once you VT switch the kernel figures out that you
> don't need them, so it 
> disables them.  I think this is a bug in the 2D driver; it
> has an ioctl it 
> uses when doing modesetting which doubles as a
> "disabling the irq is ok" 
> signal, but we call it at a time when the corresponding
> pipe is off, so the 
> kernel ignores the call.

Yes, that's what E. Anholt supposed too.

> 
> Can you file a bug for this at bugs.freedesktop.org? Is it
> easy for you to 
> rebuild & test xf86-video-intel driver patches?

I filed the report:
http://bugs.freedesktop.org/show_bug.cgi?id=20296

Sure, I guess I can manage to patch the Intel driver and test it. I'm using 2.4.3 now, so maybe one thing I could do first is to try 2.5.x.
> 
> Thanks,
> -- 
> Jesse Barnes, Intel Open Source Technology Center

Thanks,
Alberto.


      
