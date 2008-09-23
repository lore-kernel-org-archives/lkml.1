Return-Path: <linux-kernel-owner+w=401wt.eu-S1754201AbYIWANS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201AbYIWANS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 20:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753368AbYIWANI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 20:13:08 -0400
Received: from smtp-out.google.com ([216.239.33.17]:12467 "EHLO
	smtp-out3.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753360AbYIWANH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 20:13:07 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references:x-gmailtapped-by;
	b=QOmvVqO93ITrr/pVyACqDCHJ8S2QbIdx5S2GdQBNcIf96SpX9oYPFV+LyW5z0HnyF
	URIP2MooyWsyqa2VTsMVA==
Message-ID: <33307c790809221712x4fbd9781u958c98d4585e92a9@mail.gmail.com>
Date: Mon, 22 Sep 2008 17:12:51 -0700
From: "Martin Bligh" <mbligh@google.com>
To: "Masami Hiramatsu" <mhiramat@redhat.com>
Subject: Re: Unified tracing buffer
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Mathieu Desnoyers" <compudj@krystal.dyndns.org>,
       "Steven Rostedt" <rostedt@goodmis.org>, darren@dvhart.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       systemtap-ml <systemtap@sources.redhat.com>
In-Reply-To: <48D832B6.3010409@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com>
	 <48D7F5E8.3000705@redhat.com>
	 <33307c790809221313s3532d851g7239c212bc72fe71@mail.gmail.com>
	 <48D81B5F.2030702@redhat.com>
	 <33307c790809221616h5e7410f5gc37c262d83722111@mail.gmail.com>
	 <48D832B6.3010409@redhat.com>
X-GMailtapped-By: 172.25.146.18
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> I think we came up with a way to approximate this, using a callback every
>> ms or so as the higher order bits, and a sequential counter in the lower
>> order for those broken platforms.
>
> Sure, that will work.

OK, that'd fix 99% of it, even if we only get time within 1ms or so (but still
good ordering).

>> But perhaps it would be better if we started with a discussion of which
>> platforms can't do global timestamps, and why not? I know some of them
>> are fixable, but perhaps not all.
>
> For example, my laptop (this machine/Core2Duo) doesn't return correct TSC. :-(

Can you define incorrect for me (in this case)?

We had similar problems with some AMD platforms that we can fix by syncing
the TSCs on exit_idle, etc.
