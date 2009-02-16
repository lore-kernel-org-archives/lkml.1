Return-Path: <linux-kernel-owner+w=401wt.eu-S1755857AbZBPXcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857AbZBPXcu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 18:32:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751064AbZBPXcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 18:32:42 -0500
Received: from h5.dl5rb.org.uk ([81.2.74.5]:57657 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751404AbZBPXcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 18:32:41 -0500
Date: Mon, 16 Feb 2009 23:32:16 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Martin Michlmayr <tbm@cyrius.com>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: "elf core dump: fix get_user use" breaks mips compilation
Message-ID: <20090216233216.GA19484@linux-mips.org>
References: <20090216120136.GA9057@deprecation.cyrius.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090216120136.GA9057@deprecation.cyrius.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 16, 2009 at 01:01:36PM +0100, Martin Michlmayr wrote:

> Hi Roland,
> 
> Your change "elf core dump: fix get_user use"  (which made it into
> 2.6.28.5) breaks the compilation on MIPS (which sets -Werror):
> 
>   CC      arch/mips/kernel/binfmt_elfn32.o
> cc1: warnings being treated as errors
> arch/mips/kernel/../../../fs/binfmt_elf.c: In function ‘vma_dump_size’:
> arch/mips/kernel/../../../fs/binfmt_elf.c:1202: warning: ‘word’ may be used uninitialized in this function
> make[1]: *** [arch/mips/kernel/binfmt_elfn32.o] Error 1

Partially expanding get_user() the code basically does this:

	int word;

	if (access_ok(...))
		__get_user(word, header);
	else
		word = 0;

And gcc is unable to figure out that word will always be assigned to by
both paths of the if statement.  Older gcc versions used to have that
problem.  I can't reproduce your problem with gcc 4.3.2 and I assume
you're using something older than that?

  Ralf
