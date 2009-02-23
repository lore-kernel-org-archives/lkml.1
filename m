Return-Path: <linux-kernel-owner+w=401wt.eu-S1755964AbZBWWLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964AbZBWWLb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 17:11:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753444AbZBWWLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 17:11:22 -0500
Received: from yw-out-2324.google.com ([74.125.46.28]:15578 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413AbZBWWLW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 17:11:22 -0500
MIME-Version: 1.0
In-Reply-To: <200902221839.50357.rjw@sisk.pl>
References: <200902221837.49396.rjw@sisk.pl> <200902221839.50357.rjw@sisk.pl>
Date: Mon, 23 Feb 2009 14:11:19 -0800
Message-ID: <d6200be20902231411s654f8b3csf1388a97f3f94ac4@mail.gmail.com>
Subject: Re: [RFC][PATCH 2/2] PM: Rework handling of interrupts during 
	suspend-resume
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 22, 2009 at 9:39 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
>
> Introduce two helper functions allowing us to disable device
> interrupts (at the IO-APIC level) during suspend or hibernation
> and enable them during the subsequent resume, respectively, so that
> the timer interrupts are enabled while "late" suspend callbacks and
> "early" resume callbacks provided by device drivers are being
> executed.
>
> Use these functions to rework the handling of interrupts during
> suspend (hibernation) and resume.  Namely, interrupts will only be
> disabled on the CPU right before suspending sysdevs, while device
> interrupts will be disabled (at the IO-APIC level), with the help of
> the new helper function, before calling "late" suspend callbacks
> provided by device drivers and analogously during resume.
>

What impact does this have on wakeup interrupts? Unless you add a
check, after masking all interrupt at the CPU, to abort suspend if any
wakeup interrupt has IRQ_PENDING set I think you will loose wakeup
interrupts (at least for irqs that use default_disable).

-- 
Arve Hjønnevåg
