Return-Path: <linux-kernel-owner+w=401wt.eu-S1751648AbXDMCoB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751648AbXDMCoB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 22:44:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751652AbXDMCoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 22:44:01 -0400
Received: from smtp.osdl.org ([65.172.181.24]:44034 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648AbXDMCoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 22:44:00 -0400
Date: Thu, 12 Apr 2007 19:43:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: <mchu@mirapoint.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: Cheap lock for user mode processes release when process exits
Message-Id: <20070412194352.a29de6f5.akpm@linux-foundation.org>
In-Reply-To: <20070413015428.AMJ80009@dougfood.mirapoint.com>
References: <20070413015428.AMJ80009@dougfood.mirapoint.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Apr 2007 01:54:28 +0000 (GMT) <mchu@mirapoint.com> wrote:

> Hi all,
> 
> Maybe someone here knows better.
> 
> I have several user-mode processes using shared mmap.  There can be several reader processes and only one writer.  Readers access the shared region frequently, writer seldom.
> 
> Naturally, multi-reader/single-writer locks works best.  I tried this with futex on 2.6.9-42.EL.  However, if one of the processes is killed/exits, the lock doesn't get released.
> 
> I can trap the signal to release the lock, but not all signals like kill.
> 
> Anyway I can achieve this without a potential deadlock?
> 

Robust futexes: http://lwn.net/Articles/172149/

But I don't know whether RH backported them into RHEL4.
