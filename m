Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757366Ab0BKXid (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 18:38:33 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39686 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755775Ab0BKXib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 18:38:31 -0500
Date: Thu, 11 Feb 2010 15:37:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 4/7 -mm] oom: badness heuristic rewrite
Message-Id: <20100211153724.d4a3e2aa.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1002111524470.4438@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1002100224210.8001@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1002100228540.8001@chino.kir.corp.google.com>
	<4B73833D.5070008@redhat.com>
	<alpine.DEB.2.00.1002102332200.22152@chino.kir.corp.google.com>
	<20100211134343.4886499c.akpm@linux-foundation.org>
	<alpine.DEB.2.00.1002111346050.8809@chino.kir.corp.google.com>
	<20100211143105.dea3861a.akpm@linux-foundation.org>
	<alpine.DEB.2.00.1002111437060.21107@chino.kir.corp.google.com>
	<20100211151135.91586cd1.akpm@linux-foundation.org>
	<alpine.DEB.2.00.1002111524470.4438@chino.kir.corp.google.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Feb 2010 15:31:14 -0800 (PST)
David Rientjes <rientjes@google.com> wrote:

> > There _are_ things we can do though.  Detect a write to the old file and
> > emit a WARN_ON_ONCE("you suck").  Wait a year, turn it into
> > WARN_ON("you really suck").  Wait a year, then remove it.
> > 
> 
> Ok, I'll use WARN_ON_ONCE() to let the user know of the deprecation and 
> then add an entry to Documentation/feature-removal-schedule.txt.

A printk_once() would be better - WARN() generates a big stack
spew which often is wholly irrelevant.

