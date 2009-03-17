Return-Path: <linux-kernel-owner+w=401wt.eu-S1755748AbZCQQDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748AbZCQQDq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 12:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754384AbZCQQDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 12:03:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40548 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754087AbZCQQDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 12:03:36 -0400
Date: Tue, 17 Mar 2009 08:56:34 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: =?ISO-8859-15?Q?G=E1bor_Melis?= <mega@retes.hu>
cc: Oleg Nesterov <oleg@redhat.com>, Davide Libenzi <davidel@xmailserver.org>,
       Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Friesen <cfriesen@nortel.com>, linux-kernel@vger.kernel.org
Subject: Re: Q: SEGSEGV && uc_mcontext->ip (Was: Signal delivery order)
In-Reply-To: <200903170923.56430.mega@retes.hu>
Message-ID: <alpine.LFD.2.00.0903170848490.3082@localhost.localdomain>
References: <200903141750.37238.mega@retes.hu> <49BED93B.1090700@nortel.com> <20090317041337.GA29740@redhat.com> <200903170923.56430.mega@retes.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 17 Mar 2009, Gábor Melis wrote:
> 
> As an application developer what I'd like to have is this: synchronously 
> generated signals are delivered before asynchronously generated ones. 

I agree that it would be nice, but quite frankly, it's simply not how 
signals work. It would be a reasonably invasive change, and you wouldn't 
really be able to rely on it anyway since most kernels don't work that 
way.

What you might be able to do instead is to walk signal frames backwards by 
hand. IOW, accept the fact that sometimes signals end up being nested, but 
then you could try to find the right frame by just looking at them.

And your trick of comparing 'info->si_ip' with 'context->uc_mcontext->ip' 
is pretty good, and lets the code itself walk the signal frames by just 
depending on the fault happening again.

			Linus
