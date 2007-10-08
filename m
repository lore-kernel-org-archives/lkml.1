Return-Path: <linux-kernel-owner+w=401wt.eu-S1754878AbXJHLSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbXJHLSw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 07:18:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753354AbXJHLSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 07:18:42 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:49646 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038AbXJHLSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 07:18:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=r2aPmCwai07OAIx4+zPwwAt6RvfUnq03X/PKl5zocCkOLKZqXTEHHgGzDOO3bWY3hMi2onHsD56WNgEQQuGhUadm2C7ZHNyCijeB2weprSbMfzqnF0+XV2iviH10771mHGaDb5lwWSU+Qa3Ahey6MHF11dl8mMez94CESWronN4=
Message-ID: <84144f020710080418r37639efcx495bdb199f7540c2@mail.gmail.com>
Date: Mon, 8 Oct 2007 14:18:39 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Ryan Finnie" <ryan@finnie.org>
Subject: Re: msync(2) bug(?), returns AOP_WRITEPAGE_ACTIVATE to userland
Cc: "Erez Zadok" <ezk@cs.sunysb.edu>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, "Colin Watson" <cjwatson@ubuntu.com>
In-Reply-To: <cfa94dc20710071858l71ba6115p716d24f1bbcce1c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0710072255280.688@sbz-30.cs.Helsinki.FI>
	 <cfa94dc20710071858l71ba6115p716d24f1bbcce1c@mail.gmail.com>
X-Google-Sender-Auth: ad3b4c1ce35dca2b
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ryan,

On 10/8/07, Ryan Finnie <ryan@finnie.org> wrote:
> Doesn't appear to be enough.  I can't figure out why (since it appears
> write_cache_pages bubbles up directly to sys_msync), but with that
> patch applied, in my test case[1], msync returns -1 EIO.  However,
> with the exact same kernel without that patch applied, msync returns
> 524288 (AOP_WRITEPAGE_ACTIVATE).  But as your patch specifically flips
> 524288 to 0, I can't figure out how it eventually returns  -1 EIO.
>
> [1] "apt-get check" on a unionfs2 mount backed by tmpfs over cdrom,
> standard livecd setup

You have swap device disabled, right? If so, I can't see any reason
why msync(2) on tmpfs would return -EIO. Can you please send a strace
log for your test case?

                                       Pekka
