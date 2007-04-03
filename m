Return-Path: <linux-kernel-owner+w=401wt.eu-S1751542AbXDCEBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751542AbXDCEBz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 00:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751773AbXDCEBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 00:01:55 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:49510 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbXDCEBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 00:01:54 -0400
Date: Tue, 3 Apr 2007 09:31:52 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jurriaan <thunder7@xs4all.nl>,
       Helge Hafting <helgehaf@aitel.hist.no>, linux-kernel@vger.kernel.org,
       Magnus Damm <magnus@valinux.co.jp>, Horms <horms@verge.net.au>
Subject: Re: 2.6.21-rc5-mm3 - no boot, "address not 2M aligned"
Message-ID: <20070403040152.GA5108@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <20070330010559.2a232d9a.akpm@linux-foundation.org> <20070331071220.GA26910@aitel.hist.no> <20070331005303.354411f0.akpm@linux-foundation.org> <20070401052932.GA9894@amd64.of.nowhere> <m1ircghb6w.fsf@ebiederm.dsl.xmission.com> <20070331232957.e1c93f19.akpm@linux-foundation.org> <20070402074159.GA13704@in.ibm.com> <m1abxrf9o3.fsf@ebiederm.dsl.xmission.com> <20070402094520.GC13704@in.ibm.com> <m1648eg01d.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1648eg01d.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2007 at 11:26:38AM -0600, Eric W. Biederman wrote:
> Vivek Goyal <vgoyal@in.ibm.com> writes:
> 
> > Only advantage of CONFIG_PHYSICAL_START seems to be that one has got
> > capability to run the kernel from other addresses without modifying the
> > boot-loader. One can argue that now people should use a relocatable kernel
> > for such a feature. But for using relocatable kenrel, one needs to modify
> > grub, lilo and I am not sure if somebody is going to do that. Secondly, how
> > would one specify an address to a boot-loader to load image at?
> 
> I thought this was important for vmlinux and Xen?
> 

Yes it is. Actually you had already mentioned it in the previous mail that's
why I did not repeat it here. Xen folks wanted to continue using vmlinux
for capturing dump. I am not sure if there is any technical limitation in
using relocatable bzImage or just that they wanted to continue using
existing working interface and did not want to switch to new interface.

Magnus, Horms, do you want to add to it? Is there a reason that relocatable
bzImage will not work in Xen env and we need to retain CONFIG_PHYSICAL_START
option in x86_64?


> I guess at this point the easy case is that we modify /sbin/kexec to support
> it.  And the other bootloaders can come be upgraded if the feature is
> interesting enough.
> 
> > On i386, somebody already found an interesting usage of CONFIG_PHYSICAL_START
> > where he was running his kernel above 16MB so that he can maximize on
> > DMA ZONE. Can't think of any usage for x86_64 at the moment but I think
> > down the line people might come up with such usages.
> 
> Agreed.  We do have CONFIG_PHYSICAL_ALIGN that can handle that case,
> although I admit that is a bit of a hack.
> 

Yes, but x86_64 will not have any of those options and only way to run 
kernel will be either use kexec or modify your boot-loader to so that
it can handle relocatable images.

> > To me, retaining CONFIG_PHYSICAL_START gives added flexibility to the user,
> > at the expense of reduced simplicity. We should definitely change the type
> > of vmlinux to ET_DYN but at the same time it might still be worth to retain
> > CONFIG_PHYSICAL_START option.
> 
> I think something like CONFIG_PHYSICAL_START currently gives us very
> little gain, and is hard to use correctly, and there are alternative
> solutions.  So if we can get rid of it, by only inconveniencing users
> who want load their kernels at a weird address it is worth it.
> 
> >> I think I can switch the vmlinux header type in about 100 lines or so
> >> of code.  Assuming I can ever get 30 minutes with the appropriate
> >> kernel.
> >> 
> >
> > That would be awesome. Then vmlinux will be relocatable too. (Officially).
> 
> Yes.  For x86_64 I can do this.  i386 is more difficult.  (Although with
> a little cleverness we can move the code that processes relocations into
> vmlinux).  
> 

Performing relocations in vmlinux will be interesting. That way i386 vmlinux
too will become relocatable and only piece of puzzle to solve will be to
make vmlinux of type ET_DYN.

Thanks
Vivek
