Return-Path: <linux-kernel-owner+w=401wt.eu-S1758715AbXERHuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758715AbXERHuS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 03:50:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755525AbXERHuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 03:50:07 -0400
Received: from as4.cineca.com ([130.186.84.213]:39964 "EHLO as4.cineca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755509AbXERHuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 03:50:06 -0400
Message-ID: <464D5AA4.8080900@users.sourceforge.net>
From: Andrea Righi <righiandr@users.sourceforge.net>
Reply-To: righiandr@users.sourceforge.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.3) Gecko/20070326 Thunderbird/2.0.0.0 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [RFC] log out-of-virtual-memory events
References: <464C81B5.8070101@users.sourceforge.net> <464C9D82.60105@redhat.com>
In-Reply-To: <464C9D82.60105@redhat.com>
X-Enigmail-Version: 0.95.0
OpenPGP: id=77CEF397;
	url=keyserver.veridis.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Date: Fri, 18 May 2007 09:50:03 +0200 (MEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:
> Andrea Righi wrote:
>> I'm looking for a way to keep track of the processes that fail to
>> allocate new
>> virtual memory. What do you think about the following approach
>> (untested)?
>
> Looks like an easy way for users to spam syslogd over and
> over and over again.
>
> At the very least, shouldn't this be dependant on print_fatal_signals?
>

Anyway, with print-fatal-signals enabled a user could spam syslogd too, simply
with a (char *)0 = 0 program, but we could always identify the spam attempts
logging the process uid...

In any case, I agree, it should depend on that patch...

What about adding a simple msleep_interruptible(SOME_MSECS) at the end of
log_vm_enomem() or, at least, a might_sleep() to limit the potential spam/second
rate?

-Andrea
