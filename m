Return-Path: <linux-kernel-owner+w=401wt.eu-S1755387AbXLXBNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387AbXLXBNv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 20:13:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751403AbXLXBNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 20:13:42 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50062 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbXLXBNl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 20:13:41 -0500
Date: Sun, 23 Dec 2007 20:11:49 -0500
From: Rik van Riel <riel@redhat.com>
To: balbir@linux.vnet.ibm.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, lee.schermerhorn@hp.com
Subject: Re: [patch 00/20] VM pageout scalability improvements
Message-ID: <20071223201149.7b88888f@bree.surriel.com>
In-Reply-To: <476EE858.202@linux.vnet.ibm.com>
References: <20071218211539.250334036@redhat.com>
	<476D7334.4010301@linux.vnet.ibm.com>
	<20071222192119.030f32d5@bree.surriel.com>
	<476EE858.202@linux.vnet.ibm.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Dec 2007 04:29:36 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> Rik van Riel wrote:

> > In the real world, users with large JVMs on their servers, which
> > sometimes go a little into swap, can trigger this system.  All of
> > the CPUs end up scanning the active list, and all pages have the
> > referenced bit set.  Even if the system eventually recovers, it
> > might as well have been dead.
> > 
> > Going into swap a little should only take a little bit of time.
> 
> Very fascinating, so we need to scale better with larger memory.
> I suspect part of the answer will lie with using large/huge pages.

Linus vetoed going to a larger soft page size, with good reason.

Just look at how much the 64kB page size on PPC64 sucks for most
workloads - it works for PPC64 because people buy PPC64 monster
systems for the kinds of monster workloads that work well with a
large page size, but it definately isn't general purpose.
