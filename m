Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757347Ab0BEUSA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 15:18:00 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:49794 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561Ab0BEUR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 15:17:59 -0500
To: Sven Joachim <svenjoac@gmx.de>
Cc: hadi@cyberus.ca, Randolf Pohl <randolf.pohl@gmx.de>, gregkh@suse.de,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [46/74] net: restore ip source validation
References: <20100205143441.280460@gmx.net> <1265381514.5661.1.camel@bigi>
	<87wryr4qkk.fsf@turtle.gmx.de>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 05 Feb 2010 12:17:50 -0800
In-Reply-To: <87wryr4qkk.fsf@turtle.gmx.de> (Sven Joachim's message of "Fri\, 05 Feb 2010 17\:04\:11 +0100")
Message-ID: <m1mxzn8mj5.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sven Joachim <svenjoac@gmx.de> writes:

> On 2010-02-05 15:51 +0100, jamal wrote:
>
>> The problem is elsewhere. Here's the fix.
>>
>> --
>> diff --git a/kernel/sysctl_check.c b/kernel/sysctl_check.c
>> index b6e7aae..469193c 100644
>> --- a/kernel/sysctl_check.c
>> +++ b/kernel/sysctl_check.c
>> @@ -220,6 +220,7 @@ static const struct trans_ctl_table
>> trans_net_ipv4_conf_vars_table[] = {
>>         { NET_IPV4_CONF_PROMOTE_SECONDARIES,    "promote_secondaries" },
>>         { NET_IPV4_CONF_ARP_ACCEPT,             "arp_accept" },
>>         { NET_IPV4_CONF_ARP_NOTIFY,             "arp_notify" },
>> +       { NET_IPV4_CONF_SRC_VMARK,              "src_valid_mark" },
>>         {}
>>  };
>> ---
>
> Well spotted, that fixes it.  Your mailer is broken however, it
> converted tabs into spaces, so I had to add the changed line manually.

Bah.  That DEVINET_SYSCTL_ENTRY requires having a binary sysctl
assigned, just to use as an index.

Which of course trips over all of the fine checks in sysctl_check.c to
keep people from assigning new binary sysctls by accident.

That is the only place in the kernel where he have that problem, I wonder
how much work it will be to finish untangling.

Eric
