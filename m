Return-Path: <linux-kernel-owner+w=401wt.eu-S1756462AbYIKTMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756462AbYIKTMt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 15:12:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751442AbYIKTMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 15:12:41 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59918 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752722AbYIKTMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 15:12:40 -0400
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
To: Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [PATCH 01/18] lirc core device driver infrastructure
Date: Thu, 11 Sep 2008 15:09:51 -0400
User-Agent: KMail/1.10.1 (Linux/2.6.25.16-1.fc10.x86_64; KDE/4.1.1; x86_64; ; )
Cc: j@jannau.net, linux-kernel@vger.kernel.org, lkml@ml.breakpoint.cc,
       superm1@ubuntu.com
References: <AlfDffi3jFB@christoph>
In-Reply-To: <AlfDffi3jFB@christoph>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809111509.51901.jwilson@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 September 2008 14:30:00 Christoph Bartelmus wrote:
> Hi,
>
> on 09 Sep 08 at 13:03, Jarod Wilson wrote:
> > On Tuesday 09 September 2008 03:40:18 Sebastian Siewior wrote:
>
> [...]
>
> >>>+EXTRA_CFLAGS =-DIRCTL_DEV_MAJOR=61 -DLIRC_SERIAL_TRANSMITTER -I$(src)
> >>
> >> Do you rely on this specific major? Since your daemon opens /dev/lirc0
> >> you don't need a fixed major do you?
> >
> > Good question. Quite honestly, I'm not sure. Christoph?
>
> LIRC does not rely on a specific major. But to be honest, the last time I
> looked into this issue, was when devfs was bleeding-edge...
>
> So, we need some advice here how to proceed. Should we try to register an
> official major number for LIRC? Should we try to have a minor number
> mapping, e.g.
> /dev/lirc/serial/0 LIRC device on 1st UART serial port
> ...
> /dev/lirc/serial/n LIRC device on n-th UART serial port
> /dev/lirc/parallel/0 LIRC device on 1st parallel port
> ...
> /dev/lirc/parallel/n LIRC device on n-th parallel port
> /dev/lirc/usb/0 1st LIRC USB device
> ...

Janne took a crack at dynamic device allocation earlier today, committed into 
my git tree:

http://git.wilsonet.com/linux-2.6-
lirc.git/?a=commitdiff;h=ea74897bf7b03e2ed2401df3815637caa0702eab

Haven't yet tested it out, that's on tap for tonight...

-- 
Jarod Wilson
jarod@redhat.com

