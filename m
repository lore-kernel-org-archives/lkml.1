Return-Path: <linux-kernel-owner+w=401wt.eu-S1754768AbYLISiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768AbYLISiR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 13:38:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753998AbYLISiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 13:38:00 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:60349 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706AbYLISh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 13:37:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Ref3HFWjudu3/XIV2FbkUFpT4+63TL6UUi07Fb2RFV1t846R3Y8AI1mvztnoXZlo1p
         3Z0QkOx5v3CwqbfLA7Y4MGHtvjdvjg1HTDJX7ZEeG5H1zVmd38DztmPMGS+yvMDod/vA
         bmy/DcVxZQL5iuZNi4v7VUoe+jFgCIZAoJURQ=
Message-ID: <c62985530812091037k2ee4f5f3u1f3965c4f994bc98@mail.gmail.com>
Date: Tue, 9 Dec 2008 19:37:58 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [ANNOUNCE] The -rt git tree
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>,
       "Peter Zijlstra" <peterz@infradead.org>,
       "Clark Williams" <clark.williams@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Arnaldo Carvalho de Melo" <acme@ghostprotocols.net>,
       "Gregory Haskins" <ghaskins@novell.com>,
       "Darren Hart" <dvhltc@us.ibm.com>
In-Reply-To: <alpine.DEB.1.10.0812091248020.19115@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.DEB.1.10.0812090946210.16798@gandalf.stny.rr.com>
	 <c62985530812090908i38c5a7bflcbbcce6c8b9cd2f9@mail.gmail.com>
	 <alpine.DEB.1.10.0812091248020.19115@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/9 Steven Rostedt <rostedt@goodmis.org>:
>
> On Tue, 9 Dec 2008, Fr?d?ric Weisbecker wrote:
>>
>> Hi Steve.
>>
>> That's a good news.
>>
>> But after converting these spinlocks into lock_t, how will you synchronize with
>> the mainline on each release? You will have a huge amount of conflicts
>> at every merges...
>
> This is why master is separate from rt-master. The rt-master will grow
> like tip/master does. But the master will be recreated each time.
> Basically, the creation of master is this:
>
>
> git checkout master
> git reset --hard rt-master
> ./scripts/convert-spinlocks
> git commit -a -m 'Convert all spinlocks to lock_t'
> ./scripts/convert-locks
> git commit -a -m 'Convert some locks back to spinlock_t'
>
> Thus we do not need to worry about the conflicts caused by the lock
> conversion. That will be done automatically each time we create a new
> master.


I see... A lot is done with the scripts. I think I will follow closely
what happens on this tree :-)
Thanks!
