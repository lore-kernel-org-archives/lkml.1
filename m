Return-Path: <linux-kernel-owner+w=401wt.eu-S1760074AbZFTB3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760074AbZFTB3A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 21:29:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759248AbZFTB2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 21:28:52 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:40541 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758401AbZFTB2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 21:28:51 -0400
To: David Rientjes <rientjes@google.com>
Cc: David Miller <davem@davemloft.net>, eric.dumazet@gmail.com,
       jpiszcz@lucidpixels.com, linux-kernel@vger.kernel.org
References: <alpine.DEB.2.00.0906180935130.2894@chino.kir.corp.google.com>
	<20090618.120034.246557840.davem@davemloft.net>
	<alpine.DEB.2.00.0906181212380.10979@chino.kir.corp.google.com>
	<20090618.123708.78849607.davem@davemloft.net>
	<m1ljnoyn0e.fsf@fess.ebiederm.org>
	<alpine.DEB.2.00.0906191524470.30455@chino.kir.corp.google.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 19 Jun 2009 18:28:49 -0700
In-Reply-To: <alpine.DEB.2.00.0906191524470.30455@chino.kir.corp.google.com> (David Rientjes's message of "Fri\, 19 Jun 2009 15\:37\:17 -0700 \(PDT\)")
Message-ID: <m1hbybwv5a.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: rientjes@google.com, linux-kernel@vger.kernel.org, jpiszcz@lucidpixels.com, eric.dumazet@gmail.com, davem@davemloft.net
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;David Rientjes <rientjes@google.com>
X-Spam-Relay-Country: 
X-Spam-Report: *  7.0 XM_URI_RBL URI's domain appears in surbl.xmission.com
	*      [URIs: lkml.org]
	* -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [patch] ipv4: don't warn about skb ack allocation failures
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes <rientjes@google.com> writes:

> On Fri, 19 Jun 2009, Eric W. Biederman wrote:
>
>> But Mr. Reintjes if you really want the traces I can set up 
>> an script to email them to you every time it happens.  Say about
>> 1 a minute from my paltry little farm of machines.
>> 
>
> Perhaps you missed my email where I suggested emitting the page allocation 
> warnings only when CONFIG_DEBUG_VM is enabled.  It's at 
> http://lkml.org/lkml/2009/6/18/355.
>
> We can then keep the __GFP_NOFAIL flag to indicate that the warnings 
> should never be emitted for that allocation, regardless of the .config.
>
> It's funny, though, that the problem that originally started this thread 
> was quickly diagnosed because of these messages.  As far as I know, my 
> suggestion to increase /proc/sys/vm/dirty_background_ratio to kick pdflush 
> earlier has prevented the slab allocation failures and not required 
> delayed acks for nfsd.

increase?

Perhaps then the problem is simply dirty_background_ratio.  Is the vm
not properly autotuning?

With a 50MB/s disk I wonder what the proper window size is.  Several
gigabytes as implied by a 5% or a 10% dirty_background_ratio seems
absurd.  TCP sockets seem to get along fine with even large latencies
and windows measured in megabytes not gigabytes.

This does explain a few things.

Eric
