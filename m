Return-Path: <linux-kernel-owner+w=401wt.eu-S1755345AbYFDCQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345AbYFDCQq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 22:16:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751847AbYFDCQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 22:16:38 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:17522 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774AbYFDCQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 22:16:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lFtB/yPabCsalY8jFVFXuPMOKh7mE4xLJKbw1tHm3pSCstCDccv4wYI0u1TWM87JOPsyCZiKDhWM7jv0SwHMb0FY1mz7edQIyIpTY/noS460IrMETXvJy+jBT4ZXzQfKvdiBC2VmlO8y8t/L7WV7WSgQZIp7HiIEBEayHW4p2iY=
Message-ID: <3877989d0806031916wf11bb2t3847aa630fb39e60@mail.gmail.com>
Date: Wed, 4 Jun 2008 10:16:35 +0800
From: "Luming Yu" <luming.yu@gmail.com>
To: "Petr Tesarik" <ptesarik@suse.cz>
Subject: Re: [RFC PATCH] set TASK_TRACED before arch_ptrace code to fix a race
Cc: "Roland McGrath" <roland@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-ia64@vger.kernel.org
In-Reply-To: <48455619.6040608@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3877989d0805211947i54bacc7cv619541e9b40824fb@mail.gmail.com>
	 <3877989d0805251830w70f19e4cu46fbc32148217749@mail.gmail.com>
	 <3877989d0805262031i29db16bcjfa31652afc746b49@mail.gmail.com>
	 <20080527040454.053C526FA9E@magilla.localdomain>
	 <3877989d0805262249yab130cbyfc5f5e54065cec5c@mail.gmail.com>
	 <20080527061209.9A24426FAA6@magilla.localdomain>
	 <1211869515.29836.2.camel@elijah.suse.cz>
	 <3877989d0806022304w35764b17p9d4c3c95eceae0f5@mail.gmail.com>
	 <48450864.6080707@suse.cz> <48455619.6040608@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It's definitely a bug in strace. For some reason (I don't care about)
> the execve() syscall produces an extra notification. However, this
> notification message is suppressed when SIGTRAP is blocked. This
> explains why the test case fails only when SIGTRAP is blocked.

This is exact problem I suspected and I was trying to address in my hack..
Since there are several processes involved in the pretty complex
ptrace scenario.,
I need to capture all processes context with kdump to confirm this is
exact root-cause
for the problem. But kdump doesn't work for me..I'm trying to solve it now..

I'm also in doubt about the semantic correctness of the test case..
Since SIGTRAP is so necessary to get ptrace work, is it legitimate to
block it in test case?

One more thing I need to say is:
Same strace works for utrace enabled kernel on IA64.. If the bug is in
strace, how could it happen?
