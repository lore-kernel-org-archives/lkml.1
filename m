Return-Path: <linux-kernel-owner+w=401wt.eu-S1752735AbXJVHwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735AbXJVHwb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 03:52:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751508AbXJVHwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 03:52:23 -0400
Received: from qb-out-0506.google.com ([72.14.204.230]:51048 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbXJVHwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 03:52:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent;
        b=JKi2/a8kpSA+p1FQqBYax3j8rk822fQTrCqFln0ig/9L4stZOEF8+DxUHlnxqCB3tbnBjgGuD6yHfpvs8/ohAHqnWQZS8MT6ChwbrBnsi/jXmfDRioegNhjZ5MwnxNIEHB+473vfeDh36zhahgm8RajByHnfj05IDJs86E95ijE=
Date: Mon, 22 Oct 2007 15:48:23 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, Nix <nix@esperi.org.uk>,
       Al Viro <viro@ftp.linux.org.uk>, Jeff Dike <jdike@addtoit.com>,
       Paolo Giarrusso <p.giarrusso@gmail.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>
Subject: Re: [uml-devel] User Mode Linux still doesn't build in
	2.6.23-final.
Message-ID: <20071022074823.GJ2998@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20071021114854.GF2455@hacking> <20071021130848.GA4621@c2.user-mode-linux.org> <20071021132031.GI2455@hacking> <20071021154346.GW8181@ftp.linux.org.uk> <20071022043746.GF2998@hacking> <20071022052214.GY8181@ftp.linux.org.uk> <20071022061245.GG2998@hacking> <87d4v7fy5i.fsf@hades.wkstn.nix> <20071022065202.GI2998@hacking> <20071022065943.GC10864@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071022065943.GC10864@uranus.ravnborg.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2007 at 08:59:43AM +0200, Sam Ravnborg wrote:
>On Mon, Oct 22, 2007 at 02:52:02PM +0800, WANG Cong wrote:
>> On Mon, Oct 22, 2007 at 07:42:33AM +0100, Nix wrote:
>> >On 22 Oct 2007, WANG Cong uttered the following:
>> >> I build UML for non-SMP x86. But I don't know about UML_NET_VDE. ;(
>> >>
>> >> Errors threw out by gcc (too many) are put here:
>> >> 	http://wangcong.org/down/errors.txt
>> >
>> >It's hard to tell without LOCALE=C, but those are the sorts of results
>> >I'd expect if you had run make {old,menu,x}config without specifying
>> >ARCH=um, so you've configured for one architecture and are now trying
>> >to build another.
>> >
>> >Where is the include/asm symlink pointing to in your build tree?
>> 
>> $ ls -l include/asm
>> lrwxrwxrwx 1 wangcong wangcong 6 2007-10-22 12:34 include/asm -> asm-um
>> 
>> OK. Let me do the following:
>> 
>> 	$ make mrproper
>
>Please try
>make ARCH=um mrproper
>
>this will clean up the additional uml symlinks.
>

Hi, Sam, Al and others.

I just followed what Sam told me, errors are much fewer this time,
but still exist. Error messages are:

  CC      arch/um/kernel/syscall.o
  CC      arch/um/kernel/sysrq.o
arch/um/kernel/sysrq.c: In function ‘show_stack’:
arch/um/kernel/sysrq.c:63: error: ‘UESP’ undeclared (first use in this function)
arch/um/kernel/sysrq.c:63: error: (Each undeclared identifier is reported only once
arch/um/kernel/sysrq.c:63: error: for each function it appears in.)
make[1]: *** [arch/um/kernel/sysrq.o] Error 1
make: *** [arch/um/kernel] Error 2

Or I missed something again?

And I use `make defconfig ARCH=um' to generate .config, my tree
is 2.6.23-git16 (Al, is this OK?).

Thanks.

-- 
May the Source Be With You.
