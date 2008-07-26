Return-Path: <linux-kernel-owner+w=401wt.eu-S1756538AbYGZQkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538AbYGZQkz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 12:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752947AbYGZQks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 12:40:48 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:27972 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946AbYGZQkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 12:40:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=h4unxSPI9oWr574auFXHoNBTLFTzvnzKawPVcM5O3GPwd8w3RmGT7/fsrR1g60OUFC
         FAHGsUvxJeQj/XA6HWnbc6rcR3yXHrRFzdLEQP84Pel5feniPR7PJwgxaH3nVsLp5EH3
         LxE1ts2SaPiSUWG/D9Qnlp3J6eB0dHP35ZfGA=
Subject: Re: Fw: asm-x86/byteorder.h, CONFIG_X86_BSWAP leaks to userland
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Olaf Hering <olaf@aepfle.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080726013931.bcc4682d.akpm@linux-foundation.org>
References: <20080726013931.bcc4682d.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Sat, 26 Jul 2008 09:40:46 -0700
Message-Id: <1217090446.5971.57.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-07-26 at 01:39 -0700, Andrew Morton wrote:
> 
> Begin forwarded message:
> 
> Date: Mon, 21 Jul 2008 15:18:46 +0200
> From: Olaf Hering <olaf@aepfle.de>
> To: linux-kernel@vger.kernel.org
> Subject: asm-x86/byteorder.h, CONFIG_X86_BSWAP leaks to userland
> What is the purpose of CONFIG_X86_BSWAP in asm-x86/byteorder.h?
> 
> An undefined CONFIG_foo defaults to 0 (I think), so bswap is never used.
> Is this done on purpose, or can the CONFIG_ foo be moved inside
> __KERNEL__ somehow?

I believe it's there to prevent the bswap instruction from being used on
early x86_32 models (i386/i486).  As this will be 0 in userspace it is
effectively never using the bswap instruction for these routines.

I'm not sure if it's time yet to make the bswap ones be exported, as they
would no longer be usable for those early machines.  X86 guys CC:d.

Harvey

