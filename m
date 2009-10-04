Return-Path: <linux-kernel-owner+w=401wt.eu-S1757469AbZJDQhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469AbZJDQhq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 12:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757386AbZJDQhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 12:37:45 -0400
Received: from mail-pz0-f179.google.com ([209.85.222.179]:36845 "EHLO
	mail-pz0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163AbZJDQhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 12:37:45 -0400
Message-ID: <4AC8CF32.8060108@anirban.org>
Date: Sun, 04 Oct 2009 09:37:06 -0700
From: Anirban Sinha <ani@anirban.org>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.1.4pre) Gecko/20090915 Thunderbird/3.0b4
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Darren Hart <dvhltc@us.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Kaz Kylheku <kaz@zeugmasystems.com>,
       Anirban Sinha <asinha@zeugmasystems.com>
Subject: Re: futex question
References: <DDFD17CC94A9BD49A82147DDF7D545C501FD7F97@exchange.ZeugmaSystems.local> <20091001092218.GH15345@elte.hu> <DDFD17CC94A9BD49A82147DDF7D545C501FD8409@exchange.ZeugmaSystems.local> <4AC68F13.8050601@us.ibm.com> <alpine.LFD.2.00.0910041031330.2646@localhost.localdomain> <DDFD17CC94A9BD49A82147DDF7D545C501F457C5@exchange.ZeugmaSystems.local>
In-Reply-To: <DDFD17CC94A9BD49A82147DDF7D545C501F457C5@exchange.ZeugmaSystems.local>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> 1) What caused you to instrument this path in the first place?  Were you
>> seeing some unexpected behavior?
>>
>> 2) I wonder why we would need to clear the robust list, but I don't see other
>> things like pi_blocked_on, etc. in execve being cleared.  I'm looking into
>> this now (perhaps we don't do the same cleanup, need to check).... have to get
>> on the plane...
> 
> Hmm, just setting the robust list pointer to NULL fixes the problem at
> hand, but I wonder whether we need to call exit_robust_list() as
> well. 

hmm. That is an interesting thought. But I wonder if acquiring a lock and then exec()ing in the critical section is a legal thing to do. It does not feel right. Currently, with or without my change, such a thing would indefinitely block other waiters on the same futex.  

Ani
