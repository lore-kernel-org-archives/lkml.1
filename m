Return-Path: <linux-kernel-owner+w=401wt.eu-S1765573AbXGVVCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765573AbXGVVCb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 17:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764911AbXGVVCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 17:02:06 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:24942 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764282AbXGVVCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 17:02:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=I0/nD8HGta/2zx3YdxzzdFUTBjJJdfc1O+lH0GX+NodZy4YDyN7P8uR5oaq4H5bL8HHra22UNGWFrq4tBqLkoKNGtRvgM5mSpP7HtyYYAySfqVMY+CEnte9tzjheUELppjB16CRGgYgJRwhoLI8IK9sY6YY5BJOwo32LETL4u2Q=
Message-ID: <92a12cdb0707221402g4bce07b3u775d291fc2652f79@mail.gmail.com>
Date: Sun, 22 Jul 2007 22:02:02 +0100
From: "Adrian McMenamin" <adrianmcmenamin@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Problems with framebuffer in 2.6.22-git17
Cc: lethal@users.sourceforge.net
In-Reply-To: <92a12cdb0707221141i4398d6fdxa7994c5f1f809b0a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <92a12cdb0707221141i4398d6fdxa7994c5f1f809b0a@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/07/07, Adrian McMenamin <adrianmcmenamin@gmail.com> wrote:
> I ma having problems with the pvr2 fb on the Dreamcast in 2.6.22-git17
> - when the code is executed it appears to lock the Dreamcast up.
>
> The problem seems to be:
>
>  fb_notifier_call_chain(FB_EVENT_FB_REGISTERED, &event);
>
> In drivers/video/fbmem.c
>
> This hasn't been an issue before, so are there any recent changes that
> might have caused this?
>
> (fb_notifier_call_chain calls a succession of stubs ending in
> __blocking_notifier_call_chain in kernel/sys.c)


Looking further, the problem can be further narrowed to

ret = nb->notifier_call(nb, val, v);


in

static int __kprobes notifier_call_chain(struct notifier_block **nl,
					unsigned long val, void *v,
					int nr_to_call,	int *nr_calls)

In kernel/sys.c
