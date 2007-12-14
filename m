Return-Path: <linux-kernel-owner+w=401wt.eu-S1765563AbXLNK44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765563AbXLNK44 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 05:56:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761799AbXLNK4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 05:56:47 -0500
Received: from mail.suse.de ([195.135.220.2]:47332 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760004AbXLNK4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 05:56:46 -0500
To: miaox@cn.fujitsu.com
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] time: add an offline-cpu check in add_timer_on()
From: Andi Kleen <andi@firstfloor.org>
References: <47625B94.50105@cn.fujitsu.com>
Date: Fri, 14 Dec 2007 11:56:44 +0100
In-Reply-To: <47625B94.50105@cn.fujitsu.com> (Miao Xie's message of "Fri\, 14 Dec 2007 18\:31\:48 +0800")
Message-ID: <p73lk7xfssz.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miao Xie <miaox@cn.fujitsu.com> writes:

> Hi everyone,
>   I think we need a check in the function add_timer_on() to avoid adding a
> timer into the timer list of an offline cpu.
>
> This patch fixes this problem in add_timer_on().

No it doesn't -- it will just crash if a caller does that. If it's a real 
problem then you either need to fix the callers or change add_timer_on()
to transparently put it onto another CPU.

I don't think it's a real problem though because CPU offlining does
a stop machine and that should take care of most such races.

-Andi
