Return-Path: <linux-kernel-owner+w=401wt.eu-S933913AbXDATIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933913AbXDATIX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 15:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752004AbXDATIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 15:08:22 -0400
Received: from smtp005.mail.ukl.yahoo.com ([217.12.11.36]:30681 "HELO
	smtp005.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751607AbXDATIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 15:08:21 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=GwAPzlARWbV6U2xPFYget2agScU7UtuLMDJt9q7NM/u3IXk8oz5TrRCF5yRlgyGUZefc/pEhvno8JLkJadzG7gvAx2B6dKqKb/011bJ+uXdgU7CE1azStMOdpgqvU/7D1ZLl1dqgoBsfSPC7Fhb75j8fTBbf0DnQr+LuoWGE+Sg=  ;
X-YMail-OSG: U1RKzLUVM1m2mONpcSX3EFJNH3f6IRN4BGolfR1VgOC7wAg1n3D05am2UpVFhHch8_sIBSknqxKpC8N9aBgG1_aqqxg3AVlLXezAMHSbsvgOhVVp
From: Blaisorblade <blaisorblade@yahoo.it>
To: devzero@web.de, user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [RFC] UML kernel & rootfs bundle with every kernel release ?
Date: Sun, 1 Apr 2007 21:08:14 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, jdike@addtoit.com
References: <1712880100@web.de>
In-Reply-To: <1712880100@web.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704012108.14597.blaisorblade@yahoo.it>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On domenica 1 aprile 2007, devzero@web.de wrote:
> Hello !
>
> i`m not very much into UML for the last months, but while playing around
> with dm-loop i just got one idea i`d like to share.
>
> Whenever you want to test some new kernel (feature), you may put you main
> system at risk, exactly know what you`re doing - or - use UserModeLinux.
>
> The "problem" with UML is:
>
> - you needs to compile an UML kernel first.
> - you needs some "basic" knowlege about UML to get things running.
> - you need to create an appropriate filesystem image for UML - or find some
> for download 

> - you need to copy appropriate kernel modules inside 

Well, you just build usually monolithic kernels, so you skip this problem.
And an idea that likely netkit uses is taking modules through an hostfs mount 
(or, it would be an easier setup). But you need modules to have uid 0...

> - you need to put kernel sources inside, have compiler......
> - you may need appropriate modle-init-tools,initrd, kernel specific tools
> (updated dmsetup, updated....whatever)

You found 2.4 images, but 2.6 ones do exist.

> in short:
> it`s quite some work to be done to have your uml 2.6.21 with root-fs up and
> running and working cleanly. whenever i search the net for some appropriate
> UML fs image, those i find are very often old and outdated...

Hmm... I'd think we need a wizard for configuration. Plus some distro-like 
work for some specific issues - if I want to deploy a VM with hostname x, 
network config y, and with Xnest running, I need an easier way to do that.

You can add settings on kernel command line and parse them inside UML - we 
need standard packaged utilities for that (one of the rootfs builder 
installed such stuff).

> is there a project/website which is offering such ready to run "UML
> kernel+rootfs release bundles" for download (i.e. new kernel,generic 
> root-fs, modules inside, sources inside, compiler inside - in sync with the
> latest stable vanilla) , or , would it make sense to establish such project
> ? i.e. besides releasing the kernel, also releasing sort of a kernel
> "runtime kit" and/or "devkit" ?

The runtime kit is there on nagafix.co.uk. The devkit is a main idea - most of 
the work is to put something on the UML wiki and market well the idea - 
creating such an image would be easy. But I haven't clear what you're talking 
about - kernel development (why sources inside) or userspace development?

Also integrating all possible debug stuff would be useful, but I don't know 
what's needed.

> i think this could be very helpful for linux-kernel, because it could be
> tested by more people more quickly, more easily and thus, more often. just
> download, do few steps for setup, start up that virtual machine and there
> you go testing, hacking into the sources, do all that things you never
> would do on your main system,  whatever....
>
> it would probably also add benefit to UML itself.

We need three things:
a) more performance
b) more users

c) more developers

a) leads to c), and b) too.

> does this sound dumb? i don`t know, so please comment.

No, it's not dumb. I'm even wanting to have a "Vmware-like" interface. Or at 
least standard scripts for guest management.

> regards
> roland
>
> PS:
> ok, this would be some 500M to 1G download, but there`s lot`s of bandwidth
> today - and P2P/Bittorrent.....

uml.nagafix.co.uk has some good kernels + images. With compression, they're 
even as little as 50 Mb.

However, making UML easier to use, and marketing it for more application, is 
very important. Various project do exist but they're not integrated, and they 
do not try to (netkit is for network experimentation, but is also better as 
VM management tool).

In short, we'd need somebody helping out really with the website (there is the 
wiki but you must request an account via email, and it's not the main 
website), with uml-utilities, and with new uml-utilities (you know 
dm-snapshot is a faster COW? Something to setup it automatically would be 
good).

There would be more to say on this, but I can't right now (I've other stuff to 
do).

-- 
Inform me of my mistakes, so I can add them to my list!
Paolo Giarrusso, aka Blaisorblade
http://www.user-mode-linux.org/~blaisorblade
