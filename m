Return-Path: <linux-kernel-owner+w=401wt.eu-S1422969AbXDXSQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422969AbXDXSQw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 14:16:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422974AbXDXSQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 14:16:52 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:51783
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1422969AbXDXSQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 14:16:51 -0400
Date: Tue, 24 Apr 2007 20:19:49 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: Oliver Neukum <oneukum@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] use mutex instead of semaphore in RocketPort driver
Message-ID: <20070424181949.GD6798@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	Oliver Neukum <oneukum@suse.de>, linux-kernel@vger.kernel.org
References: <20070424174953.GB6798@traven> <200704241953.04336.oneukum@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200704241953.04336.oneukum@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

El Tue, Apr 24, 2007 at 07:53:04PM +0200 Oliver Neukum ha dit:

> Am Dienstag, 24. April 2007 19:49 schrieb Matthias Kaehlcke:
> > @@ -1706,7 +1706,7 @@ static int rp_write(struct tty_struct *tty,
> >         if (count <= 0 || rocket_paranoia_check(info, "rp_write"))
> >                 return 0;
> >  
> > -       down_interruptible(&info->write_sem);
> > +       mutex_lock_interruptible(&info->write_mtx);
> 
> This is a bug. It is also present in the current code, but nevertheless
> it is a bug. If you use an interruptible lock, you must be ready to deal
> with interrupts, which are ignored by this code.

i fear i don't have the experience/knowledge to fix this bug, thanks
for your remark. 

i'm a bit confused now about the interruptible locks, i thought using
them means that the process will be waked up when receiving a
signal. what role are playing interrupts when using interruptible locks?

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

     La libertad es como la mañana. Hay quienes esperan dormidos a que
   llegue, pero hay quienes desvelan y caminan la noche para alcanzarla
                        (Subcomandante Marcos)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
