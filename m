Return-Path: <linux-kernel-owner+w=401wt.eu-S1752221AbYJTGoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221AbYJTGoR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 02:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751291AbYJTGoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 02:44:07 -0400
Received: from ti-out-0910.google.com ([209.85.142.191]:1347 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbYJTGoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 02:44:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=DlhUpogL8PwIAHcl0k+UDqZFeIJNsn3XQ/VeStY/H7F5AWb669FFj2Pjqeu7c1+BIq
         4bsxDssU4bqUv8McDMIQMM2ZzF7JGJydhSgYM/+XcQc0rfKPALmpzZ2vTctUW7dgf83J
         Z23oVuMuqxBfT352D8eT12I5goWoWG0PfFlgg=
Message-ID: <df9815e70810192344v3a80f70awfc8f621e155bda6@mail.gmail.com>
Date: Mon, 20 Oct 2008 14:44:04 +0800
From: "Jike Song" <albcamus@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: add missed clobber for 32-bit memmove
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <48F8BEE1.1010000@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1224249353-3032-1-git-send-email-albcamus@gmail.com>
	 <1224249353-3032-2-git-send-email-albcamus@gmail.com>
	 <48F8BEE1.1010000@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 18, 2008 at 12:35 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> Jike Song wrote:
>>
>> memmove() is implemented by inline assembly. It calls std at first
>> and cld at last, but EFLAGS still should be clobbered.
>
> gcc always treats EFLAGS as clobbered on x86.  The "cc" clobber is needed on
> some platforms, but is a noop on x86.

No wonder there are inline asms that clobbered eflags/rflags but
without declaring them as clobbered. Thanks for your information.

It turns out that I need to read through the gcc x86 back-end as long
as I want to be a Linux/x86 developer, right? That sounds
discouraging:)

-- 
Thanks,
Jike
