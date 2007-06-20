Return-Path: <linux-kernel-owner+w=401wt.eu-S1758062AbXFTPx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062AbXFTPx4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 11:53:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755017AbXFTPxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 11:53:47 -0400
Received: from ns.suse.de ([195.135.220.2]:53176 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754785AbXFTPxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 11:53:47 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Alexey Dobriyan <adobriyan@sw.ru>
Subject: Re: [PATCH -mm 1/2] i386: semi-rewrite of PTRACE_PEEKUSR, PTRACE_POKEUSR
Date: Wed, 20 Jun 2007 17:53:33 +0200
User-Agent: KMail/1.9.6
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, roland@redhat.com,
       hch@infradead.org, devel@openvz.org
References: <20070620150733.GB6663@localhost.sw.ru>
In-Reply-To: <20070620150733.GB6663@localhost.sw.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706201753.33546.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 June 2007 17:07:34 Alexey Dobriyan wrote:
> Refactor PTRACE_PEEKUSR, PTRACE_POKEUSR implementation on i386.
> Ideas and concepts borrowed from utrace patchset by Roland McGrath.
> 
> Patch adds only two new concepts: struct ptrace_usr_area and struct regset.
> The former describes registers accessible through PTRACE_PEEKUSR,
> PTRACE_POKEUSR in generic way. Where it starts, where it ends, if it's a hole
> (needed to know when to return 0 and -EIO).
> 
> The latter is for abstracting various registers and operations on them
> (general-purpose regs, FPU regs, etc).
> 
> Unlike utrace patchset, usr_area has direct pointer to correspoding
> register set instead of magic number in specific array.

The new code seems to be larger than the old code. Not sure 
how that is an improvement?

Given the old bit operations weren't very nice, but then
the code rarely changes so it wasn't exactly a maintenance issue.

-Andi
