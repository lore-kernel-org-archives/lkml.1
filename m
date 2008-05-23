Return-Path: <linux-kernel-owner+w=401wt.eu-S1756965AbYEWTvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756965AbYEWTvx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 15:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756063AbYEWTvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 15:51:44 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:38040 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041AbYEWTvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 15:51:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Vrtb5S48YOGtMKpwbWVrUw/nu7IVuz3DPLqx5Dq9Dd7tInhReQhyHFaO+t5j/LSDG4ncyZ9WeOadRreFY8lSFmKVq9KLERkQMiYjBbMAvi0U0+06AXbWfhpwlVOBrB3ADXLUrPZ6FjEa7Xcfs0nN93SfUiyzotDhEddz5C9n6G4=
Date: Sat, 24 May 2008 00:47:39 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] use of /sys versus /proc
Message-ID: <20080523204739.GA15760@martell.zuzino.mipt.ru>
References: <20080523131255.C19831F0380@attica.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080523131255.C19831F0380@attica.americas.sgi.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2008 at 08:12:55AM -0500, Cliff Wickman wrote:
> I have a need to display TLB shootdown statistics.  (I'm working
> on a patch to implement this on a new machine at SGI.)
> 
> I had planned to display these statistics through /proc
> as in arch/ia64/sn/kernel/sn2/sn2_smp.c (/proc/sgi_sn/ptc_statistics).
> 
> However, considering the general move to reserve /proc for
> process-related things, I thought the community might prefer the
> interface to be in /sys.
> 
> But sysfs has an output buffer restriction of one page, which
> is too restrictive for statistics from very large cpu counts.
> We intend to display about 10 numbers per cpu.
> 
> Besides, the spirit of /sys according to the sysfs.txt documentation:
>     "Attributes should be ... preferably with only one value
>      per file. ... acceptable to express an array of values of the same type."
>   [it also  warns:
>     "... expressing multiple lines of data, ... is heavily frowned upon.
>      Doing these things may get you publically humiliated and your code
>      rewritten without notice."]
> 
> If I break up the statistics files per-cpu, or maybe ranges of
> cpu's, it would create a potentially large number of files in /sys.
> 
> Or, I could stick with a single file in /proc.
> 
> What would you recommend?

TLB shootdowns are in /proc/interrupts at least on x86_64.

