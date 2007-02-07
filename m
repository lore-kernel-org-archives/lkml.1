Return-Path: <linux-kernel-owner+w=401wt.eu-S965544AbXBGGos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965544AbXBGGos (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 01:44:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965644AbXBGGos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 01:44:48 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:32854 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965544AbXBGGor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 01:44:47 -0500
Date: Wed, 7 Feb 2007 12:14:32 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Etienne Lorrain <etienne_lorrain@yahoo.fr>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: Re : [PATCH] Compressed ia32 ELF file generation for loading by Gujin 1/3
Message-ID: <20070207064432.GB12170@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <20070206131205.17780.qmail@web26908.mail.ukl.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070206131205.17780.qmail@web26908.mail.ukl.yahoo.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 06, 2007 at 01:12:05PM +0000, Etienne Lorrain wrote:
> > Building real mode code with kernel binary (vmlinux) has got another
> > disadvantage that it breaks using vmlinux for kdump purposes. One compiles
> > the kernel binary to execute from a different address but real mode code/data
> > will continue to be at virtual/physical addr 0 and kexec can not load it
> > as that physical memory is not available at all. Kdump skips the real mode
> > code execution.
> 
>  But that is exactly what you want and need for kdump, isn't it?
>  The ELF file did not change, the program header has the last index at
> address 0 that you do not want to load because you do not want to
> execute the real-mode code. Load the rest and provide the 4 Kbytes
> parameter page - it should work.

How do I know which program header is real mode code and the boot loader
is not supposed to load it? May be PT_LOAD header with physical addr 0?
What happens if changes happen and down the line we start compiling 
real mode code for non-zero address? Hence I think keeping real mode
code out of vmlinux might prove to be a good idea.

Secondly, if you compile real mode code with vmlinux, what would be the
entry point for this ELF file? Real mode entry? Then I have not way to
find out from ELF headers where is the protected mode entry point and
I can not do use this vmlinux with kexec/kdump. 

OTOH, now bzImage is relocatable. Is this image going to be relocatable?
How do we take care of that?

Thanks
Vivek
