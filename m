Return-Path: <linux-kernel-owner+w=401wt.eu-S965071AbXCCNWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965071AbXCCNWx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 08:22:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030230AbXCCNWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 08:22:53 -0500
Received: from raven.upol.cz ([158.194.120.4]:34711 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965071AbXCCNWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 08:22:52 -0500
Date: Sat, 3 Mar 2007 14:31:55 +0100
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-usb-devel@lists.sourceforge.net, Greg KH <greg@kroah.com>,
       Dale Martenson <dmartenson@multitech.com>,
       Al Borchers <alborchers@steinerpoint.com>,
       LKML <linux-kernel@vger.kernel.org>, mit-devel@lists.printk.net
Subject: dlopen-like facility for conditional loading of symbols in modules (Re: Firmware for new ti_usb_3410_5052 devices)
Message-ID: <20070303133155.GM16509@flower.upol.cz>
References: <1172824155.45e7e05b7980e@my.visi.com> <20070303002707.GJ16509@flower.upol.cz> <20070303002957.GA1966@kroah.com> <200703030840.26982.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703030840.26982.oliver@neukum.org>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 03, 2007 at 08:40:26AM +0100, Oliver Neukum wrote:
> Am Samstag, 3. M?rz 2007 01:29 schrieb Greg KH:
> > On Sat, Mar 03, 2007 at 01:27:07AM +0100, Oleg Verych wrote:
> > > 
> > > If you can proof that it doesn't influence kernel's control above system
> > > hardware. Ironically such stuff in the userspace can give additional
> > > intrusion way to the kernel.
> > 
> > Do you know of any way to use the firmware interface to the kernel for
> > intrusion?  If so, please let us know and we will fix it.
> 
> If you can determine firmware for a block device whose filesystem is
> then mounted with suid allowed or whose files root runs, you've rooted
> the box.
> Firmware needs the same level of protection as kernel modules on disk. This
> is a basic feature of the system and can't be avoided. If you are paranoid
> enough to compile your kernel without module loading, you also have
> to disable firmware loading for block (and net due to nfs/cifs) devices.

Maybe modules' dlopen() like facility would be better to handle static
firmware or any other on-demand static data like ID tables etc.?

I.e. some additional flag for an exported symbol (in a module), that
this symbol maybe dynamically requested and used. As far as i can see,
depmod generates static map, unresolved symbols must be in the kernel
(System.map).

It will solve problem of having multiple unneeded firmware images if
driver handles many devices and firmware is allowed to be in the
kernel. No need in additional secure infrastructure.

p.s. LKML, mit-devel added. Maybe this can be done easily and somebody
     knows that.
____
