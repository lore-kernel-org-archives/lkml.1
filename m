Return-Path: <linux-kernel-owner+w=401wt.eu-S1756831AbYAERC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831AbYAERC4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 12:02:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755992AbYAERCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 12:02:47 -0500
Received: from fk-out-0910.google.com ([209.85.128.185]:32970 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755580AbYAERCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 12:02:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=sDUKtA6nV6yR1z3LYhlesrlq2vfAztITixn9rwQO3h6nP82MlXhoaWT765V2DFrQkt99SU3O5nW7JoRLAGiu0fJlmkAzwaXeverJGMTkYnJMFT3/u9HDg9+aiwdgM9inQw4zd/BDlApEtXOBYRD3LH7u/PYVQ+4o+IoClm92Arg=
Message-ID: <477FB82F.1070501@gmail.com>
Date: Sat, 05 Jan 2008 18:02:39 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Phil Endecott <phil_wueww_endecott@chezphil.org>,
       linux-kernel@vger.kernel.org
Subject: Re: strace, accept(), ERESTARTSYS and EINTR
References: <1199480498017@dmwebmail.japan.chezphil.org> <p731w8w8gcw.fsf@bingen.suse.de>
In-Reply-To: <p731w8w8gcw.fsf@bingen.suse.de>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2008 04:03 PM, Andi Kleen wrote:
>    if (!strcmp(current->comm, "yourprogramwithoutpath"))
>             printk("%s:%d ERESTART\n", __FILE__, __LINE__);
> 
> [the later two might need adding linux/string.h and/or linux/sched.h includes
> to the files if they don't compile]
> 
> to all of them. Then recompile and boot that kernel.

If I'm not completely blind, there is no suspicous ERESTARTSYS in
PF_INET:SOCK_STREAM path.

Anyway even if it was returned by kernel syscall, glibc should put it in errno
and return -1 (since it is >= -4095 and < 0). He sees it in the accept retval.
Something rotten, probably broken/racy ?ntpl? implementation of syscalls or
somewhat?

regards,
-- 
Jiri Slaby
Faculty of Informatics, Masaryk University
Suse Labs

