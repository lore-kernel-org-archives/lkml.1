Return-Path: <linux-kernel-owner+w=401wt.eu-S1761238AbZDHCl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761238AbZDHCl2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 22:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756508AbZDHClQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 22:41:16 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:49333 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbZDHClP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 22:41:15 -0400
To: Shen Feng <shen@cn.fujitsu.com>
Cc: davem@davemloft.net, Andrew Morton <akpm@linux-foundation.org>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] IPv4/IPv6: update sysctl files
References: <49DC091C.6070708@cn.fujitsu.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 07 Apr 2009 19:41:10 -0700
In-Reply-To: <49DC091C.6070708@cn.fujitsu.com> (Shen Feng's message of "Wed\, 08 Apr 2009 10\:17\:00 +0800")
Message-ID: <m11vs3rho9.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: shen@cn.fujitsu.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, akpm@linux-foundation.org, davem@davemloft.net
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shen Feng <shen@cn.fujitsu.com> writes:

> Now the following sysctl files in /proc/sys/net/ipv4 are used by
> both IPv4 and IPv6.
> tcp_mem  tcp_rmem  tcp_wmem
> udp_mem  udp_rmem_min  udp_wmem_min
> Putting them in /proc/sys/net/ipv4 is not a good choice.
>
> So move tcp_mem  tcp_rmem  tcp_wmem to /proc/sys/net/tcp and
> move udp_mem  udp_rmem_min  udp_wmem_min to /poc/sys/net/udp.

How badly does this blow up when you enable sysctl_check?
You just enabled new binary sysctl mappings, which is big no-no.

Further how many user space scripts did you break that touch those
files?  This is an ABI change.

Eric
