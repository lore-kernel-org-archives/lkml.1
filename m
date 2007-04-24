Return-Path: <linux-kernel-owner+w=401wt.eu-S1161757AbXDXNQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161757AbXDXNQk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 09:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161758AbXDXNQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 09:16:40 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:57145 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161757AbXDXNQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 09:16:39 -0400
Date: Tue, 24 Apr 2007 15:08:57 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Christoph Hellwig <hch@infradead.org>
cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, containers@lists.osdl.org,
       Oleg Nesterov <oleg@tv-sign.ru>, linux-kernel@vger.kernel.org,
       Marcel Holtmann <marcel@holtmann.org>, rusty@rustcorp.com.au
Subject: Re: [PATCH] kthread: Spontaneous exit support
In-Reply-To: <20070423112537.GA21941@infradead.org>
Message-ID: <Pine.LNX.4.61.0704241507460.2490@yvahk01.tjqt.qr>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
 <1176969596686-git-send-email-ebiederm@xmission.com>
 <20070419162459.af7a182c.akpm@linux-foundation.org> <20070422194455.GA18561@infradead.org>
 <m1fy6rzsug.fsf_-_@ebiederm.dsl.xmission.com> <20070423112537.GA21941@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 23 2007 12:25, Christoph Hellwig wrote:
>On Sun, Apr 22, 2007 at 09:12:55PM -0600, Eric W. Biederman wrote:
>> 
>> This patch implements the kthread helper functions kthread_start
>> and kthread_end which make it simple to support a kernel thread
>> that may decided to exit on it's own before we request it to.
>> It is still assumed that eventually we will get around to requesting
>> that the kernel thread stop.
>
>I don't think having to parallel APIs is a good idea, people will
>get utterly confused which one to use.  Better always grab a reference
>in kthread_create and drop it in kthread_stop.  For normal thread
>no change in behaviour and only slightly more code in the slowpath.

I *am* already confused... a driver of mine does:

static __init int thkd_init(void)
{
	touch_task = kthread_run(touch_thread, Device, "thkd");
	...
}

and

static __exit void thkd_exit(void)
{
	kthread_stop(touch_task);
	/* I bet something is missing */
}

now what good would kthread_run do me?



Jan
-- 
