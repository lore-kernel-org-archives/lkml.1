Return-Path: <linux-kernel-owner+w=401wt.eu-S1754742AbZKWOpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742AbZKWOpo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 09:45:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753150AbZKWOpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 09:45:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11442 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753123AbZKWOpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 09:45:43 -0500
Date: Mon, 23 Nov 2009 15:40:33 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: Michael Tokarev <mjt@tls.msk.ru>, roland@redhat.com,
       Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Why processes on linux loses signals?
Message-ID: <20091123144033.GB4495@redhat.com>
References: <4B09A9CE.4080300@msgid.tls.msk.ru> <2c0942db0911221739m2e5a1bb3vea69bccbfb3306cf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2c0942db0911221739m2e5a1bb3vea69bccbfb3306cf@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22, Ray Lee wrote:
>
> [ adding potential interested parties to the CC:. Michael, please respond
> with the latest kernel version you've tried that exhibits the problem, as well
> as whether or not you've been able to create a test-case that shows the
> signal loss. ]

Yes, it would be nice to have a test-case.

> On Sun, Nov 22, 2009 at 1:14 PM, Michael Tokarev <mjt@tls.msk.ru> wrote:
>
> > It's a very old issue, but I still don't know an answer.
> >
> > In short, processes on linux loses signals.  It happens
> > rarely, but it happens, and the frequency of this happening
> > is enough to be annoying.
> >
> > For example, I've a program that used alarm(2) to periodically
> > check for something.  Nothing fancy, nothing interesting is done
> > in the signal handler, no long operations or something, plain
> > signal(2) with sighandler just setting a global variable.  When
> > under heavy usage (it's a DNS nameserver), in about a week
> > (sometimes a few hours, sometimes after a month) it stops checking
> > for updates, because apparently some sigalrm got lost.

This shouldn't happen (assuming your application is correct ;)

If this happens again, could you look in /proc/pid/status? I don't
really think this will help, but still.

> > Last time I asked similar question here, I was told that signals
> > are unreliable

They should be reliable. If not we have a kernel bug.

Oleg.

