Return-Path: <linux-kernel-owner+w=401wt.eu-S1754877AbYARI3E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877AbYARI3E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 03:29:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754133AbYARI2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 03:28:53 -0500
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:39249 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753910AbYARI2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 03:28:52 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Utl6HXg8aUWlI36iM/8111XYwrpihGqWgDhsgJJhJTVOdvCLH3yFQsJQ77oDIkJhXm4nV6m1nW9++Rz5+8CMvUZeuCw7j0bJhAMmSDrtTJdl5sNXd8HjhAmSfx6p8Cm8c/i7fLxU9lrwP9AuORMXiNlsb2xF7uKvYAeTqFDHxbU=  ;
X-YMail-OSG: BBT3eDgVM1kW3dDlHFDDdvQ4aOvgJt9NdveXWIHQM9v_I8ofGITZX73kaYeQPBDlofenJT1tYA--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: "stephane eranian" <eranian@googlemail.com>
Subject: Re: runqueue locks in schedule()
Date: Fri, 18 Jan 2008 19:28:42 +1100
User-Agent: KMail/1.9.5
Cc: "Peter Zijlstra" <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       ia64 <linux-ia64@vger.kernel.org>,
       "Stephane Eranian" <eranian@gmail.com>,
       "Corey J Ashford" <cjashfor@us.ibm.com>, "Ingo Molnar" <mingo@elte.hu>
References: <7c86c4470801161629t3870da59hb6ac371c44126b07@mail.gmail.com> <200801181307.53026.nickpiggin@yahoo.com.au> <7c86c4470801172233s333b5993q8b10e37f8ad151d@mail.gmail.com>
In-Reply-To: <7c86c4470801172233s333b5993q8b10e37f8ad151d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801181928.43249.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 January 2008 17:33, stephane eranian wrote:
> Nick,

> > It is arch specific. If an architecture wants interrupts on during
> > context switch, or runqueue unlocked, then they set it (btw
> > INTERRUPTS_ON_CTXSW also implies UNLOCKED_CTXSW).
>
> Yes , I noticed that. I am only interested in UNLOCKED_CTXSW.
> But it appears that the approach suggested my Peter does work. We are
> running some tests.

OK, that might be OK.


> > Although, eg on x86, you would hold off interrupts and runqueue lock for
> > slightly less time if you defined those, it results in _slightly_ more
> > complicated context switching... although I did once find a workload
> > where the reduced runqueue contention improved throughput a bit, it is
> > not much problem in general to hold the lock.
>
> By complicated you mean that now you'd have to make sure you don't
> need to access runqueue data?

Well, not speaking about the arch-specific code (which may involve
more complexities), but the core scheduler needs the
task_struct->oncpu variable wheras that isn't required if the
runqueue is locked while switching tasks.
