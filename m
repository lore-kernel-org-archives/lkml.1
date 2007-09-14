Return-Path: <linux-kernel-owner+w=401wt.eu-S1758229AbXINTg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758229AbXINTg3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 15:36:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755448AbXINTgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 15:36:21 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:40471 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971AbXINTgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 15:36:21 -0400
Date: Fri, 14 Sep 2007 09:19:21 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Rusty Russell <rusty@rustcorp.com.au>, jengelh@gmx.de
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Chris Wright <chrisw@sous-sol.org>, Avi Kivity <avi@qumranet.com>,
       Anthony Liguori <aliguori@us.ibm.com>
Subject: Re: [PATCH 2/3] Consolidate host virtualization support under
 Virtualization menu
Message-Id: <20070914091921.73007c5a.randy.dunlap@oracle.com>
In-Reply-To: <1189747124.7262.36.camel@localhost.localdomain>
References: <1189747054.7262.34.camel@localhost.localdomain>
	<1189747124.7262.36.camel@localhost.localdomain>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Sep 2007 15:18:44 +1000 Rusty Russell wrote:

> We turn "Virtualization" into a menu, not a config option, since it's
> actually only used as a menu.  Then we move lguest under that menu.

so you want to revert the 2007-july-16 merge that changes
menu -> menuconfig and makes most of the menus consistent in
presentation.  I'd rather not, but I don't own it.

And Yes, lguest does need to be moved into a better location.


> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> diff -r c2893801de2a drivers/Kconfig
> --- a/drivers/Kconfig	Fri Sep 14 13:24:46 2007 +1000
> +++ b/drivers/Kconfig	Fri Sep 14 13:24:49 2007 +1000
> @@ -87,6 +87,4 @@ source "drivers/kvm/Kconfig"
>  source "drivers/kvm/Kconfig"
>  
>  source "drivers/uio/Kconfig"
> -
> -source "drivers/lguest/Kconfig"
>  endmenu
> diff -r c2893801de2a drivers/kvm/Kconfig
> --- a/drivers/kvm/Kconfig	Fri Sep 14 13:24:46 2007 +1000
> +++ b/drivers/kvm/Kconfig	Fri Sep 14 13:32:22 2007 +1000
> @@ -1,21 +1,12 @@
>  #
>  # KVM configuration
>  #
> -menuconfig VIRTUALIZATION
> -	bool "Virtualization"
> +menu "Virtualization"
>  	depends on X86
> -	default y
> -	---help---
> -	  Say Y here to get to see options for virtualization guest drivers.
> -	  This option alone does not add any kernel code.
> -
> -	  If you say N, all options in this submenu will be skipped and disabled.
> -
> -if VIRTUALIZATION
>  
>  config KVM
>  	tristate "Kernel-based Virtual Machine (KVM) support"
> -	depends on X86 && EXPERIMENTAL
> +	depends on EXPERIMENTAL
>  	select ANON_INODES
>  	---help---
>  	  Support hosting fully virtualized guest machines using hardware
> @@ -45,4 +36,8 @@ config KVM_AMD
>  	  Provides support for KVM on AMD processors equipped with the AMD-V
>  	  (SVM) extensions.
>  
> -endif # VIRTUALIZATION
> +# OK, it's a little counter-intuitive to do this, but it puts it neatly under
> +# the virtualization menu.
> +source drivers/lguest/Kconfig
> +
> +endmenu


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
