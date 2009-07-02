Return-Path: <linux-kernel-owner+w=401wt.eu-S1756111AbZGBJg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111AbZGBJg6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 05:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755949AbZGBJgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 05:36:39 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60890 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755935AbZGBJgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 05:36:38 -0400
Message-ID: <4A4C8021.8070509@redhat.com>
Date: Thu, 02 Jul 2009 17:38:41 +0800
From: Amerigo Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090319)
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
       Serge Hallyn <serue@us.ibm.com>, David Howells <dhowells@redhat.com>,
       James Morris <jmorris@namei.org>, linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch 3/3] elf: use a macro instead of a raw number
References: <20090701050840.6188.84560.sendpatchset@localhost.localdomain>	<20090701050900.6188.41697.sendpatchset@localhost.localdomain> <20090701073810.A80FC21D57@magilla.sf.frob.com>
In-Reply-To: <20090701073810.A80FC21D57@magilla.sf.frob.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath wrote:
>> Use TASK_COMM_LEN instead of the raw number 16.
>>     
>
> This is probably a bad idea.  elf_prpsinfo layout is a userland ABI.
> AFAIK there is no reason TASK_COMM_LEN could not be enlarged in the kernel.
>   

Thanks for your reply.

But in the kernel code, pr_fname is copied from ->comm, they should
be equal, shouldn't they?

Hmm, yes, I agree that 16 is too small for ELF core dump, the longer
names get truncated and gdb will complain about this...

I can cook a patch to increase this length if you agree.

Thanks.

