Return-Path: <linux-kernel-owner+w=401wt.eu-S1756316AbYBOTi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316AbYBOTi6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 14:38:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752481AbYBOTir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 14:38:47 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55245 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432AbYBOTip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 14:38:45 -0500
Date: Fri, 15 Feb 2008 10:50:03 -0800
From: Greg KH <greg@kroah.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Kohei KaiGai <kaigai@ak.jp.nec.com>, Li Zefan <lizf@cn.fujitsu.com>,
       akpm@osdl.org, "Andrew G. Morgan" <morgan@kernel.org>,
       jmorris@namei.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, adobriyan@gmail.com
Subject: Re: [PATCH] exporting capability code/name pairs (try #5.1)
Message-ID: <20080215185003.GA7495@kroah.com>
References: <20080204162103.GA20130@sergelap.ibm.com> <47A91B00.9080301@ak.jp.nec.com> <20080206050805.GD3258@sergelap.austin.ibm.com> <47AC23F1.5030300@ak.jp.nec.com> <20080212180859.GA12876@sergelap.austin.ibm.com> <47B2A3F3.8060701@ak.jp.nec.com> <47B4ED1B.6070206@ak.jp.nec.com> <47B4F1C5.9010408@cn.fujitsu.com> <47B4FFE0.3000702@ak.jp.nec.com> <20080215183802.GA3925@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080215183802.GA3925@sergelap.austin.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 12:38:02PM -0600, Serge E. Hallyn wrote:
> Quoting Kohei KaiGai (kaigai@ak.jp.nec.com):
> > Li Zefan wrote:
> >  - snip -
> > >> +error1:
> > >> +	kobject_put(capability_kobj);
> > >> +error0:
> > >> +	printk(KERN_ERR "Unable to export capabilities\n");
> > >> +
> > >> +	return 0;
> > > 
> > > Should return -EFXXX ..
> > 
> > Oops,
> > I fixed it as follows. Thanks for your pointed out.
> > 
> > --------
> > This patch enables to export code/name of capabilities supported
> > on the running kernel.
> > 
> > A newer kernel sometimes adds new capabilities, like CAP_MAC_ADMIN
> > at 2.6.25. However, we have no interface to disclose what capabilities
> > are supported on this kernel. Thus, we have to maintain libcap version
> > in appropriate one synchronously.
> > 
> > This patch enables libcap to collect the list of capabilities on
> > run time, and provide them for users.
> > It helps to improve portability of library.
> > 
> > It exports these information as regular files under /sys/kernel/capability.
> > The numeric node exports its name, the symbolic node exports its code.
> > 
> > Please consider to put this patch on the queue of 2.6.25.
> 
> Looks good, except don't you need to put the code in commoncap.c under a
> #ifdef SYSFS?
> 
> thanks,
> -serge
> 
> > 
> > Thanks,
> > ===================================================
> > [kaigai@saba ~]$ ls -R /sys/kernel/capability/
> > /sys/kernel/capability/:
> > codes  names  version
> > 
> > /sys/kernel/capability/codes:
> > 0  10  12  14  16  18  2   21  23  25  27  29  30  32  4  6  8
> > 1  11  13  15  17  19  20  22  24  26  28  3   31  33  5  7  9
> > 
> > /sys/kernel/capability/names:
> > cap_audit_control    cap_kill              cap_net_raw     cap_sys_nice
> > cap_audit_write      cap_lease             cap_setfcap     cap_sys_pacct
> > cap_chown            cap_linux_immutable   cap_setgid      cap_sys_ptrace
> > cap_dac_override     cap_mac_admin         cap_setpcap     cap_sys_rawio
> > cap_dac_read_search  cap_mac_override      cap_setuid      cap_sys_resource
> > cap_fowner           cap_mknod             cap_sys_admin   cap_sys_time
> > cap_fsetid           cap_net_admin         cap_sys_boot    cap_sys_tty_config
> > cap_ipc_lock         cap_net_bind_service  cap_sys_chroot
> > cap_ipc_owner        cap_net_broadcast     cap_sys_module
> > [kaigai@saba ~]$ cat /sys/kernel/capability/version
> > 0x20071026
> > [kaigai@saba ~]$ cat /sys/kernel/capability/codes/30
> > cap_audit_control
> > [kaigai@saba ~]$ cat /sys/kernel/capability/names/cap_sys_pacct
> > 20
> > [kaigai@saba ~]$
> > ===================================================

As you are adding new sysfs entries, please also add the needed
Documentation/ABI/ entries as well.

Also, this code can be cleaned up a lot by just using the basic kobject
attributes, and not rolling your own types here.

thanks,

greg k-h
