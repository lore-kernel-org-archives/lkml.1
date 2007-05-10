Return-Path: <linux-kernel-owner+w=401wt.eu-S1758874AbXEJQjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758874AbXEJQjl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 12:39:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755006AbXEJQje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 12:39:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49420 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754775AbXEJQjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 12:39:33 -0400
Date: Thu, 10 May 2007 09:31:53 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: "Joerg Roedel" <joerg.roedel@amd.com>
Cc: "Andi Kleen" <andi@firstfloor.org>, ak@suse.de,
       linux-kernel@vger.kernel.org, "Benny Halevy" <bhalevy@panasas.com>,
       akpm@linux-foundation.org, zaitcev@redhat.com
Subject: Re: Andi, you broke my laptop :-)
Message-Id: <20070510093153.9f0accfb.zaitcev@redhat.com>
In-Reply-To: <20070510133555.GA5705@amd.com>
References: <20070509125616.cde56b8e.zaitcev@redhat.com>
	<20070510130144.GI14898@one.firstfloor.org>
	<20070510133555.GA5705@amd.com>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007 15:35:56 +0200, "Joerg Roedel" <joerg.roedel@amd.com> wrote:

> I debugged this problem a bit and my compiler[1]interprets the =A
> constraint as %rax instead of %edx:%eax on x86_64 which causes the
> problem. The appended patch provides a workaround for this and fixed the
> hang on my machine.
> 
> [1] gcc version 4.1.3 20070429 (prerelease) (Debian 4.1.2-5)

>  	alternative_io(ASM_NOP3, ".byte 0x0f,0x01,0xf9", X86_FEATURE_RDTSCP,
> -			 	 "=A" (ret), "0" (0ULL) : "ecx", "memory");
> +		       ASM_OUTPUT2("=a" (eax), "=d" (edx)),
> +		       "a" (0U), "d" (0U) : "ecx", "memory");

This works for me. Thanks, Joerg.

gcc version 4.1.2 20070424 (Red Hat 4.1.2-11)

-- Pete
