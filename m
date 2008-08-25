Return-Path: <linux-kernel-owner+w=401wt.eu-S1756363AbYHYLlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363AbYHYLlf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 07:41:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756122AbYHYLlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 07:41:23 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47992 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530AbYHYLlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 07:41:22 -0400
Subject: Re: Quad core CPUs loaded at only 50% when running a CPU and mmap
	intensive multi-threaded task
From: Peter Zijlstra <peterz@infradead.org>
To: edwin <edwintorok@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, rml@tech9.net,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner mingo@redhat.com" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <48B290E7.4070805@gmail.com>
References: <48B1CC15.2040006@gmail.com> <1219643476.20732.1.camel@twins>
	 <48B25988.8040302@gmail.com> <1219656190.8515.7.camel@twins>
	 <48B28015.3040602@gmail.com> <1219658527.8515.16.camel@twins>
	 <48B287D8.1000000@gmail.com> <1219660582.8515.24.camel@twins>
	 <48B290E7.4070805@gmail.com>
Content-Type: text/plain
Date: Mon, 25 Aug 2008 13:41:17 +0200
Message-Id: <1219664477.8515.54.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-25 at 14:00 +0300, edwin wrote:
> Peter Zijlstra wrote:

> > Right - does it make sense to teach clamav about pread() ?
> 
> If it is preferred over mmap, then maybe yes.

I would certainly consider this for small (< 1M?) files. With mmap the
faults and pte overhead aren't free either, and the extra memcpy from
pread() isn't that much.

