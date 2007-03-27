Return-Path: <linux-kernel-owner+w=401wt.eu-S965375AbXC0U26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965375AbXC0U26 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 16:28:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965378AbXC0U26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 16:28:58 -0400
Received: from smtp.osdl.org ([65.172.181.24]:41941 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965375AbXC0U25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 16:28:57 -0400
Date: Tue, 27 Mar 2007 13:28:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Badari Pulavarty <pbadari@gmail.com>
Cc: dbrownell@users.sourceforge.net, lkml <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc5-mm1
Message-Id: <20070327132853.6d551362.akpm@linux-foundation.org>
In-Reply-To: <1175018047.16728.24.camel@dyn9047017100.beaverton.ibm.com>
References: <20070326205706.a750bb35.akpm@linux-foundation.org>
	<1175018047.16728.24.camel@dyn9047017100.beaverton.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Mar 2007 09:54:07 -0800
Badari Pulavarty <pbadari@gmail.com> wrote:

> On Mon, 2007-03-26 at 20:57 -0800, Andrew Morton wrote:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm1/
> > 
> > 
> 
>   CC [M]  drivers/parport/parport_pc.o
> In file included from drivers/parport/parport_pc.c:66:
> include/asm/parport.h:18: error: conflicting types for
> ___parport_pc_probe_port___
> include/linux/parport_pc.h:234: error: previous declaration of
> ___parport_pc_probe_port___ was here
> drivers/parport/parport_pc.c:2379: error: conflicting types for
> ___parport_pc_probe_port___
> drivers/parport/parport_pc.c:2152: error: previous definition of
> ___parport_pc_probe_port___ was here
> drivers/parport/parport_pc.c: In function ___sio_ite_8872_probe___:
> drivers/parport/parport_pc.c:2509: warning: passing argument 5 of
> ___parport_pc_probe_port___ from incompatible pointer type
> drivers/parport/parport_pc.c: In function ___sio_via_probe___:
> drivers/parport/parport_pc.c:2692: warning: passing argument 5 of
> ___parport_pc_probe_port___ from incompatible pointer type
> drivers/parport/parport_pc.c: In function ___parport_pc_pci_probe___:
> drivers/parport/parport_pc.c:2990: warning: passing argument 5 of
> ___parport_pc_probe_port___ from incompatible pointer type
> drivers/parport/parport_pc.c: In function ___parport_pc_pnp_probe___:
> drivers/parport/parport_pc.c:3098: warning: passing argument 5 of
> ___parport_pc_probe_port___ from incompatible pointer type
> make[2]: *** [drivers/parport/parport_pc.o] Error 1
> make[1]: *** [drivers/parport] Error 2
> make[1]: *** Waiting for unfinished jobs....
> make: *** [drivers] Error 2
> make: *** Waiting for unfinished jobs....
> 
> 
> Patch that is causing the problem in -mm:
> parport-dev-driver-model-support.patch
> 
> 
> Here is the fix.
> 
> Thanks,
> Badari
> 
> Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
> ---
>  include/asm-powerpc/parport.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6.21-rc5/include/asm-powerpc/parport.h
> ===================================================================
> --- linux-2.6.21-rc5.orig/include/asm-powerpc/parport.h	2007-03-27 09:47:13.000000000 -0700
> +++ linux-2.6.21-rc5/include/asm-powerpc/parport.h	2007-03-27 09:47:54.000000000 -0700
> @@ -15,7 +15,7 @@
>  extern struct parport *parport_pc_probe_port (unsigned long int base,
>                                                unsigned long int base_hi,
>                                                int irq, int dma,
> -                                              struct pci_dev *dev);
> +                                              struct device *dev);
>  

I ended up just deleting that declaration - we shouldn't be duplicating it
in two header files.

That'll probably break the build, but I'll fix that up when I get near the
powerpc machine.

>  static int __devinit parport_pc_find_nonpci_ports (int autoirq, int autodma)
>  {

What's this doing in a header file, I wonder.
