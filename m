Return-Path: <linux-kernel-owner+w=401wt.eu-S1761682AbYBGT11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761682AbYBGT11 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 14:27:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759611AbYBGT1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 14:27:16 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34933 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752174AbYBGT1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 14:27:14 -0500
Date: Thu, 7 Feb 2008 11:26:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: torvalds@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] CPU isolation extensions
Message-Id: <20080207112652.07296f48.akpm@linux-foundation.org>
In-Reply-To: <47AB3E5A.4060107@qualcomm.com>
References: <47AA9807.7090402@qualcomm.com>
	<20080206215805.17a0c919.akpm@linux-foundation.org>
	<47AB3E5A.4060107@qualcomm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Feb 2008 09:22:34 -0800 Max Krasnyansky <maxk@qualcomm.com> wrote:

> > - There are two separate and identical implementations of
> >   cpu_unusable(cpu).  Please do it once, in a header, preferably with C
> >   function, not macros.
> 
> Those are local versions that depend whether a feature is enabled or not.
> If CONFIG_CPUISOL_WORKQUEUE is disabled we want to cpu_unusable()
> in the workqueue.c to be a noop, and if it's enabled that macro resolve to 
> cpu_isolated(). 
> Same thing for the stopmachine.c. If CONFIG_CPUISOL_STOPMACHIN is disabled
> cpu_unusable() is a noop. 
> In other words cpu_isolated() is the one common macro that subsystem may
> want to stub out. 
> Do you see another way of doing this ?

ah, I missed that.  Yup, the implementation you have there looks OK.
