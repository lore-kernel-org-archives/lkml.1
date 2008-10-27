Return-Path: <linux-kernel-owner+w=401wt.eu-S1752719AbYJ0FYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719AbYJ0FYU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 01:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751701AbYJ0FYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 01:24:12 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:42789 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbYJ0FYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 01:24:11 -0400
Date: Mon, 27 Oct 2008 16:24:09 +1100
From: Simon Horman <horms@verge.net.au>
To: Hartmut Niemann <Hartmut.Niemann@gmx.de>
Cc: linux-kernel@vger.kernel.org, nico-kernel-nfsroot@schottelius.org,
       Willy Tarreau <w@1wt.eu>
Subject: Re: nfsroot.txt in 2.4.36.7 and 2.6.27.1, Configure.help in
	2.4.36.7: missing precondition CONFIG_IP_PNP
Message-ID: <20081027052409.GC6818@verge.net.au>
References: <200810252347.01484.Hartmut.Niemann@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810252347.01484.Hartmut.Niemann@gmx.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 25, 2008 at 11:47:01PM +0200, Hartmut Niemann wrote:
> Hello everybody!
> 
> In kernel versions 2.4.36.7 and 2.6.27.1 (I checked only these) the file 
> nfsroot.txt fail to mention, that
> Kernel level autoconfiguration CONFIG_IP_PNP *must* be selected
> (in 2.6.27.1 the wording is much better mentioning that nfs may not be
> compiled as a module than in 2.4.36.7) 
> in order to be able to even *see* the option
> "Root file system on NFS" (CONFIG_ROOT_NFS)
> -- except for xconfig in 2.4.36, which allowed me to see that there is 
> this option (greyed), and to see it's help text. (This, by the way,
> was a big help -- I could see that the option is still present in current
> kernels)
> 
> I reordered the section 1 of nfsroot.txt (of 2.6.27.1), diff is attached.
> (And I fixed some chapter numbering in section 3).
> Is this document otherwise correct for 2.4 and can be updated there too?
> The version in 2.4.36.7 is 
> 
> The help text of CONFIG_ROOT_NFS in 2.4.36.7 is quite funny:
>   "It is
>   likely that in this case, you also want to say Y to "Kernel level IP
>   autoconfiguration" so that your box can discover its network address
>   at boot time."
> Does that make clear that you can not even see this option 
> during make *config unless you set "Kernel level IP autoconfiguration"?
> The help text of CONFIG_NFS_FS does contain the information,
> but I found it there a little late. The texts in 2.6 are better.
> 
> A diff for 2.4.36.7 Configure.help is attached as well.
> 
> Is this correct?

Hi Hartmut,

I think that your changes to nfsroot.txt are good and should
be considered for inclusion in a future release (probably 2.6.29).

In order to aid this could you please do the following and resend the patch

1) Trim down the description above to only describe the nfsroot.txt
   changes.

2) Add a full path to the patch. Basically
 
	--- nfsroot.txt.orig	2008-10-25 23:18:33.000000000 +0200
	+++ nfsroot.txt	2008-10-25 23:24:48.000000000 +0200

  should be

	--- a/Documentation/filesystems/nfsroot.txt	2008-10-25 23:18:33.000000000 +0200
	+++ b/Documentation/filesystems/nfsroot.txt	2008-10-25 23:24:48.000000000 +0200

  where "a" and "b" can be anything you like, though "a" and "b" are just
  fine.

3) sign off the patch, as per Documentation/SubmittingPatches


I'm not so sure of the Configure.help change and I tend to agree with Willy
Tarreau's comments. As you point out this change is for 2.4.36.7 (and not
2.6.29). So if you want to persue this change, lets discuss that separately
to the inclusion of the nfsroot.txt change in 2.6.29.

> --- nfsroot.txt.orig	2008-10-25 23:18:33.000000000 +0200
> +++ nfsroot.txt	2008-10-25 23:24:48.000000000 +0200
> @@ -22,15 +22,13 @@
>  1.) Enabling nfsroot capabilities
>      -----------------------------
>  
> -In order to use nfsroot, NFS client support needs to be selected as
> -built-in during configuration. Once this has been selected, the nfsroot
> -option will become available, which should also be selected.
> -
> -In the networking options, kernel level autoconfiguration can be selected,
> -along with the types of autoconfiguration to support. Selecting all of
> -DHCP, BOOTP and RARP is safe.
> -
> -
> +In order to use nfsroot, in the networking options,  IP kernel level
> +autoconfiguration must be selected, along with the types of autoconfiguration
> +to support. Selecting all of DHCP, BOOTP and RARP is safe.
> +
> +Then NFS client support needs to be selected as built-in during configuration.
> +Once this has been selected, the nfsroot option will become available,
> +which must also be selected.
>  
>  
>  2.) Kernel command line
> @@ -207,7 +205,7 @@
>       	For more information on isolinux, including how to create bootdisks
>       	for prebuilt kernels, see http://syslinux.zytor.com/
>  
> -3.2) Using LILO
> +3.3) Using LILO
>  	When using LILO all the necessary command line parameters may be
>  	specified using the 'append=' directive in the LILO configuration
>  	file.
> @@ -219,11 +217,11 @@
>  
>  	For information on configuring LILO, please refer to its documentation.
>  
> -3.3) Using GRUB
> +3.4) Using GRUB
>  	When using GRUB, kernel parameter are simply appended after the kernel
>  	specification: kernel <kernel> <parameters>
>  
> -3.4) Using loadlin
> +3.5) Using loadlin
>  	loadlin may be used to boot Linux from a DOS command prompt without
>  	requiring a local hard disk to mount as root. This has not been
>  	thoroughly tested by the authors of this document, but in general
> @@ -232,7 +230,7 @@
>  
>  	Please refer to the loadlin documentation for further information.
>  
> -3.5) Using a boot ROM
> +3.6) Using a boot ROM
>  	This is probably the most elegant way of booting a diskless client.
>  	With a boot ROM the kernel is loaded using the TFTP protocol. The
>  	authors of this document are not aware of any no commercial boot
> @@ -241,7 +239,7 @@
>  	etherboot, both of which are available on sunsite.unc.edu, and both
>  	of which contain everything you need to boot a diskless Linux client.
>  
> -3.6) Using pxelinux
> +3.7) Using pxelinux
>  	Pxelinux may be used to boot linux using the PXE boot loader
>  	which is present on many modern network cards.
>  

> --- Configure.help.orig	2008-10-25 23:34:25.000000000 +0200
> +++ Configure.help	2008-10-25 23:43:37.000000000 +0200
> @@ -17262,10 +17262,11 @@
>    If you want your Linux box to mount its whole root file system (the
>    one containing the directory /) from some other computer over the
>    net via NFS (presumably because your box doesn't have a hard disk),
> -  say Y. Read <file:Documentation/nfsroot.txt> for details. It is
> -  likely that in this case, you also want to say Y to "Kernel level IP
> -  autoconfiguration" so that your box can discover its network address
> -  at boot time.
> +  say Y. Read <file:Documentation/nfsroot.txt> for details.
> +  In this case, you also need to say Y to "Kernel level IP
> +  autoconfiguration" in the networking options so that your box can
> +  discover its network address at boot time, and . Otherwise, you won't be
> +  able to say Y here.
>  
>    Most people say N here.
>  


-- 
Simon Horman
  VA Linux Systems Japan K.K., Sydney, Australia Satellite Office
  H: www.vergenet.net/~horms/             W: www.valinux.co.jp/en

