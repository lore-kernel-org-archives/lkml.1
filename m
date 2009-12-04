Return-Path: <linux-kernel-owner+w=401wt.eu-S1757391AbZLDVmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391AbZLDVmx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 16:42:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757310AbZLDVmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 16:42:52 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:60335 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757298AbZLDVmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 16:42:51 -0500
To: William Allen Simpson <william.allen.simpson@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       netdev@vger.kernel.org
References: <20091204194301.ca77fe40.sfr@canb.auug.org.au>
	<4B18FDA3.5060601@gmail.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 04 Dec 2009 13:42:49 -0800
In-Reply-To: <4B18FDA3.5060601@gmail.com> (William Allen Simpson's message of "Fri\, 04 Dec 2009 07\:16\:35 -0500")
Message-ID: <m1vdgmbeli.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: linux-next: manual merge of the sysctl tree with the net tree
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

William Allen Simpson <william.allen.simpson@gmail.com> writes:

> Stephen Rothwell wrote:
>> Hi Eric,
>>
>> Today's linux-next merge of the sysctl tree got a conflict in
>> net/ipv4/sysctl_net_ipv4.c between commit
>> 519855c508b9a17878c0977a3cdefc09b59b30df ("TCPCT part 1c:
>> sysctl_tcp_cookie_size, socket option TCP_COOKIE_TRANSACTIONS") from the
>> net tree and commit f8572d8f2a2ba75408b97dc24ef47c83671795d7 ("sysctl
>> net: Remove unused binary sysctl code") from the sysctl tree.
>>
>> I fixed it up (see below) and can carry the fix as necessary.
>
> Hi, I'm not Eric, but it's my TCPCT patch -- is there something more
> that I need to do?
>
> Adding a sysctl was my very first query to Linux lists.  I thought
> everything was covered in that and subsequent threads.

My apologies for not giving you a heads up earlier.

You initially ran into the problem in sysctl_check where you added a
new binary sysctl and you had errors.  That works to keep people from
adding new binary sysctl but as you experienced it is not the most
obvious way of communicating.

In my sysctl tree I have written a compatibility layer for all of the
existing binary sysctl handlers, and have removed the .ctl_name and
.strategy fields, that used to be used for implementing binary
sysctls.

In the best case scenario you could have seen that coming and not
included the .ctl_name line in your patch.  Then there would have been
a trivial conflict that would have required no changes to fixup.
However since I removed .ctl_name from before and after your new entry
a minor merge conflict was inevitable.

The price it seems for multiple independent development trees are the
occasionally conflicts in trees hosting kernel wide cleanups and fixes.

Eric
