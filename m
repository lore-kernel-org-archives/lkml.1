Return-Path: <linux-kernel-owner+w=401wt.eu-S1756189AbZLXRQM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189AbZLXRQM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 12:16:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753071AbZLXRQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 12:16:10 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:32920 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbZLXRQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 12:16:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=Q8WhRzgYFKWcN1VMxKRMQqsMz6COHluUHMlqhjnHiw1iE0hPT9PB/7iguwm8yO181K
         UYekG8A6WLr8t5clcPVS5yZBK4Ubb/owj9B7QVe0OODkuWTwqmP4NxVn0xieObiGptvQ
         lwPDfEgFzAkhAPAMOd55R5fwnQbFXNONHfgOM=
MIME-Version: 1.0
In-Reply-To: <1261647565.4937.177.camel@laptop>
References: <20091224182630.3DCB.A69D9226@jp.fujitsu.com> <1261647565.4937.177.camel@laptop>
From: Ulrich Drepper <drepper@gmail.com>
Date: Thu, 24 Dec 2009 09:15:47 -0800
Message-ID: <a36005b50912240915u48f326efh1d2c49980e79609c@mail.gmail.com>
Subject: Re: [PATCH] futex: Fix ZERO_PAGE cause infinite loop
To: Peter Zijlstra <peterz@infradead.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Darren Hart <dvhltc@us.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 24, 2009 at 01:39, Peter Zijlstra <peterz@infradead.org> wrote:
> What I mean is, all (?) futex ops assume userspace actually wrote
> something to the address in question to begin with, therefore it can
> never be the zero page.

In practice today this is likely always the case.  But it doesn't have
to be like that.  In theory a zero-initialized futex is a reasonable
object on which to wait.  You should not preclude this from happening
just because it's not done like this today.
