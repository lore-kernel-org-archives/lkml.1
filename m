Return-Path: <linux-kernel-owner+w=401wt.eu-S1030678AbXDYPFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030678AbXDYPFN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 11:05:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030958AbXDYPFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 11:05:13 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:37428 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030678AbXDYPFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 11:05:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XNKqvb83D06gmVbAcZruGmjp/3TjACj0qjQSb0B/iaUmsJHRp9Y9hyHBFfXkkjZW+GP1MgjDXdsQiOhpxTn/iY/I5om2vnHIYUjVpEisxAn65tY7sE9Xy6xhIWCTd0GG3MP660FCItVo1CksFq8GbRmo3HKr4q1oZ63kGjXhcZ0=
Message-ID: <f9eabcda0704250805w73279d07i4655f47fa00c2ff0@mail.gmail.com>
Date: Wed, 25 Apr 2007 12:05:09 -0300
From: "Miguel Freitas" <mfreitas@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Advice on debuging the fork syscall hanging forever
In-Reply-To: <f9eabcda0704250746j26c67d03wc971c4ca32312ca1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f9eabcda0704250721k20ba8a6bl50b8b0494caf5531@mail.gmail.com>
	 <f9eabcda0704250746j26c67d03wc971c4ca32312ca1@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/25/07, Miguel Freitas <mfreitas@gmail.com> wrote:
> hey, could it be that this -513 is actually -ERESTARTNOINTR?

if so, that would be a good explanation why it hangs.

- copy_process() checks for pending signals, then set retval =
-ERESTARTNOINTR and returns.

- handle_signal has the following code:

                        case -ERESTARTNOINTR:
                                regs->rax = regs->orig_rax;
                                regs->rip -= 2;
                                break;

looks like it will keep trying to reenter the syscall forever,
subtracting 2 from ip will restart the syscall. by some reason the
signal is never really handled.

Miguel
