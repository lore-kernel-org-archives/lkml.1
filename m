Return-Path: <linux-kernel-owner+w=401wt.eu-S932619AbYARWz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932619AbYARWz5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 17:55:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762575AbYARWzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 17:55:48 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50947 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761186AbYARWzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 17:55:47 -0500
Date: Fri, 18 Jan 2008 17:54:50 -0500
From: Rik van Riel <riel@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Oeser <ioe-lkml@rameria.de>, Miklos Szeredi <miklos@szeredi.hu>,
       peterz@infradead.org, salikhmetov@gmail.com, linux-mm@kvack.org,
       jakob@unthought.net, linux-kernel@vger.kernel.org,
       valdis.kletnieks@vt.edu, ksm@42.dk, staubach@redhat.com,
       jesper.juhl@gmail.com, akpm@linux-foundation.org, protasnb@gmail.com,
       r.e.wolff@bitwizard.nl, hidave.darkstar@gmail.com, hch@infradead.org
Subject: Re: [PATCH -v6 2/2] Updating ctime and mtime for memory-mapped
 files
Message-ID: <20080118175450.715ded60@bree.surriel.com>
In-Reply-To: <alpine.LFD.1.00.0801181439330.2957@woody.linux-foundation.org>
References: <12006091182260-git-send-email-salikhmetov@gmail.com>
	<E1JFwnQ-0001FB-2c@pomaz-ex.szeredi.hu>
	<alpine.LFD.1.00.0801181127000.2957@woody.linux-foundation.org>
	<200801182332.02945.ioe-lkml@rameria.de>
	<alpine.LFD.1.00.0801181439330.2957@woody.linux-foundation.org>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jan 2008 14:47:33 -0800 (PST)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

>  - keep it simple. Let's face it, Linux has never ever given those 
>    guarantees before, and it's not is if anybody has really cared. Even 
>    now, the issue seems to be more about paper standards conformance than 
>    anything else.

There is one issue which is way more than just standards conformance.

When a program changes file data through mmap(), at some point the
mtime needs to be update so that backup programs know to back up the
new version of the file.

Backup programs not seeing an updated mtime is a really big deal.

-- 
All rights reversed.
