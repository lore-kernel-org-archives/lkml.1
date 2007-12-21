Return-Path: <linux-kernel-owner+w=401wt.eu-S1764874AbXLUAFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764874AbXLUAFc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 19:05:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754698AbXLUAFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 19:05:11 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54827 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764586AbXLUAFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 19:05:09 -0500
Date: Thu, 20 Dec 2007 16:02:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: trond.myklebust@fys.uio.no, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.24-rc5 x86 architecture no longer Oopses...
Message-Id: <20071220160203.f940f088.akpm@linux-foundation.org>
In-Reply-To: <20071220234759.GA29776@elte.hu>
References: <1198190447.29917.9.camel@heimdal.trondhjem.org>
	<20071220145415.f737e7f3.akpm@linux-foundation.org>
	<20071220234759.GA29776@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Dec 2007 00:47:59 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> it needs to be found out why the preempt_count suddenly went to zero. Is 
> task struct corruption out of question?

Strictly we shouldn't care - we _know_ we've already hit a kernel bug and
who knows, perhaps that buggy code did an unbalanced preempt_disable().  So
make the oops code more robust.  

otoh, we don't want to be hiding a bug.  What piece of code guarantees that
we ender the oops code with preemption disabled?

