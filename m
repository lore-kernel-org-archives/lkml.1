Return-Path: <linux-kernel-owner+w=401wt.eu-S1751131AbXBSEjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751131AbXBSEjd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 23:39:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751306AbXBSEjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 23:39:33 -0500
Received: from 1wt.eu ([62.212.114.60]:2476 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131AbXBSEjc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 23:39:32 -0500
Date: Mon, 19 Feb 2007 05:39:27 +0100
From: Willy Tarreau <w@1wt.eu>
To: Phy Prabab <phyprabab@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Question about setting affinity in 2.4
Message-ID: <20070219043927.GE943@1wt.eu>
References: <2fe399760702181802q39e75b42iea7f80124506f169@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2fe399760702181802q39e75b42iea7f80124506f169@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Phy !

On Sun, Feb 18, 2007 at 06:02:17PM -0800, Phy Prabab wrote:
> Hello everyone,
> 
> I am trying to set affinity on a program to make sure I can get the
> best use of the cache as possible and to eliminate as much noise as
> possible with running my program.  I have tried unsuccessfully to set
> affinity using sched_set/getaffinity and the CPU_SET macros.  In
> particular, I can not seem to get the process to use affinity I
> specify as in:
> 
> int main () {
>  cpu_set_t mask;
>  cpu_set_t setmask;
>  long long x;
>  double foo;
>  printf("Mask set to %08lx\n", sched_getaffinity(0, &mask));
>  CPU_SET(1, &mask);
>  if (sched_setaffinity(0, &mask) == -1) {
>     printf("error setting affinity.");
>  }
> 
>  printf("Mask is reset to %08lx\n", sched_getaffinity(0, &mask));
>  // do some long lasting calculations ....
> 
>  return;
> }
> 
> No mater what I do, the process is never bond to the processor in
> question as exposed by this little appy and by cat /proc/<pid>/cpu.
> Is this just impossible to do?
> 
> Ah, the kernel I am using is RH 2.4.21-37.ELsmp.

I don't know for RH kernel, but the affinity syscalls are not in 2.4
mainline. You can apply the patch without much hassle if you want. It's
in Robert Love's directory :

 http://www.kernel.org/pub/linux/kernel/people/rml/cpu-affinity/v2.4/

I believe you'll have to use an -ac patch for RHEL.

> TIA!
> Phy

regards,
Willy

