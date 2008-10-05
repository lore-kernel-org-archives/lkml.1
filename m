Return-Path: <linux-kernel-owner+w=401wt.eu-S1754202AbYJEI4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202AbYJEI4l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 04:56:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752592AbYJEI4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 04:56:34 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:8651 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416AbYJEI4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 04:56:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=JqAFdP8dsg4JSvHP8q4Rx6nJepRNT1Yq8IRk9prQQIyVsvhSkelVV5tspC684bP1zl
         yZ18pw7e5lsktsieieINwkiBWGRT0fGfWdmMOHP9PsENwNaZ7WzhMS5RCyyT/cyhcmlC
         zF9UA06ZyHA9jCqSf4wYlOIT7yNIhGE2i8I2o=
Message-ID: <851fc09e0810050156y114007e4hbdf3e6c5562004d3@mail.gmail.com>
Date: Sun, 5 Oct 2008 16:56:32 +0800
From: "huang ying" <huang.ying.caritas@gmail.com>
To: "Yinghai Lu" <yinghai@kernel.org>
Subject: Re: [RFC PATCH] x86: make 64bit efi to use ioremap_cache for efi_ioremap
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Huang Ying" <ying.huang@intel.com>, linux-kernel@vger.kernel.org
In-Reply-To: <86802c440810041044m5b950721s8700bb6cd2fe75d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1223101400-8819-1-git-send-email-yhlu.kernel@gmail.com>
	 <851fc09e0810040235g2ab97bdai612c0a2829f83f5c@mail.gmail.com>
	 <86802c440810041044m5b950721s8700bb6cd2fe75d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 5, 2008 at 1:44 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Sat, Oct 4, 2008 at 2:35 AM, huang ying <huang.ying.caritas@gmail.com> wrote:
[...]
>> Using __va and efi_ioremap() here is to make EFI support compatible
>> with kexec. Because EFI provide only efi_enter_virtual_mode(), no
>> efi_leave_virtual_mode(), we should make EFI runtime memory area
>> mapped to same virtual memory area in original kernel and kexeced
>> kernel, so that the EFI runtime services can be used in kexeced
>> kernel.
>
> so need to make efi range all under direct-mapping like E820-RAM?

Some EFI runtime range is just some RAM area used by EFI runtime
services, they can be direct-mapped. Some EFI runtime range may be IO
MEM range used by EFI runtime services, it is possible that these IO
MEM range can not be direct-mapped. So I implement efi_ioremap() to
deal with them.

Best Regards,
Huang Ying
