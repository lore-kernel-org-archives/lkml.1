Return-Path: <linux-kernel-owner+w=401wt.eu-S1755288AbXITKrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288AbXITKrg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 06:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750758AbXITKr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 06:47:29 -0400
Received: from hu-out-0506.google.com ([72.14.214.227]:10951 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbXITKr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 06:47:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=SNeKI+7/bvVJpSr53tqxr73lxOa2NPMPYdCCLgd6hQwJmz5k/ffaUAkWvCOp7L+oWMeuI+NTVCU+fwu9OG6X3M+DKLfWetiqbZkIFWmj7kHh5IlQaU5UOUKOR6RTKZBx3IepeJo1mfVFj+DWsF5C4zJGri49K7k6bc/YlvuUxSk=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [patch 7/8] Immediate Values - Documentation
Date: Thu, 20 Sep 2007 11:46:57 +0100
User-Agent: KMail/1.9.1
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <20070827155910.336723755@polymtl.ca> <20070827160214.252315593@polymtl.ca>
In-Reply-To: <20070827160214.252315593@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709201146.57334.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 August 2007 16:59, Mathieu Desnoyers wrote:
> +We can therefore affirm that adding 2 markers to getppid, on a system with high
> +memory pressure, would have a performance hit of at least 6.0% on the system
> +call time, all within the uncertainty limits of these tests. The same applies to
> +other kernel code paths. The smaller those code paths are, the highest the
> +impact ratio will be.

Immediates make code bigger, right?
What will happen on a system with high *icache* pressure?
There a lot of inline happy and/or C++ folks out there
in the userland, they routinely have programs in tens of megabytes range.

getppid is one of the lightest syscalls out there.
What kind of speedup do you see on a real-world test
(two processes exchaging data through pipes, for example)?

> +Therefore, not only is it interesting to use the immediate values to dynamically
> +activate dormant code such as the markers, but I think it should also be
> +considered as a replacement for many of the "read mostly" static variables.

What effect that will have on "size vmlinux" on AMD64?
--
vda
