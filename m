Return-Path: <linux-kernel-owner+w=401wt.eu-S1758608AbXI2Mp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758608AbXI2Mp5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 08:45:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754744AbXI2MpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 08:45:23 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:46252 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751817AbXI2MpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 08:45:21 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=P4svNlGyDbLM85ewRCUHtKW15blFIAQbUnv5AmDmSdeUXz5iWT/7/fwmq/ArnyKPryTNqI3MnAYgo1sNVBZ3hf07h459crq5yRKiuTxkZqty1iApr1MnOPcHF7UOBXknAMNS7gdEowZusghY7i8rCGHz11hhOoGncGsfdnuAOKM=  ;
X-YMail-OSG: FIC6MqEVM1kQ.mTBrRU.Vpcceu3SMQIMShti_ewqcNDFDGXEJGmbT4lKAlV_vS5aoNKLficpyA--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Krzysztof Oledzki <olel@ans.pl>
Subject: Re: Strange system hangs
Date: Sat, 29 Sep 2007 06:14:02 +1000
User-Agent: KMail/1.9.5
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.64.0709281005340.17152@bizon.gios.gov.pl>
In-Reply-To: <Pine.LNX.4.64.0709281005340.17152@bizon.gios.gov.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200709290614.02918.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 September 2007 18:42, Krzysztof Oledzki wrote:
> Hello,
>
> I am experiencing weird system hangs. Once about 2-5 weeks system freezes
> and stops accepting remote connections, so it is no longer possible to
> connect to most important services: smtp (postfix), www (squid) or even
> ssh. Such connection is accepted but then it hangs.
>
> What is strange, that previously established ssh session is usable. It is
> possible to work on such system until you do something stupid like "less
> /var/log/all.log". Using strace I found that process blocks on:

Is this a regression? If so, what's the most recent kernel that didn't show
the problem?

The symptoms could be consistent with some place doing a
balance_dirty_pages while holding a lock that is required for IO, but I can't
see a smoking gun (you've got contention on i_mutex, but that should be
OK).

Can you see if there is any memory under writeback that isn't being
completed (sysrq+M), also a list the locks held after the hang might be
helpful (compile in lockdep and sysrq+D)

Is anything currently running? (sysrq+P and even a full sysrq+T task list
could be useful).

Are any IO errors occurring at all?

Thanks,
Nick
