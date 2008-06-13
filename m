Return-Path: <linux-kernel-owner+w=401wt.eu-S1759822AbYFMXJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759822AbYFMXJh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 19:09:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755780AbYFMXJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 19:09:29 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:31806 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755308AbYFMXJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 19:09:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=h9RD60YGoZF0mmcWhlvAmIYqtk9pA2H9FPhtO2dLVTmDGGnF55ralj4baY4k/rLilT
         4AzdHCls1lKuFqR0crMgiD3lsW72QWfEbAqF2Arkd/C/D+60klKkan8QP65aUnYNVu7c
         loTD4Cp+pVy3KVn40KQk9vGuUC3aDeKjpKLPI=
Message-ID: <4852FDFC.1020403@googlemail.com>
Date: Sat, 14 Jun 2008 01:08:44 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Jeff Dike <jdike@addtoit.com>, linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: kbuild breaks um - fails to find util when linking
References: <20080610190307.GA15983@uranus.ravnborg.org> <20080611154816.GA8167@c2.user-mode-linux.org> <20080612180859.GA2271@uranus.ravnborg.org> <20080612201315.GA10879@c2.user-mode-linux.org> <20080612210615.GA7558@uranus.ravnborg.org>
In-Reply-To: <20080612210615.GA7558@uranus.ravnborg.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:

Hi Sam , Jeff ,

> On Thu, Jun 12, 2008 at 04:13:15PM -0400, Jeff Dike wrote:
>> On Thu, Jun 12, 2008 at 08:08:59PM +0200, Sam Ravnborg wrote:
>>> Following patch will result in a building ARCH=um kernel.
>>> If it works I dunno.
>> You can just try running it.  Given its behavior with this patch so
>> far, it would be an excellent sign for it to figure out that it has no
>> root filesystem and panic.
>>
>> Anyway, I can't get it to give me a UML binary.  I see this in the
>> build output (and V=3 doesn't make it any more verbose):
>>
>>
>> 	  CHK     include/linux/compile.h
>> 	  LINK linux
>>
>> 	Compilation finished at Thu Jun 12 16:11:15
>>
>> but no linux or vmlinux in my output directory.
> 
> So appearantly kbuild thinks you have a vmlinux
> so no need to relink.
> And the line "LINK linux" implies this as well.
> 
> Please double check that you do not have a vmlinux,
> and try V=2" to see where LINK picks up the vmlinux.
> 
> My build finised:
> $ ./linux
>  ./linux: /usr/lib/libc.so.1: bad ELF interpreter: No such file or directory


I didn't tested this patch but I think LINK-$(CONFIG_LD_SCRIPT_DYN) should have -rpath / -rpath-link too since 
libc.so.* is usually in /lib and not /usr/lib.

Another thing I noticed is this hunk :

+$(shell $(CC) -print-file-name=ld-linux.so.2) \

On 64bit that should not work since it is ld-linux-x86-64.so.2 and not ld-linux.so.2

> 

> So I will take an additional look tomorrow.
> 
> 	Sam


Regards ,

Gabriel
