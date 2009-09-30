Return-Path: <linux-kernel-owner+w=401wt.eu-S1754910AbZI3RqM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910AbZI3RqM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 13:46:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754836AbZI3RqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 13:46:11 -0400
Received: from adelie.canonical.com ([91.189.90.139]:53672 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754651AbZI3RqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 13:46:11 -0400
Date: Wed, 30 Sep 2009 18:46:12 +0100
From: Andy Whitcroft <apw@canonical.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] checkpatch: fix false errors due to macro
 concatenation
Message-ID: <20090930174612.GE2957@shadowen.org>
References: <1253585691-10987-1-git-send-email-dwalker@fifo99.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253585691-10987-1-git-send-email-dwalker@fifo99.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 21, 2009 at 07:14:47PM -0700, Daniel Walker wrote:
> The macro concatenation (##) sequence can cause false errors when checking
> macro's. Checkpatch doesn't currently know about the operator.
> 
> For example this line,
> 
> + 	entry = (struct ftrace_raw_##call *)raw_data;                   \
> 
> is correct but it produces the following error,
> 
> ERROR: need consistent spacing around '*' (ctx:WxB)
> +       entry = (struct ftrace_raw_##call *)raw_data;\
>                                           ^
> 
> The line above doesn't have any spacing problems, and if you remove the
> macro concatenation sequence checkpatch doesn't give any errors. This change
> resolves this by just always removing "##" in every line checked.

Ok, just removing these characters in the conversion changes the
relative length of the converted form and breaks position reporting for
other checks, for instance if I stupidly convert the ## to # so its
still invalid we then get this:

+	entry = (struct ftrace_raw_##call *)raw_data; \

It is probabally more correct to include this <ident> ## <ident> form in
the definition of an identifier.  I've respun this patch to do just that
and it looks like its working as we would hope.

I will get this tested properly and add it to my next batch.

Perhaps you could test the version at the url below and see if it works
better:

  http://www.kernel.org/pub/linux/kernel/people/apw/checkpatch/checkpatch.pl-testing

NOTE: you want at least version 0.29-5-* which is in the process of
mirroring out.

-apw
