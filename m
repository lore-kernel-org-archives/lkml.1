Return-Path: <linux-kernel-owner+w=401wt.eu-S1754810AbZLBAKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810AbZLBAKV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 19:10:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754755AbZLBAKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 19:10:20 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:14056 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329AbZLBAKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 19:10:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=G0AYoXxjQ9Gsp1GeTB7lO1vC5iLU1/kLMtLeBjtyxy2i0y9pTvAzL85sxZBLsTFJ2Z
         r3Y6QBAHB+3dQnRamtswnYrbR6nd7vMd4oaLffp6M7/9lbnKIz7Huu1dUmG33/xMRtMd
         ZNTIh8U4uq+PLMTDD/nXcyWeoXKJqOq8css8o=
Subject: General kernel question about waiting for events
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Dec 2009 02:10:20 +0200
Message-ID: <1259712620.23837.22.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am writing a device driver now, and am am learning to do so at same
time I can say...

I found one interesting feature of the scheduler, and I want to confirm
that I understood it correctly.

Suppose application wants to wait for an event, and doesn't specify any
timeouts.

In that case, wrapped in different packages, it always ends with
following loop:

while( event == false )
schedule();

Now suppose event doesn't happen soon, and system has no other runnable
tasks.

In that case I suspect that system will be in endless loop switching
between idle task (swapper) and this one.

Since its unknown when the event will became true, I don't think that
idle task will be able to put cpu to low power state.

Since on any system there are plenty of tasks that are blocked on
sockets, and don't use any specified timeout, I don't understand how
idle task could run.

I suspect that idle task will run for some predefined time anyway.
It uses need_resched() as an end condition.
But then, am I right that any thread that specifies wait on any event,
will actually force system to wakeup every that 'predefined time'
Which I suspect is 1/HZ seconds?
How longer wait can be done then?

Could you explain that to me a bit?

Another thing I think is wrong is the description for
wait_event_interruptible_timeout

It says, 'sleep until a condition gets true or a timeout elapses',
however it actually tests condition once, sleeps whole timeout, and then
returns.

So a naive user could call that function with large timeout, and think
that as soon as he sets the event, the wait will end.

Am I wrong here?

Best regards,
Maxim Levitsky

