Return-Path: <linux-kernel-owner+w=401wt.eu-S1763283AbXHVOXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763283AbXHVOXq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 10:23:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760111AbXHVOXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 10:23:39 -0400
Received: from wr-out-0506.google.com ([64.233.184.228]:10976 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756869AbXHVOXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 10:23:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AzJokoXSSrrEVo3KCDMQtDT78J7xtMaEYVXWpfBHxrwa8sOoMkdc7I+O5KdMBqnWSWRLr+jMm8r1F+xPhn/Ydm7yEUnFy5TG5d4QTYpM0LOK86jIUMEa+seh1nXDljjNduwimSDDkIAh1VKW27SXTXhXV5xZKQwQ2tnwtFj5fs0=
Message-ID: <851fc09e0708220723v5fcb2fc5n4993c6f859c28b83@mail.gmail.com>
Date: Wed, 22 Aug 2007 22:23:27 +0800
From: "huang ying" <huang.ying.caritas@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [PATCH 0/3] x86_64 EFI runtime service support
Cc: "Yinghai Lu" <yhlu.kernel@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Chandramouli Narayanan" <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org, "Aaron Durbin" <adurbin@google.com>
In-Reply-To: <20070822111155.GP32640@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1187313920.28497.1.camel@caritas-dev.intel.com>
	 <1187580031.27947.67.camel@caritas-dev.intel.com>
	 <46C9CB89.7020603@zytor.com> <20070821113310.GF32640@bingen.suse.de>
	 <46CAC168.7090102@zytor.com> <20070821114548.GI32640@bingen.suse.de>
	 <86802c440708211658j1fb2a8caj41e1bb8bffa4baf4@mail.gmail.com>
	 <20070822012216.GN32640@bingen.suse.de>
	 <86802c440708212343x3b1438d3m4bbbfbd04db1f1ef@mail.gmail.com>
	 <20070822111155.GP32640@bingen.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/22/07, Andi Kleen <ak@suse.de> wrote:
> The short term fix is probably to just add a version number to
> the zero page and make sure new changes only add stuff to the
> end and the kernel has reasonable compat code for old versions.
>
> Then LinuxBIOS would need to be changed to supply that version number.
>
> Perhaps it could also include a checksum just to detect old BIOS
> that don't supply a version number.
>
> Long term I'm not sure. Adding LinuxBIOS specific tables also doesn't
> sound very attractive.

My proposal: Use Peter proposed "linked list of struct setup_data"
style boot protocol as long term goal.

To smooth the transforming process, the following back compatible
scheme can be taken:

1. Keep zero page as an informal external boot protocol, and marked it
as deprecated for external usage.
2. Add a magic number to standard boot protocol, which is set by
bootloader to indicate the new style or old style boot protocol is
used.
3. Add the pointer to "linked list of struct setup_data" to standard
boot protocol.
4. If kernel is booted with correct magic number, the kernel will
convert "linked list" to zero page, or use "linked list" directly. If
kernel is booted with incorrect magic number, the kernel will use the
"zero page" from bootloader or convert "zero page" to "linked list".

The current kexec/LinuxBIOS using "informal" zero page protocol can
boot the new kernel, because the "zero page" protocol is kept for
short term. New version of bootloader should use "linked list"
protocol instead of "zero page" protocol.

In the future, when all bootloaders use new protocol, the "zero page"
is made internal formally.

Any comment is welcome.

Best Regards,
Huang Ying
