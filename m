Return-Path: <linux-kernel-owner+w=401wt.eu-S1755128AbYLIUGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128AbYLIUGp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 15:06:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754503AbYLIUGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 15:06:36 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:27745 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754396AbYLIUGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 15:06:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=UJmVxgv/JUFjq2FLYwDuyBM3CvZ8ck5rLoGubeALjRjvTNJ6WcV+xlSvYDsjL4hQ45
         X6amkzIohx7VUI7w/JvzR5fsEsDJGAvRfH8KL2+Jue/LLfd/cuzwHYX4636TjvfzLqOJ
         OMT+Mo7kc4QJm9NpsA+HIgbgGTjqo3dyFFqgM=
Message-ID: <3efb10970812091206l2e6a17a6tc475a57b942cd28f@mail.gmail.com>
Date: Tue, 9 Dec 2008 21:06:34 +0100
From: "Remy Bohmer" <linux@bohmer.net>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [ANNOUNCE] The -rt git tree
Cc: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
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
X-Google-Sender-Auth: 298e982e607689f5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Steven,

It all sounds good!

But, I was wondering, why using the scripts to convert the spinlocks
over and over, instead of pushing only the new lock API to mainline
asap? That would save a lot of conversion complexity and sounds like
migrating the RT patch to mainline much easier. It sounds to me like a
major rename action, and as long as there is only a spinlock behind
the new API, there is a very low risk in breaking things.
Later on the rt-mutex can be integrated behind the new API. In the
mean time everybody can get used to the new locking API.
That would save complexity and improve stability of the rt-patchset,
because it does not need to be figured out over and over if there are
new locks in new code that need to be converted back to spinlocks...
(In fact we only need to focus from there on new code that use the
spinlock API, and if it is really required to use that.)

Kind Regards,

Remy

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
>
> -- Steve
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
