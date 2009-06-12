Return-Path: <linux-kernel-owner+w=401wt.eu-S1763420AbZFLVFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763420AbZFLVFy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 17:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758158AbZFLVFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 17:05:46 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:55837 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754660AbZFLVFp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 17:05:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ZCD9RsnGq2iEQ8ocm05JbyV+z8SupMi98bu2AHNiEi0de1ZVni44VjRZo0c7RgnrO8
         JpdNWmRdwLcgQtj5VeMdSmRsALODtGRKZ6DgyNDtNtv3MV/qem3fwIdVMCq3xkWVDIC+
         oCJl9otXbrRlXAU1UrbzJEOpgbxqS0Mpz6T9Q=
MIME-Version: 1.0
In-Reply-To: <200906122205.57362.rusty@rustcorp.com.au>
References: <200906122205.57362.rusty@rustcorp.com.au>
Date: Fri, 12 Jun 2009 14:05:46 -0700
X-Google-Sender-Auth: 8c4424eb18cc8c3d
Message-ID: <12c511ca0906121405x5ccd0a60k4b804266a87a7896@mail.gmail.com>
Subject: Re: [PULL] module and parameter
From: Tony Luck <tony.luck@intel.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Amerigo Wang <amwang@redhat.com>,
       alex@shark-linux.de, David Miller <davem@davemloft.net>,
       rth@twiddle.net, sfr@canb.auug.org.au
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 5:35 AM, Rusty Russell<rusty@rustcorp.com.au> wrote:
> The following changes since commit 8ebf975608aaebd7feb33d77f07ba21a6380e086:
>  Randy Dunlap (1):
...
>      module: trim exception table on init free.

This is causing build errors for ia64:

arch/ia64/mm/extable.c: In function 'ex_to_addr':
arch/ia64/mm/extable.c:58: error: 'const struct exception_table_entry'
has no member named 'insn'
arch/ia64/mm/extable.c:58: error: 'const struct exception_table_entry'
has no member named 'insn'
arch/ia64/mm/extable.c: In function 'trim_init_extable':
arch/ia64/mm/extable.c:69: error: dereferencing pointer to incomplete type
arch/ia64/mm/extable.c:70: error: implicit declaration of function
'within_module_init'
arch/ia64/mm/extable.c:70: error: dereferencing pointer to incomplete type
arch/ia64/mm/extable.c:71: error: dereferencing pointer to incomplete type
arch/ia64/mm/extable.c:72: error: dereferencing pointer to incomplete type
arch/ia64/mm/extable.c:75: error: dereferencing pointer to incomplete type
arch/ia64/mm/extable.c:76: error: dereferencing pointer to incomplete type
arch/ia64/mm/extable.c:76: error: dereferencing pointer to incomplete type
arch/ia64/mm/extable.c:78: error: dereferencing pointer to incomplete type

I note that this commit has been reverted in linux-next.  What's going on?

-Tony
