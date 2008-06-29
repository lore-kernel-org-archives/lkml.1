Return-Path: <linux-kernel-owner+w=401wt.eu-S1755508AbYF2HXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508AbYF2HXu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 03:23:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751667AbYF2HXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 03:23:41 -0400
Received: from eth7959.sa.adsl.internode.on.net ([150.101.82.22]:46585 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751395AbYF2HXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 03:23:40 -0400
Message-ID: <48673873.6040202@davidnewall.com>
Date: Sun, 29 Jun 2008 16:53:31 +0930
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Ctrl+C doesn't interrupt process waiting for I/O
References: <48661488.10304@gmail.com> <4866F6FE.9000503@goop.org>
In-Reply-To: <4866F6FE.9000503@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Török Edwin wrote:
>> ...
>> - I have a (I/O bound) process running in my terminal, and I want to
>> interrupt it with Ctrl+C
>>  - I type Ctrl+C several times, and the process is not interrupted for
>> several seconds (10-30 secs)
>>  - if I type Ctrl+Z, and use kill %1 the process dies faster than
>> waiting for it to react to Ctrl+C  
>
> Yes, it's intended behaviour.  Filesystem IO syscalls are considered
> "fast" and are interruptible.  Usermode code can reasonably expect
> that file IO will never return EINTR.

This does not address the symptom that the process can be killed quicker
by sending a SIGTERM.  I've noticed the problem, too (2.6.25.)  I wonder
if it isn't some strangeness in the tty layer (hence the interrupt key
is slower than an explicitly sent signal.)
