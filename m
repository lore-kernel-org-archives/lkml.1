Return-Path: <linux-kernel-owner+w=401wt.eu-S1757399AbYKVJjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399AbYKVJjw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 04:39:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753299AbYKVJjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 04:39:43 -0500
Received: from h4.dl5rb.org.uk ([81.2.74.4]:54055 "EHLO
	ditditdahdahdah-dahdahdahditdit.dl5rb.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753619AbYKVJjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 04:39:42 -0500
Date: Sat, 22 Nov 2008 09:39:35 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: David Daney <ddaney@caviumnetworks.com>
Cc: linux-mips <linux-mips@linux-mips.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MIPS: Make BUG() __noreturn.
Message-ID: <20081122093935.GA31703@linux-mips.org>
References: <49260E4C.8080500@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49260E4C.8080500@caviumnetworks.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2008 at 05:26:36PM -0800, David Daney wrote:
> From: David Daney <ddaney@caviumnetworks.com>
> Date: Thu, 20 Nov 2008 17:26:36 -0800
> To: linux-mips <linux-mips@linux-mips.org>
> CC: linux-kernel@vger.kernel.org
> Subject: [PATCH] MIPS: Make BUG() __noreturn.
> Content-Type: text/plain; charset=ISO-8859-1; format=flowed
> 
> MIPS: Make BUG() __noreturn.

Please don't repeat the subject in the body of a patch email.  Git takes
the subject followed by the body upto the --- line as the log message so
this is just duplication that will need to be manually deleted again.

> Often we do things like put BUG() in the default clause of a case
> statement.  Since it was not declared __noreturn, this could sometimes
> lead to bogus compiler warnings that variables were used
> uninitialized.
>
> There is a small problem in that we have to put a magic while(1); loop to
> fool GCC into really thinking it is noreturn.  This makes the new
> BUG() function 3 instructions long instead of just 1, but I think it
> is worth it as it is now unnecessary to do extra work to silence the
> 'used uninitialized' warnings.
>
> I also re-wrote BUG_ON so that if it is given a constant condition, it
> just does BUG() instead of loading a constant value in to a register
> and testing it.

I don't like the endless loop in the BUG() macros but at this time it seems
the best solution.  Looking forward to __builtin_noreturn().

Patch applied,

  Ralf
