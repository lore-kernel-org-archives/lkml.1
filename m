Return-Path: <linux-kernel-owner+w=401wt.eu-S1762075AbYFDWkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762075AbYFDWkd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 18:40:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752686AbYFDWkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 18:40:23 -0400
Received: from mail.thorsten-knabe.de ([212.60.139.226]:60884 "EHLO
	mail.thorsten-knabe.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbYFDWkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 18:40:22 -0400
Message-ID: <484719C7.2020502@thorsten-knabe.de>
Date: Thu, 05 Jun 2008 00:40:07 +0200
From: Thorsten Knabe <linux@thorsten-knabe.de>
User-Agent: Icedove 1.5.0.14eol (X11/20080509)
MIME-Version: 1.0
To: Jeff Dike <jdike@addtoit.com>
CC: Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org
Subject: Re: [BUG] Linux 2.6.25.4 task_struct leak
References: <483EC624.90503@thorsten-knabe.de> <20080601213134.GJ4018@sequoia.sous-sol.org> <20080602010546.GA8578@c2.user-mode-linux.org>
In-Reply-To: <20080602010546.GA8578@c2.user-mode-linux.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Spam-Report: SpamAssassin@thorsten-knabe.de:
	Content analysis details:   (-2.6 points, 5.0 required)
	pts rule name              description
	---- ---------------------- --------------------------------------------------
	-0.0 NO_RELAYS              Informational: message was not relayed via SMTP
	-2.6 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Dike wrote:
> On Sun, Jun 01, 2008 at 02:31:39PM -0700, Chris Wright wrote:
>> * Thorsten Knabe (linux@thorsten-knabe.de) wrote:
>>> [5.] Most recent kernel version which did not have the bug:
>>> 2.6.23.17 does not leak task_structs.
>>> 2.6.24 - 2.6.25.3 has not been tested
> 
> Has this been seen on non-UML?

Hello Jeff.

I'm not sure, if I understood your question correctly. The task_struct
leak is on the host running a vanilla Linux 2.6.25.4 x86_64 on real
hardware and not within the UML instances. I'll try to describe the
situation more precisely:

The host system is a vanilla Linux 2.6.25.4 x86_64 running on real
hardware with a Debian Etch x86_64 user space. However I've created a
Debian Etch i386 (32bit) userspace chroot environment on the system,
which is used, among other things, to compile the Linux 2.6.23.17 UML
kernels and start various UML instances.

I can start other 32-bit applications, for example compile an UML
kernel, within the chroot without leaking task_structs, but as soon as I
start an UML instance, I see leaked task_structs. Starting and
immediately shutting down an UML instacne leaks approximately 2000
task_structs. The number of leaked task_structs on the host seems to be
equal to the number of processes that have been created (and destroyed)
within the UML instances.

The host system was upgraded from 2.6.23.17 x86_64 which did not leak
task_structs to 2.6.25.4 x86_64. Also running the same UML kernels and
filesystems on my laptop with a vanilla Linux 2.6.25.4 i386 kernel does
not leak task_structs. The version of the UML kernel (tested 2.6.23.17
and 2.6.25.4) does not seem to matter.

As far as I understand the UML code in the kernel, an UML kernel uses
some unusual clone() flags when creating new processes, which are seldom
used by other applications and could be related to the bug.

If there is no obvious bug in the code, I'll try to bisect that beast
next weekend as suggested by Chris.

Regards
Thorsten

-- 
___
 |        | /                 E-Mail: linux@thorsten-knabe.de
 |horsten |/\nabe                WWW: http://linux.thorsten-knabe.de
