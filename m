Return-Path: <linux-kernel-owner+w=401wt.eu-S1759727AbYELD64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759727AbYELD64 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 23:58:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754517AbYELD6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 23:58:46 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:32453 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755882AbYELD6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 23:58:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=AK2nCcpHEftLN0JbE8lbil3gGPoXI+LX77WnvlymrhFP6rtI6u3/cSDixMBO988B+8xN/Hln1kQdL4HYcyT3f36pxqIpmSblMaPzK5XG+idhIqXq1x0T5f8iS1tCmyNv2Mi3uxRThxfzikUk9q+k2oiL4o+esBhMfEWGcs1vhLo=
Date: Mon, 12 May 2008 11:56:43 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, WANG Cong <wangcong@zeuux.org>
Subject: Re: [Patch 7/9] fs/exec.c: fix wrong return value of
	prepare_binprm()
Message-ID: <20080512035643.GE2572@hacking>
References: <1210254754206-git-send-email-xiyou.wangcong@gmail.com> <12102548553947-git-send-email-xiyou.wangcong@gmail.com> <20080510193105.GG13907@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080510193105.GG13907@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 10, 2008 at 08:31:05PM +0100, Al Viro wrote:
>On Thu, May 08, 2008 at 09:52:32PM +0800, WANG Cong wrote:
>> All prepare_binprm()'s callers assume that prepare_binprm() fails
>> when it returns negative. However, prepare_binprm() most probably returns
>> the return value of kernel_read(), which may return positive on failure!
>> 
>> Thus this should be fixed.
>
>Since when does read return positive on failure?

When an EIO occurs, I think. For example,

        retval = kernel_read(interpreter, interp_elf_ex->e_phoff,
                             (char *)elf_phdata,size);
        error = -EIO;
        if (retval != size) {
                if (retval < 0)
                        error = retval;
                goto out_close;
        }


-- 
Hi, I'm a .signature virus, please copy/paste me to help me spread
all over the world.
