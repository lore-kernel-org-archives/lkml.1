Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932972Ab0BHDMy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 22:12:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7969 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750965Ab0BHDMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 22:12:52 -0500
Message-ID: <4B6F81EF.4070103@redhat.com>
Date: Mon, 08 Feb 2010 11:15:59 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
CC: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       opurdila@ixiacom.com, eric.dumazet@gmail.com,
       linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
       nhorman@tuxdriver.com, linux-sctp@vger.kernel.org, davem@davemloft.net
Subject: Re: [RFC Patch v2] net: reserve ports for applications using fixedport
 numbers
References: <20100204101533.4619.34599.sendpatchset@localhost.localdomain>	<201002041959.JEG43202.JQOFHFOVSFMtLO@I-love.SAKURA.ne.jp>	<4B6BA16E.3010002@redhat.com> <201002052021.CIC81776.QVSMJOLtFOFFHO@I-love.SAKURA.ne.jp>
In-Reply-To: <201002052021.CIC81776.QVSMJOLtFOFFHO@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa wrote:
> Cong Wang wrote:
>> Oh, IIUC, TOMOYO is something like SELinux?
> 
> Yes. It is a policy based mandatory access control implementation which is
> applied to not only non root users but also root user. If MAC is enabled,
> root user cannot freely modify via sysctl() or /proc/sys interface.
> 
>> So, it is somewhat weird to let users to use TOMOYO to reserve
>> the ports with MAC.
> 
> To add reserved port
> 
> echo deny_autobind 0-1023 | ccs-loadpolicy -e
> echo deny_autobind 3128 | ccs-loadpolicy -e
> echo deny_autobind 8080 | ccs-loadpolicy -e
> 
> and to delete reserved port
> 
> echo delete deny_autobind 0-1023 | ccs-loadpolicy -e
> echo delete deny_autobind 3128 | ccs-loadpolicy -e
> echo delete deny_autobind 8080 | ccs-loadpolicy -e
> 
> That's all. Quite easy.


Hmm, but you are solving a non-security problem with a security
tool, doesn't this look weird? ;-)

> 
>> For normal users /proc interface seems more friendly.
> 
> I think /proc/sys/net/ipv4/ip_local_reserved_ports interface wants
> "struct list_head" for handling multiple sets of min/max pairs. I'm using
> http://tomoyo.sourceforge.jp/cgi-bin/lxr/source/security/ccsecurity/autobind.c#L29
> for that purpose.


Yes, but I didn't plan to add multiple range support for
ip_local_reserved_ports, like ip_local_port_range.

Having that will be better but needs more efforts.

Thanks.
