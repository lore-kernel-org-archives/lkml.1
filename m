Return-Path: <linux-kernel-owner+w=401wt.eu-S1758221AbYFQVDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758221AbYFQVDd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 17:03:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755407AbYFQVDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 17:03:25 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:63662 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755278AbYFQVDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 17:03:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=b9Zl3CH1EsJRQyrsH5gqCybN/5HsHQCv95B1Gc5fVT+GnpvMHE1tSJSAwEEE96U6zS
         EpPB6vQfCwf4NnPXPufIACpgG7x+1EvFyd7oJd5kIIMBgLBG/aZ/+rYIBJY+DMkV7G9n
         i9proWIvVzXQHhK1kbGacm/LQI0XQGGRA4zPQ=
Message-ID: <b647ffbd0806171403o327c1b93v8ffb2593d30e3ba3@mail.gmail.com>
Date: Tue, 17 Jun 2008 23:03:21 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: [BUG: NULL pointer dereference] cgroups and RT scheduling interact badly.
Cc: "Daniel K." <dk@uw.no>, mingo@elte.hu, menage@google.com,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <1213732878.3223.95.camel@lappy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <485445AE.2010602@uw.no> <1213612447.16944.99.camel@twins>
	 <4856671B.1020304@uw.no> <1213624312.16944.104.camel@twins>
	 <1213627148.16944.106.camel@twins> <485682B0.8010805@uw.no>
	 <1213629536.16944.109.camel@twins> <1213692557.16944.153.camel@twins>
	 <4857AD38.2090601@uw.no>
	 <1213732878.3223.95.camel@lappy.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/6/17 Peter Zijlstra <peterz@infradead.org>:
> On Tue, 2008-06-17 at 14:25 +0200, Daniel K. wrote:
>> Peter Zijlstra wrote:
>> > How's this [patch] work for you? (includes the previuos patchlet too)
>>
>> Thanks,
>>
>> this patch fixed the obvious problem, namely
>>
>> # echo $$ > /dev/cgroup/burn/oops/tasks
>> # schedtool -R -p 1 -e burnP6 &
>>
>> now works again. However, the last step below
>>
>> # echo $$ > /dev/cgroup/tasks
>> # burnP6 &
>> [1] 3414
>> # echo 3414 > /dev/cgroup/burn/oops/tasks
>> # schedtool -R -p 1 3414
>>
>> gives this new and shiny Oops instead.
>
> Whilst I'm gracious for your testing, I truly hope you're done breaking
> my stuff ;-)
>
> How's this for you?

FYI, I could reproduce a crash and this patch fixes it indeed.


-- 
Best regards,
Dmitry Adamushko
