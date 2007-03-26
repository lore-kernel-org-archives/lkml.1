Return-Path: <linux-kernel-owner+w=401wt.eu-S1753624AbXCZK2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624AbXCZK2i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 06:28:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753625AbXCZK2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 06:28:38 -0400
Received: from smtp.osdl.org ([65.172.181.24]:52127 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753624AbXCZK2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 06:28:36 -0400
Date: Mon, 26 Mar 2007 02:27:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, kjhall@linux.vnet.ibm.com, zohar@us.ibm.com
Subject: Re: [Patch 0/7] integrity service framework and provider
Message-Id: <20070326022735.7d7c16f8.akpm@linux-foundation.org>
In-Reply-To: <1174666139.11149.0.camel@localhost.localdomain>
References: <1174666139.11149.0.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Mar 2007 12:08:59 -0400 Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> This is a set of updates to the integrity service framework, previously 
> accepted into -mm, EVM a new integrity service provider, and a new LSM 
> module called Integrity Based Access Control(IBAC), a sample consumer of
> the integrity framework API.

I'll fix this:

security/integrity_dummy.c: In function 'dummy_inode_setxattr':
security/integrity_dummy.c:94: warning: implicit declaration of function 'capable'
security/integrity_dummy.c:94: error: 'CAP_SYS_ADMIN' undeclared (first use in this function)
security/integrity_dummy.c:94: error: (Each undeclared identifier is reported only once
security/integrity_dummy.c:94: error: for each function it appears in.)

Then I'll ask you to fix these, some of which are real bugs:

security/integrity_dummy.c: In function 'dummy_verify_metadata':
security/integrity_dummy.c:30: warning: 'error' may be used uninitialized in this function
security/integrity_dummy.c:28: warning: 'value' may be used uninitialized in this function
security/integrity_dummy.c:29: warning: 'size' may be used uninitialized in this function

And then I'll probably end up fixing some of this lot too:

security/evm/evm_main.c: In function 'evm_verify_xattr':
security/evm/evm_main.c:165: warning: format '%d' expects type 'int', but argument 5 has type 'ssize_t'
security/evm/evm_crypto.c: In function 'update_link_hash':
security/evm/evm_crypto.c:94: warning: implicit declaration of function 'kernel_readlink'
security/evm/evm_crypto.c: In function 'evm_init_integrity':
security/evm/evm_crypto.c:187: warning: format '%d' expects type 'int', but argument 4 has type 'size_t'
security/evm/evm_main.c: In function 'init_evm':
security/evm/evm_main.c:903: warning: control may reach end of non-void function 'evm_ima_init' being inlined


How does stuff like this get through?  It's just x86_64 allmodconfig.
