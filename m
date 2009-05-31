Return-Path: <linux-kernel-owner+w=401wt.eu-S1753505AbZEaWUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505AbZEaWUX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 18:20:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbZEaWUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 18:20:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44656 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752248AbZEaWUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 18:20:11 -0400
Date: Sun, 31 May 2009 15:19:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Matt Helsley <matthltc@us.ibm.com>, xemul@parallels.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       dave@linux.vnet.ibm.com, mingo@elte.hu, torvalds@linux-foundation.org
Subject: Re: [PATCH 14/38] Remove struct mm_struct::exe_file et al
Message-Id: <20090531151953.8f8b14b5.akpm@linux-foundation.org>
In-Reply-To: <20090531215427.GA29534@x200.localdomain>
References: <20090526113618.GJ28083@us.ibm.com>
	<20090526162415.fb9cefef.akpm@linux-foundation.org>
	<20090531215427.GA29534@x200.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Jun 2009 01:54:27 +0400 Alexey Dobriyan <adobriyan@gmail.com> wrote:

> And BTW, there is something unnatural when executable path is attached
> to mm_struct(!) not task_struct,

mm_struct is the central object for a heavyweight process.  All threads
within that process share the same executable path (don't they?) so
attaching the executable path to the mm seems OK to me.

What I always find a bit weird is that an MM container is used as the
central point for a number of sched obects.  But it's logical, given
that the never-before-stated definition of a heavyweight process is
"thing which share a VM".
