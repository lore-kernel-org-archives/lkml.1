Return-Path: <linux-kernel-owner+w=401wt.eu-S1753668Ab0AHPwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668Ab0AHPwB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 10:52:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753250Ab0AHPv6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 10:51:58 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:51110 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435Ab0AHPv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 10:51:57 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 3/3] generic sys_ipc wrapper
Date: Fri, 8 Jan 2010 16:49:34 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, linux@arm.linux.org.uk, starvik@axis.com,
       jesper.nilsson@axis.com, dhowells@redhat.com,
       ysato@users.sourceforge.jp, takata@linux-m32r.org, geert@linux-m68k.org,
       zippel@linux-m68k.org, gerg@uclinux.org, ralf@linux-mips.org,
       benh@kernel.crashing.org, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, lethal@linux-sh.org, davem@davemloft.net,
       jdike@addtoit.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       viro@zeniv.linux.org.uk
References: <20100106172152.GC17163@lst.de> <201001081157.17195.arnd@arndb.de> <20100108153443.GA14494@lst.de>
In-Reply-To: <20100108153443.GA14494@lst.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001081649.34308.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX188omX+/VFLppPUSoN/HhUGfOMBhthilw0POL6
 49eAPByut5FzKx9BACqGpEZlCqXrLHhmCb+VGbfeF9mPJVlE/b
 GC1HG9qJNMJm15rPsctdg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 January 2010, Christoph Hellwig wrote:
> Possiblly.  Not sure if it's worth it, though.  If the s390 maintainers
> want it I'd say do it as a separate patch.

Sounds fair.

> at least on powerpc and s390, possibly on all 64 bit machines:
> 
> > > +                   return -EINVAL;
> > > +           if (get_user(fourth.__pad, (void __user * __user *) ptr))
> > > +                   return -EFAULT;
> > > +           return sys_semctl(first, second, third, fourth);
> > 
> >               return sys_semctl(first, (int)second, third, fourth);
> 
> What does the explicit case buy us in terms of sign-extension over
> the implicit one given that the second argument to sys_semctl already is
> types as int?

You're right, it's not needed any more, in particular since Heiko
added the wrappers around each syscall to do yet another sign extension,
but this one was probably right in your version already.

You convinced me that the patch is good in its current shape.

Acked-by: Arnd Bergmann <arnd@arndb.de>

	Arnd
