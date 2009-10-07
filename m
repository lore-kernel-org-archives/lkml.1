Return-Path: <linux-kernel-owner+w=401wt.eu-S1760005AbZJGUOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760005AbZJGUOx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 16:14:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754374AbZJGUOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 16:14:53 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:13642 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754082AbZJGUOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 16:14:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GEvpIIkRrQIVMysubHmhCDd8uyXf2Q1WjVU4gQQ89r/oFgwyI1uoh0YruHl4vrH+E8
         vH8P1ArO/jG4t0CYxVGFXyfRMQnay17JLP5LE/FiQBsHZjXQK2iR58OS/3+vyXYVFRl+
         z/WgkYH12IwzAErJVY/hOFVCeZz9mBqVBvkjc=
Date: Wed, 7 Oct 2009 22:13:41 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: John Kacur <jkacur@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, Clark Williams <williams@redhat.com>
Subject: Re: [PATCH RFC] BKL not necessary in cpuid_open
Message-ID: <20091007201338.GE5903@nowhere>
References: <alpine.LFD.2.00.0910072016190.15183@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0910072016190.15183@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 07, 2009 at 08:19:32PM +0200, John Kacur wrote:
> 
> I've been staring at the BKL lock in cpuid_open, and I can't see what it 
> is protecting. However, I may have missed something - even something 
> obvious, so comments are welcome.
> 
> From 25c0f07b3ec5533c0e690e06198baa4300ee4a8c Mon Sep 17 00:00:00 2001
> From: John Kacur <jkacur@redhat.com>
> Date: Wed, 7 Oct 2009 20:06:12 +0200
> Subject: [PATCH] The BKL is not necessary in cpuid_open
>  Most of the variables are local to the function. It IS possible that for
>  struct cpuinfo_x86 *c
>  c could point to the same area. However, this is used read only.
> 
> Signed-off-by: John Kacur <jkacur@redhat.com>


Hmm, I'm discovering that in tip:rt/kill-the-bkl

http://git.kernel.org/?p=linux/kernel/git/tip/linux-2.6-tip.git;a=commitdiff;h=55968ede164ae523692f00717f50cd926f1382a0

Looks like we have overlaped.

Thomas it would be nice to post these patches on LKML (or I missed
them?) and may be to merge them into tip:master, so that they are
visible and then we lower the risk of any duplicate works in this area.

Thanks.

