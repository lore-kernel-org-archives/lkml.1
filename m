Return-Path: <linux-kernel-owner+w=401wt.eu-S1751480AbZJWINU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480AbZJWINU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 04:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751305AbZJWINT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 04:13:19 -0400
Received: from smtprelay08.ispgateway.de ([80.67.31.31]:34038 "EHLO
	smtprelay08.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbZJWINS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 04:13:18 -0400
Message-ID: <4AE165A1.5080204@ladisch.de>
Date: Fri, 23 Oct 2009 10:13:21 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: "Leonidas ." <leonidas137@gmail.com>
CC: Valdis.Kletnieks@vt.edu, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Can current macro be accessed from interrupt context?
References: <f22d86810910220410r33002b5ei403ddf6632254472@mail.gmail.com>	 <5048.1256224623@turing-police.cc.vt.edu> <f22d86810910221046l366d3017r8b8823e4750ffea2@mail.gmail.com>
In-Reply-To: <f22d86810910221046l366d3017r8b8823e4750ffea2@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Leonidas . wrote:
> I am trying to emulate thread local storage in kernel space.  [...]
> Assume that, a multithreaded app talks to my kernel module using
> /dev/node, and I need to book keep certain data in kernel module. The
> data I am book keeping can be kept in a central data structure
> protected by spinlocks. A better way would be per cpu data structure.
> 
> My idea is to keep data specific to each task which is talking to my
> kernel module. Assumption here is a certain task can be in kernel mode
> only on one cpu at a time hence that task specific data structure can
> be accessed without locks.

There is no fixed association between your tasks and the CPUs they are
running on.  It is possible for two of your threads to be executed on
the same CPU (one after the other), or for one thread to migrate between
CPUs.

> All book keeping which needs to be done in ISRs would be just book
> keeping for the interrupted task, i.e. we would populate interrupted
> task's data structure. This is where current comes in picture.

The task that was interrupted is probably some entirely different task
(the X server, the shell, your mail reader, some kernel thread, or
any of the other tasks running on your system).

It is possible for your interrupt handler to be called for some device
request that belongs to one of your tasks that is currently running on
another CPU, so you won't be able to manage that data without locking.


Best regards,
Clemens
