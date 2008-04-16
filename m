Return-Path: <linux-kernel-owner+w=401wt.eu-S1762640AbYDPK3G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762640AbYDPK3G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 06:29:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757089AbYDPK24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 06:28:56 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:38630 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756960AbYDPK2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 06:28:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:cc:subject:references:in-reply-to:content-type;
        b=Zo05vfl65U+Dhic8MgM8gLrPCsCm/OnMVzRziLssgHY2UMa/x+ObfS3ALxcWA1sgouR5bwdXMrQFF8fOsaaOWbuGT2VUr+Cj9cV1OdbkN6uSEUVWKLkbzQMIRVKL5NaJip8vlwxofIHy0hwYtGsrTgdSXmWTFenAnGaE+msQMqM=
Message-ID: <4805D5E1.1070906@gmail.com>
Date: Wed, 16 Apr 2008 06:33:05 -0400
From: Scott Lovenberg <scott.lovenberg@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Self-snapshotting in Linux
References: <804dabb00804160144j25584229t6673bc182fa13b3@mail.gmail.com>
In-Reply-To: <804dabb00804160144j25584229t6673bc182fa13b3@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------010609010506010200050509"
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010609010506010200050509
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Peter Teoh wrote:
> Sorry if this is a a crazy idea.....just be forewarned....
>
> First, I would like to make a reference to VMWare's snapshot (name not
> important, emphasize the idea) feature - hopefully u are familiar with
> it.   This is a feature whereby u can freeze the entire OS (kernel +
> userspace application running) and then later reload itself next time,
> continuing where it left off, without reboot from ground zero.
>
> Next, can I ask, is such a feature useful in Linux?   Ie, able to
> restart the kernel + userspace application from where u left off, the
> last time round.    Not JUST the normal suspend/resume feature, but
> more important able to CHOOSE among the different available images for
> u to resume on.   Eg, u want to freeze the current 2.6.25-rc6 kernel,
> save it, and then restore back the 2.6.23-rc5 image, work on it, save
> it, and then restore the previous image again.   All done without
> virtualization as in the VMWare sense - which really is CPU intensive
> and slow things  down a lot.   Now we can directly execute each OS
> kernel image on the CPU, and since saving and restoring is quite fast
> (eg, zipping up the entire physical memory before saving into
> permanent storage) - I supposed this will be much faster than the
> normal initialization/fsck work done normally....or did I missed out
> anything?
>
> Essentially, to reiterate the key idea:   able to snapshot the current
> kernel+userspace permanent.....restore from another snapshot....and
> then switch back again if needed etc.....will the implementation be
> difficult...if not impossible????
>
>   
Hrm... well, the kernel has the ability since 2.6.20 (although its in 
testing AFAIK) to relocate itself on a crash.  Reference:


      Relocatable kernel support for x86

This feature (enabled with CONFIG_RELOCATABLE) isn't very noticeable for 
end-users but it's quite interesting from a kernel POV. Until now, it 
was a requirement that a i386 kernel was loaded at a fixed memory 
address in order to work, loading it in a different place wouldn't work. 
This feature allows to compile a kernel that can be loaded at different 
4K-aligned addresses, but always below 1 GB, with no runtime overhead. 
Kdump users (a feature introduced in 2.6.13 
<http://kernelnewbies.org/Linux_2_6_13> that triggers kexec 
<http://lwn.net/Articles/108595/> in a kernel crash in order to boot a 
kernel that has been previously loaded at an 'empty' address, then runs 
that kernel, saves the memory where the crashed kernel was placed, dumps 
it in a file and continues booting the system) will benefit from this 
because until now the "rescue kernel" needed to be compiled with 
different configuration options in order to make it bootable at a 
different address. With a relocatable kernel, the same kernel can be 
booted at different addresses. (commit 1 
<http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=968de4f02621db35b8ae5239c8cfc6664fb872d8>, 
2 
<http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=e69f202d0a1419219198566e1c22218a5c71a9a6>, 
3 
<http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=be274eeaf20b4c7155242645d5e2c48b023e609b>, 
4) 
<http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=fd593d12770d4a0d1ff095d44b96436c18479ee8>



Maybe you load up another kernel to handle the snapshot, and then hand 
the system back to it afterwards?  What do you think?

--------------010609010506010200050509
Content-Type: text/x-vcard; charset=utf-8;
 name="scott_lovenberg.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="scott_lovenberg.vcf"

begin:vcard
fn:Scott Lovenberg
n:Lovenberg;Scott
org:The CleftStone Works
adr:;;;Kutztown;PA;19530;USA
email;internet:scott.lovenberg@gmail.com
tel;cell:570-856-2999
note;quoted-printable:Interests:=0D=0A=
	Programming, *NIX, Slackware, Samba, C/C++, Perl, Java, .NET, Kernel Hack=
	ing, Virtual Machines, FOSS, Security, Operating Systems, Various Softwar=
	e Stacks.  =
	=0D=0A=
	=0D=0A=
	Always have time for "shop talk"; feel free to drop me a line.
x-mozilla-html:TRUE
url:www.cleftstoneworks.com
version:2.1
end:vcard


--------------010609010506010200050509--
