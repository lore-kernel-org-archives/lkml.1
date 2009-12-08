Return-Path: <linux-kernel-owner+w=401wt.eu-S1752846AbZLHG3B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846AbZLHG3B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 01:29:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752653AbZLHG3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 01:29:00 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:24669 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbZLHG27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 01:28:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=f6AAiIPWVtlp7aBczB3v60pciDxk+8no3ZsmY17rBtzykFvD4zHw2CpB1NFriXyAvw
         SKHso6iH2Ump4YALpw2o/LtL+HqVh7d+WHI3s9jHgqt/aKAUiijdnFmK2PwCETI6jpwP
         hmo6ClOBPXF//6b0A6wFnApZZPnkJ8K8uEKqQ=
MIME-Version: 1.0
In-Reply-To: <20091208053851.GA12383@elte.hu>
References: <20091208121145.B58D.A69D9226@jp.fujitsu.com> <20091208044605.GA32669@elte.hu> 
	<20091208135010.B5A8.A69D9226@jp.fujitsu.com> <20091208053851.GA12383@elte.hu>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Tue, 8 Dec 2009 01:28:45 -0500
Message-ID: <3e8340490912072228m70368001v2487bd745ff208b3@mail.gmail.com>
Subject: Re: [PATCH v6] Added PR_SET_PROCTITLE_AREA option for prctl()
To: Ingo Molnar <mingo@elte.hu>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Ulrich Drepper <drepper@redhat.com>, Timo Sirainen <tss@iki.fi>,
       WANG Cong <xiyou.wangcong@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 8, 2009 at 12:38 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
>
>> > The feature looks useful, but the choice of a prctl as an API is strange
>> > - it limits us to the current task only - while the ability to set
>> > arguments for another task looks a more generic (and potentially more
>> > useful) solution.
>>
>> No. It's impossible.
>> /proc/{pid}/cmdline read user process's memory. iow, this prctl() don't
>> receive string, it receive virtual address itself. [...]
>
> it's not 'impossible' at all, you yourself mention ptrace:

If another process is going to use ptrace to inject the cmdline string
into the victim's address space, it can also temporarily hijack a
thread to run prctl() on its behalf...
