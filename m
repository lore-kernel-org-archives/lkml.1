Return-Path: <linux-kernel-owner+w=401wt.eu-S1751750AbZJWINf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750AbZJWINf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 04:13:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751543AbZJWIN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 04:13:28 -0400
Received: from smtprelay08.ispgateway.de ([80.67.31.31]:46964 "EHLO
	smtprelay08.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbZJWINY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 04:13:24 -0400
Message-ID: <4AE165A4.70706@ladisch.de>
Date: Fri, 23 Oct 2009 10:13:24 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: "Leonidas ." <leonidas137@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Process id recycling and status of tasks
References: <f22d86810910220629o433ee5d0u9857d1fb1f01cd6@mail.gmail.com>
In-Reply-To: <f22d86810910220629o433ee5d0u9857d1fb1f01cd6@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Leonidas . wrote:
> 1. What would be an ideal way to check if a task is alive or dead from
> kernel space?

Get a reference to the task's pid (call get_task_pid(), or get_pid() on
the return value of task_pid()), then later check whether pid_task()
works.

(pid_alive() is not what you want because this would require that you
hold a reference to the task_struct.)

> even though a certain pid might exist, it might have got recycled by
> the time I check again, right?

The functions above do not work with PID numbers but with struct pid
which is a reference-counted object.  (The functions with "get" in their
name increase the reference count, so don't forget to put_pid() when you
no longer need it.)  See also the big comment in include/linux/pid.h.


HTH
Clemens
