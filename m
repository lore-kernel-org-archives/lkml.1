Return-Path: <linux-kernel-owner+w=401wt.eu-S932170AbYDQPRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932170AbYDQPRk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 11:17:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759776AbYDQPRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 11:17:33 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:45104 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757103AbYDQPRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 11:17:32 -0400
Date: Thu, 17 Apr 2008 08:15:28 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Avi Kivity <avi@qumranet.com>
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Xiantao Zhang <xiantao.zhang@intel.com>
Subject: Re: [PATCH 45/45] KVM: ia64: Add a guide about how to create kvm
 guests on ia64
Message-Id: <20080417081528.77a5bd24.randy.dunlap@oracle.com>
In-Reply-To: <1208423450-29415-46-git-send-email-avi@qumranet.com>
References: <1208423450-29415-1-git-send-email-avi@qumranet.com>
	<1208423450-29415-46-git-send-email-avi@qumranet.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Apr 2008 12:10:50 +0300 Avi Kivity wrote:

> From: Xiantao Zhang <xiantao.zhang@intel.com>
> 
> Guide for creating virtual machine on kvm/ia64.
> 
> Signed-off-by: Xiantao Zhang <xiantao.zhang@intel.com>
> Signed-off-by: Avi Kivity <avi@qumranet.com>
> ---
>  Documentation/ia64/kvm.txt |   82 ++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 82 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/ia64/kvm.txt
> 
> diff --git a/Documentation/ia64/kvm.txt b/Documentation/ia64/kvm.txt
> new file mode 100644
> index 0000000..bec9d81
> --- /dev/null
> +++ b/Documentation/ia64/kvm.txt
> @@ -0,0 +1,82 @@
> +Currently, kvm module in EXPERIMENTAL stage on IA64. This means that

s/in /is in /

> +interfaces are not stable enough to use. So, plase had better don't run

s/plase had better/please/

> +critical applications in virtual machine. We will try our best to make it
> +strong in future versions!
> +				Guide: How to boot up guests on kvm/ia64
> +
> +This guide is to describe how to enable kvm support for IA-64 systems.
> +
> +1. Get the kvm source from git.kernel.org.
> +	Userspace source:
> +		git clone git://git.kernel.org/pub/scm/virt/kvm/kvm-userspace.git
> +	Kernel Source:
> +		git clone git://git.kernel.org/pub/scm/linux/kernel/git/xiantao/kvm-ia64.git
> +
> +2. Compile the source code.

...

> +3. Get Guest Firmware named as Flash.fd, and put it under right place:
> +	(1) If you have the guest firmware (binary) released by Intel Corp for Xen, use it directly.
> +
> +	(2) If you have no firmware at hand, Please download its source from

s/Please/please/

> +		hg clone http://xenbits.xensource.com/ext/efi-vfirmware.hg
> +	    you can get the firmware's binary in the directory of efi-vfirmware.hg/binaries.
> +
> +	(3) Rename the firware you owned to Flash.fd, and copy it to /usr/local/share/qemu
> +
> +4. Boot up Linux or Windows guests:
> +	4.1 Create or install a image for guest boot. If you have xen experience, it should be easy.

s/a image/an image/

> +
> +	4.2 Boot up guests use the following command.

s/use/using/

> +		/usr/local/bin/qemu-system-ia64 -smp xx -m 512 -hda $your_image
> +		(xx is the number of virtual processors for the guest, now the maximum value is 4)
> +
> +5. Known possibile issue on some platforms with old Firmware.

s/issue/issues/

> +
> +If meet strange host crashe issues, try to solve it through either of the following ways:

s/meet/you have/
s/crashe/crash/
s/solve it/solve them/

> +(1): Upgrade your Firmware to the latest one.
> +
> +(2): Applying the below patch to kernel source.
> +diff --git a/arch/ia64/kernel/pal.S b/arch/ia64/kernel/pal.S
> +index 0b53344..f02b0f7 100644
> +--- a/arch/ia64/kernel/pal.S
> ++++ b/arch/ia64/kernel/pal.S
> +@@ -84,7 +84,8 @@ GLOBAL_ENTRY(ia64_pal_call_static)
> +	mov ar.pfs = loc1
> +	mov rp = loc0
> +	;;
> +-	srlz.d				// seralize restoration of psr.l
> ++	srlz.i			// seralize restoration of psr.l
> ++	;;
> +	br.ret.sptk.many b0
> + END(ia64_pal_call_static)
> +
> +6. Bug report:
> +	If you found any issues when use kvm/ia64, Please post the bug info to kvm-ia64-devel mailing list.

s/Please/please/

> +	https://lists.sourceforge.net/lists/listinfo/kvm-ia64-devel/
> +
> +Thanks for your interest! Let's work together, and make kvm/ia64 stronger and stronger!
> +
> +
> +								Xiantao Zhang <xiantao.zhang@intel.com>
> +											2008.3.10

---
~Randy
