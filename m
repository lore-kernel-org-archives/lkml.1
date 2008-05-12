Return-Path: <linux-kernel-owner+w=401wt.eu-S1758283AbYELERt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758283AbYELERt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 00:17:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751558AbYELERl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 00:17:41 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:45621 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbYELERk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 00:17:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Svwf3fnCUmbPi+EXj4ObSjimn+MT5J3WIXMm7RFtGeeEFhcrKtoOLQObsSNDs1D84bmgtvT0Q9LWdw+d+LdL6B7lSy7rj6QLW0b23V8bQ9Cn/aZQWuEQdRC0Vzmk+/g87OojNmCvvqnY4M10sqe0XX4X01eA+WwtlB0LmKzYASU=
Date: Mon, 12 May 2008 12:15:34 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, WANG Cong <wangcong@zeuux.org>
Subject: Re: [Patch 7/9] fs/exec.c: fix wrong return value of
	prepare_binprm()
Message-ID: <20080512041534.GG2572@hacking>
References: <1210254754206-git-send-email-xiyou.wangcong@gmail.com> <12102548553947-git-send-email-xiyou.wangcong@gmail.com> <20080510193105.GG13907@ZenIV.linux.org.uk> <20080512035643.GE2572@hacking> <20080512040122.GN13907@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080512040122.GN13907@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2008 at 05:01:22AM +0100, Al Viro wrote:
>On Mon, May 12, 2008 at 11:56:43AM +0800, WANG Cong wrote:
>> On Sat, May 10, 2008 at 08:31:05PM +0100, Al Viro wrote:
>> >On Thu, May 08, 2008 at 09:52:32PM +0800, WANG Cong wrote:
>> >> All prepare_binprm()'s callers assume that prepare_binprm() fails
>> >> when it returns negative. However, prepare_binprm() most probably returns
>> >> the return value of kernel_read(), which may return positive on failure!
>> >> 
>> >> Thus this should be fixed.
>> >
>> >Since when does read return positive on failure?
>> 
>> When an EIO occurs, I think. For example,
>
>No.  On EIO it returns -EIO, TYVM...
>

Hmm, it should. Thanks for your correction.


>>         retval = kernel_read(interpreter, interp_elf_ex->e_phoff,
>>                              (char *)elf_phdata,size);
>>         error = -EIO;
>>         if (retval != size) {
>>                 if (retval < 0)
>>                         error = retval;
>>                 goto out_close;
>>         }
>
>Which is what we do on short read here.  FWIW, -EINVAL might be saner
>choice - it's "binary is corrupted", not "read had failed".

IMO, -EIO is fine, because -EINVAL means "Invalid argument", but
there's nothing wrong with arguments here, just some bad things occurred
on reading the binary.

And even if it is really "binary is corrupted", then -ENOEXEC is
better than -EINVAL, isn't it?

Anyway, kernel_read() may return postive when not success.

Thanks.

-- 
Hi, I'm a .signature virus, please copy/paste me to help me spread
all over the world.
