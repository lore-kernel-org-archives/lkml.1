Return-Path: <linux-kernel-owner+w=401wt.eu-S1754554AbZJ0NND@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbZJ0NND (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 09:13:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754271AbZJ0NNB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 09:13:01 -0400
Received: from bizon.gios.gov.pl ([195.187.34.71]:55834 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237AbZJ0NNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 09:13:00 -0400
Date: Tue, 27 Oct 2009 14:12:12 +0100 (CET)
From: Krzysztof Oledzki <ole@ans.pl>
X-X-Sender: ole@bizon.gios.gov.pl
To: Jiri Kosina <jkosina@suse.cz>
cc: Patrick McHardy <kaber@trash.net>, "David S. Miller" <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
       netfilter@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH] netfilter: remove CONFIG_NF_CT_ACCT
In-Reply-To: <alpine.LSU.2.00.0910271337120.19847@wotan.suse.de>
Message-ID: <alpine.LNX.1.10.0910271355540.22510@bizon.gios.gov.pl>
References: <alpine.LSU.2.00.0910221615360.8582@wotan.suse.de> <alpine.LSU.2.00.0910271337120.19847@wotan.suse.de>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1144830174-1999984383-1256649133=:22510"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1144830174-1999984383-1256649133=:22510
Content-Type: TEXT/PLAIN; charset=iso-8859-2; format=flowed
Content-Transfer-Encoding: 8BIT



On Tue, 27 Oct 2009, Jiri Kosina wrote:

> On Thu, 22 Oct 2009, Jiri Kosina wrote:
>
>> I can see several issues with CONFIG_NF_CT_ACCT and I think it should be
>> removed for the following reasons:
>>
>> 1) the netlink seems broken for the (CONFIG_NF_CT_ACCT unset &&
>>    net.netfilter.nf_conntrack_acct set) scenario. In such case,
>>    ctnetlink_nlmsg_size() seems to miscompute the size of the message, as
>>    the CTA_COUNTERS_* are not counted in at all. Seems quite serious on a
>>    first glance.

Indeed, but this code was introduced very much later:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff_plain;h=2732c4e45bb67006fdc9ae6669be866762711ab5

>> 2) It has been marked as deprecated for quite some time, and was supposed
>>    to be removed in 2.6.29, but is apparently still with us.

Because it was decided that it cannot be simply removed so my initial 
patch was rejected.

>> 3) Spits confusing warnings into dmesg.


Yep. :|

>> All this since commit 584015727a3b ("netfilter: accounting rework:
>> ct_extend + 64bit counters (v4)").
>>
>> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
>> ---
>>  Documentation/feature-removal-schedule.txt |    9 ---------
>>  Documentation/kernel-parameters.txt        |    3 +--
>>  net/netfilter/Kconfig                      |   22 ----------------------
>>  net/netfilter/nf_conntrack_acct.c          |   10 ----------
>>  net/netfilter/nf_conntrack_netlink.c       |    2 --
>>  5 files changed, 1 insertions(+), 45 deletions(-)
>
> Has this one been lost? (aka "ping").

-ETOBUSY :|

Also, please read http://lkml.org/lkml/2009/10/15/158

It would be great if you are able to provide a patch that addresses the 
remark about connbytes.

If not, I hope I should be able to deal with this during the weekend, 
eventually. ;)

Best regards,

 				Krzysztof Olêdzki
---1144830174-1999984383-1256649133=:22510--
