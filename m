Return-Path: <linux-kernel-owner+w=401wt.eu-S1755270AbYBLV6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270AbYBLV6p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 16:58:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752076AbYBLV6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 16:58:36 -0500
Received: from wx-out-0506.google.com ([66.249.82.238]:25971 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbYBLV6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 16:58:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=R0jsGBtdceAVZOVTkms6zfRFKlkIwLQMtB4h36mSHkelr4dYvfTXICURQc/IPM96+PcSfV+pQ+zbRSid7AXFAz0vhlOoo12+cMWxmCTtgyqt96OR5KwhV1bkhV9fX8ssq3mNf1TCZr6LaFshU6Wejukp1A/UJ2hGrrEjC4wUgF8=
Date: Wed, 13 Feb 2008 00:58:23 +0300
To: Kohei KaiGai <kaigai@ak.jp.nec.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       "Andrew G. Morgan" <morgan@kernel.org>, akpm@osdl.org,
       jmorris@namei.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH] exporting capability code/name pairs (try #4)
Message-ID: <20080212215823.GB2144@martell.zuzino.mipt.ru>
References: <47997122.3070504@ak.jp.nec.com> <479990A1.3050103@kernel.org> <4799CAE0.7010400@ak.jp.nec.com> <47A2AB60.5000403@ak.jp.nec.com> <20080204162103.GA20130@sergelap.ibm.com> <47A91B00.9080301@ak.jp.nec.com> <20080206050805.GD3258@sergelap.austin.ibm.com> <47AC23F1.5030300@ak.jp.nec.com> <20080208192343.GA15571@martell.zuzino.mipt.ru> <47B0F1EE.7040003@ak.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B0F1EE.7040003@ak.jp.nec.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 10:10:06AM +0900, Kohei KaiGai wrote:
> Alexey Dobriyan wrote:
> >On Fri, Feb 08, 2008 at 06:42:09PM +0900, Kohei KaiGai wrote:
> >>[kaigai@saba ~]$ ls -R /sys/kernel/capability/
> >>/sys/kernel/capability/:
> >>codes  names  version
> >>
> >>/sys/kernel/capability/codes:
> >>0  10  12  14  16  18  2   21  23  25  27  29  30  32  4  6  8
> >>1  11  13  15  17  19  20  22  24  26  28  3   31  33  5  7  9
> >>
> >>/sys/kernel/capability/names:
> >>cap_audit_control    cap_kill              cap_net_raw     cap_sys_nice
> >>cap_audit_write      cap_lease             cap_setfcap     cap_sys_pacct
> >>cap_chown            cap_linux_immutable   cap_setgid      cap_sys_ptrace
> >>cap_dac_override     cap_mac_admin         cap_setpcap     cap_sys_rawio
> >>cap_dac_read_search  cap_mac_override      cap_setuid      
> >>cap_sys_resource
> >>cap_fowner           cap_mknod             cap_sys_admin   cap_sys_time
> >>cap_fsetid           cap_net_admin         cap_sys_boot    
> >>cap_sys_tty_config
> >>cap_ipc_lock         cap_net_bind_service  cap_sys_chroot
> >>cap_ipc_owner        cap_net_broadcast     cap_sys_module
> >>[kaigai@saba ~]$ cat /sys/kernel/capability/codes/20
> >>cap_sys_pacct
> >>[kaigai@saba ~]$ cat /sys/kernel/capability/names/cap_mknod
> >>27
> >>[kaigai@saba ~]$
> >>--------------------------------------------------------
> >>Any comment please.
> >
> >You don't like 1 (one) /proc/capabilities, why?
> 
> I have no preference whether a single /proc/capabilities, or the current 
> approach.
> However, this idea requires a bit more cost to lookup a capability not 
> sequencially.

And I'm sure far less memory wasted at runtime.

Also, adding config option for one file/directory seems ridiculous to
me. And changelog completely fails to mention why it is useful to lookup
capabilities by name and number -- CAP_SYS_* numbers are part of ABI,
they won't change.
