Return-Path: <linux-kernel-owner+w=401wt.eu-S1754563AbYA1FdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563AbYA1FdQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 00:33:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751103AbYA1FdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 00:33:00 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60929 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750727AbYA1Fc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 00:32:59 -0500
Date: Sun, 27 Jan 2008 21:32:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Abhishek Sagar <sagar.abhishek@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, jkenisto@us.ibm.com,
       ananth@in.ibm.com, Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH -mm] kprobes: kretprobe user entry-handler (updated)
Message-Id: <20080127213257.0889c523.akpm@linux-foundation.org>
In-Reply-To: <479B7A78.5090604@gmail.com>
References: <479B7A78.5090604@gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Jan 2008 23:52:48 +0530 Abhishek Sagar <sagar.abhishek@gmail.com> wrote:

> This is a repost of a patch which was reviewed earlier at:
> http://lkml.org/lkml/2007/11/13/58 (thanks to Jim Keniston and Srinivasa for their review comments). This provides support to add an optional user defined callback to be run at function entry of a kretprobe'd function. It also modifies the kprobe smoke tests to include an entry-handler during the kretprobe sanity test.
> 

Neither the changelog nor the newly-added documentation explain why Linux
needs this feature.  What will it be used for??


> +1.3.2 Kretprobe entry-handler
> +
> +Kretprobes also provides an optional user-specified handler which runs

I think "caller-specified" would be a better term here.  Generally "user"
refers to Aunt Tillie sitting at the keyboard.

> +/* Timestamp function entry. */
> +static int entry_handler(struct kretprobe_instance *ri, struct pt_regs *regs)
> +{
> +	struct my_data *data;
> +
> +	if(!current->mm)
> +		return 1; /* skip kernel threads */

gargh, what's happened to checkpatch lately?  It failed to notice the
missing space.

