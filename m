Return-Path: <linux-kernel-owner+w=401wt.eu-S1758604AbYBLDkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758604AbYBLDkr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 22:40:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754907AbYBLDkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 22:40:39 -0500
Received: from smtp121.sbc.mail.re3.yahoo.com ([66.196.96.94]:43717 "HELO
	smtp121.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754110AbYBLDki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 22:40:38 -0500
X-YMail-OSG: 6WXaMgEVM1lEqE6mBYT5VC3i.nNjC8E_LLhhm2_ynXISiRPRBDQfDjhldW2a3jsitWDt1RoETfFJI7hCOgTkm__.Fdo7pTSpYfAPzMSIpPAJ24dFegw-
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 11 Feb 2008 21:38:15 -0600
From: serge@hallyn.com
To: "Nick 'Zaf' Clifford" <zaf@nrc.co.nz>
Cc: linux-kernel@vger.kernel.org, SELinux <selinux@tycho.nsa.gov>,
       linux-security-module@vger.kernel.org
Subject: Re: if (2.6.24.1 && capset && bind9) bug()
Message-ID: <20080212033815.GA28437@vino.hallyn.com>
References: <47B03592.20505@nrc.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B03592.20505@nrc.co.nz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Nick 'Zaf' Clifford (zaf@nrc.co.nz):
> Please CC me on any/all replies
> 
> After trying to upgrade to deal with the most recent security issue, I

Judging by the 2.6.24.2 changelog I don't think the 2.6.24.1 kernel you
grabbed has the fix you're looking for...

> have encountered what has to either be me being very tired, or a kernel
> bug. After assuming that it was the former for 3 hours, I now conclude
> I'm more tired, and it has to be the latter.
> 
> Relevant versions:
> Bind: 9.3.4
> Kernel: Linux version 2.6.24.1.cerberus.1 (zaf@cerberus) (gcc version
> 4.1.2 (Ubuntu 4.1.2-0ubuntu4)) #1 SMP Mon Feb 11 20:05:58 NZDT 2008
> Distro: Ubuntu Feisty
> Processor: AMD Athlon
> 
> # cat /proc/cmdline
> root=UUID=0996d997-a1f5-4601-964e-f3e71a477b81 ro quiet splash
> 
> Relevant .config settings (please let me know if more are needed):
> CONFIG_SECURITY=y
> CONFIG_SECURITY_NETWORK=y
> # CONFIG_SECURITY_NETWORK_XFRM is not set
> CONFIG_SECURITY_CAPABILITIES=y
> # CONFIG_SECURITY_FILE_CAPABILITIES is not set
> CONFIG_SECURITY_SELINUX=y
> CONFIG_SECURITY_SELINUX_BOOTPARAM=y
> CONFIG_SECURITY_SELINUX_BOOTPARAM_VALUE=0
> CONFIG_SECURITY_SELINUX_DISABLE=y
> CONFIG_SECURITY_SELINUX_DEVELOP=y
> CONFIG_SECURITY_SELINUX_AVC_STATS=y
> CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
> # CONFIG_SECURITY_SELINUX_ENABLE_SECMARK_DEFAULT is not set
> # CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX is not set
> 
> (Note: tried with CONFIG_SECURITY_CAPABILITIES=n and same result)

Yeah my first thought was enough has been happening on the capabilities
front that it could be an unfortunate patch merge, but 2.6.24.1 looks
ok.  So my next guess would be an selinux change.  Though again i don't
see anything obvious.  Could you tell us what policy you use, and what
context bind is starting in?

> relevant line from strace starting bind:
> # strace -ff named -u bind 2> /tmp/bind.log
> 
> ...
> capset(0x19980330, 0,
> {CAP_DAC_READ_SEARCH|CAP_SETGID|CAP_SETUID|CAP_NET_BIND_SERVICE|CAP_SYS_CHROOT|CAP_SYS_RESOURCE,
> CAP
> _DAC_READ_SEARCH|CAP_SETGID|CAP_SETUID|CAP_NET_BIND_SERVICE|CAP_SYS_CHROOT|CAP_SYS_RESOURCE,
> 0}) = -1 EPERM (Operation not
>  permitted)
> ...
> 
> What have I tried?
> 
> Tried it on two different systems, with the SEC CAP on and off.
> 
> Why do I think this is a kernel bug?
> 
> 1) I revert to older kernel (2.6.22.1), no problems. Upgrade to
> 2.6.24.1. Problems.

Unfortunately that's quite a range...

> 2) Googling for "2.6.24 capset named" produces a lot of comments on the
> mm tree about a breakage. It looked like it was fixed, but I'm obviously
> not sure now.
> 
> 
> So, someone please tell me either that I'm very very tired, and it must
> be my config, or that it IS a kernel bug, and hopefully provide a nice
> little patch to apply.
> 
> Once again, please CC me on replies,
> 
> Thanks,
> Nick
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
