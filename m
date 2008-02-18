Return-Path: <linux-kernel-owner+w=401wt.eu-S1760396AbYBRNBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760396AbYBRNBs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 08:01:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757107AbYBRNAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 08:00:54 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60558 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760500AbYBRNAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 08:00:51 -0500
Date: Mon, 18 Feb 2008 04:59:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Dan Upton" <upton.dan.linux@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: accessing core temp sensors in the kernel
Message-Id: <20080218045949.d75c4ab3.akpm@linux-foundation.org>
In-Reply-To: <ba7d8f720802151312o643bae66p485287bc444103e9@mail.gmail.com>
References: <ba7d8f720802151312o643bae66p485287bc444103e9@mail.gmail.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Feb 2008 16:12:40 -0500 "Dan Upton" <upton.dan.linux@gmail.com> wrote:

> I'm trying to do some work on thermally-aware scheduling, specifically
> using the coretemp module to access core temperature sensors on the
> Intel Core2 platform.  I know how to access them from user mode,
> reading files from sysfs, but clearly that's not the way to do it in
> the kernel.  Specifically, I'm not sure how, in the scheduler, to get
> copies of the appropriate device structures to call
> 
> static struct coretemp_data *coretemp_update_device(struct device *dev)
> 
> (in hwmon/coretemp.c).
> 
> Can anybody give me pointers where to get started?

You shouldn't make the core scheduler dependent upon some hwmon module. 
I'd sugggest adding some register_cpu_temperature_monitor() function in the
scheduler then permit suitable monitoring modules to register themselves in
their module_init() functions.  Use a notifier chain from notifier.h.  The
CPU scheduler will walk that chain calling into the registered drivers at a
suitable time.


