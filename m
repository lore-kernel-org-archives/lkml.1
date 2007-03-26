Return-Path: <linux-kernel-owner+w=401wt.eu-S1753660AbXCZSS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660AbXCZSS0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 14:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753656AbXCZSS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 14:18:26 -0400
Received: from smtp.osdl.org ([65.172.181.24]:43515 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753660AbXCZSSZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 14:18:25 -0400
Date: Mon, 26 Mar 2007 10:18:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, kjhall@linux.vnet.ibm.com, zohar@us.ibm.com,
       sailer@us.ibm.com
Subject: Re: [Patch 4/7] integrity: IMA integrity_measure() support
Message-Id: <20070326101820.20e78973.akpm@linux-foundation.org>
In-Reply-To: <1174666190.11149.4.camel@localhost.localdomain>
References: <1174666190.11149.4.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Mar 2007 12:09:50 -0400 Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> This is a re-release of Integrity Measurement Architecture(IMA) as a
> method of providing support for the integrity service framework API
> integrity_measure() call. When integrity_measure() is called, IMA
> submits the measurement (hash) of the file to the TPM chip, for
> inclusion in one of the chip's Platform Configuration Registers (PCR).
> IMA also keeps a list of all file names and hashes that have been
> submitted to the TPM, which can be viewed through securityfs. By
> separately requesting a TPM_Quote from the chip, an application can
> get a chip-signed value of the PCR, which, along with the list of
> measurements from IMA, can be used to attest, or prove to a third
> party, the validity of the hash list.  (The tpm-3.2.1 package includes
> example TPM applications for creating keys, and performing the
> TPM_Quote operation.) 
> 
> IMA can be included or excluded in the kernel configuration. If
> included in the kernel, IMA can also be enabled or disabled on the
> kernel command line with evm_enable_ima=0.

It breaks the ia64 build:

ima_fs_cleanup: discarded in section `.exit.text' from security/built-in.o

it's calling an __exit function from a non-_-exit function.

I'll remove the __exit tag from ima_fs_cleanup(), but that's the wrong fix
- really the caller should be fixed but it's all tangled up in a quite
unnecessary inlined function.

I must say that this code doesn't leave an impression of having sufficient
overall quality.  It needs some caring for. 
