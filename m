Return-Path: <linux-kernel-owner+w=401wt.eu-S1752726AbYJ1Pf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726AbYJ1Pf0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 11:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751955AbYJ1PfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 11:35:14 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:33721 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbYJ1PfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 11:35:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=evJC9fmLyiqfgjmDtIRSq8fox+1ai2Mh0I8EZlfNb3ToeFkCaM53CiHEUUSfb9zxF1
         qLegG1bAK/RheRb2I6+XHNjUgncCLi2YeEE5JyYpEBxiWG28nDDv9rdRxWf1odaBcMs6
         oNNJrD2/eNcxpnwb8R1VlxSO41W5X2/55klm8=
Message-ID: <c62985530810280835k66d3ab87qd1783a0135228174@mail.gmail.com>
Date: Tue, 28 Oct 2008 16:35:11 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH] ftrace: fix current_tracer error return
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <alpine.DEB.1.10.0810281039130.29482@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c62985530810271618n11a8b674w5a60deaa335fdcc2@mail.gmail.com>
	 <alpine.DEB.1.10.0810271935320.20039@gandalf.stny.rr.com>
	 <c62985530810271644y1df6a13xbcd9d89b7a17ad75@mail.gmail.com>
	 <c62985530810280202r694a23e8l5233d892b3aa4330@mail.gmail.com>
	 <alpine.DEB.1.10.0810281039130.29482@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/28 Steven Rostedt <rostedt@goodmis.org>:
>
> The commit (in linux-tip) c2931e05ec5965597cbfb79ad332d4a29aeceb23
>  ( ftrace: return an error when setting a nonexistent tracer )
> added useful code that would error when a bad tracer was written into
> the current_tracer file.
>
> But this had a bug if the amount written was more than the amount read by
> that code. The first iteration would set the tracer correctly, but since
> it did not consume the rest of what was written (usually whitespace), the
> userspace utility would continue to write what was not consumed. This
> second iteration would fail to find a tracer and return -EINVAL. Funny
> thing is that the tracer would have already been set.
>
> This patch just consumes all the data that is written to the file.
>
>
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>



An that corrects the bug when I failed to assign the sched_switch tracer.
Thanks Steven!

Tested-by: Frederic Weisbecker <fweisbec@gmail.com>
