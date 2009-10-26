Return-Path: <linux-kernel-owner+w=401wt.eu-S1755299AbZJZIln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299AbZJZIln (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 04:41:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755126AbZJZIln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 04:41:43 -0400
Received: from smtprelay11.ispgateway.de ([80.67.31.34]:36016 "EHLO
	smtprelay11.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755116AbZJZIlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 04:41:42 -0400
Message-ID: <4AE560C9.6070600@ladisch.de>
Date: Mon, 26 Oct 2009 09:41:45 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: "Leonidas ." <leonidas137@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Process id recycling and status of tasks
References: <f22d86810910220629o433ee5d0u9857d1fb1f01cd6@mail.gmail.com>	 <4AE165A4.70706@ladisch.de> <f22d86810910241107l21159ccdx2203e2b537b7f36@mail.gmail.com>
In-Reply-To: <f22d86810910241107l21159ccdx2203e2b537b7f36@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Leonidas . wrote:
> On Fri, Oct 23, 2009 at 1:43 PM, Clemens Ladisch <clemens@ladisch.de> wrote:
> > Get a reference to the task's pid (...), then later check whether
> > pid_task() works.
> 
> Was going through pid.c, what is the fundamental difference between pid_task()
> and get_pid_task()?

As I said, the functions with "get" in their name increase the reference
count.  In other words, get_pid_task(p) is implemented as
get_task(pid_task(p)), so, if it succeeded, you would then own a
reference to the task.

> Now my understanding is get_pid_task() should be followed by put_pid_task()
> so the reference counting work as expected, but put_pid_task() is not an
> exported symbol?

You'd have a standard task_struct, so you'd just use put_task().  And if
you don't actually want a reference to the task (because you only want
to check whether the task still exists), just use pid_task() instead.


HTH
Clemens
