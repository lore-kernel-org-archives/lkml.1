Return-Path: <linux-kernel-owner+w=401wt.eu-S1754528AbZFBMzC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528AbZFBMzC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 08:55:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753309AbZFBMyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 08:54:54 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:54053 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197AbZFBMyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 08:54:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Khccoul7rgKPIRZQFzTSRRa1IYtN9vtx3/LIQGwcLQrHxi09vfLzzwdJFqhPz8D1xW
         tNJiapLq5CVrkTE7rVkn18Apj6MR3bE6dnhbh0v+JovJgDuAQ6B0H+b/PhUgI3Szq0V9
         oUcVYwxF6MijpoiKAWzfPrSfRdDDzoQ3kdIDE=
Message-ID: <4A25211C.8050504@gmail.com>
Date: Tue, 02 Jun 2009 14:54:52 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1pre) Gecko/20090525 SUSE/3.0b2-10.1 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>, ebiederm@xmission.com,
       roland@redhat.com, linux-kernel@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/1] signal: make group kill signal fatal
References: <1243198054-13816-1-git-send-email-jirislaby@gmail.com> <20090525000750.GA2301@redhat.com> <4A1AC5A3.9000600@gmail.com> <20090525172033.GA12586@redhat.com> <4A1AE02D.5080701@gmail.com> <20090525225150.GA12362@redhat.com>
In-Reply-To: <20090525225150.GA12362@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2009 12:51 AM, Oleg Nesterov wrote:
> Heh. In this case you have another (long-standing) issue, please note
> the "if (p->flags & PF_EXITING)" check in wants_signal().
> 
> There is no guarantee the signal will wake up the exiting task task.
> Even SIGKILL, even if you use wait_event_interruptible() instead of
> _killable.

Last question, doesn't wait_event_interruptible return immediately in
this case? signal_pending returns true due to non-captured signal which
killed the application and hence we are in the .release under these
special circumstances. I think this is not much expected behavior, is
it? Shouldn't be that signal dequeued/cleared instead?
