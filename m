Return-Path: <linux-kernel-owner+w=401wt.eu-S1756734AbYH1A1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734AbYH1A1S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 20:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754454AbYH1A1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 20:27:05 -0400
Received: from abydos.nerdbox.net ([216.151.149.55]:42156 "EHLO
	abydos.NerdBox.Net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120AbYH1A1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 20:27:04 -0400
Date: Wed, 27 Aug 2008 17:27:00 -0700 (PDT)
From: Steve VanDeBogart <vandebo-lkml@NerdBox.Net>
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [PATCH] exit signals: use of uninitialized field notify_count
In-Reply-To: <20080827080136.GA4453@elte.hu>
Message-ID: <alpine.DEB.1.00.0808271721140.15543@abydos.NerdBox.Net>
References: <alpine.DEB.1.00.0808261505550.15543@abydos.NerdBox.Net> <20080827080136.GA4453@elte.hu>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Aug 2008, Ingo Molnar wrote:

>
> * Steve VanDeBogart <vandebo-lkml@NerdBox.Net> wrote:
>
>> task->signal->notify_count is only initialized if
>> task->signal->group_exit_task is not NULL.  Reorder a conditional so
>> that uninitialised memory is not used.  Found by Valgrind.
>>
>> Signed-off-by: Steve VanDeBogart <vandebo-lkml@nerdbox.net>
>
> Applied the commit below to tip/core/urgent, thanks. Roland/Oleg, do you
> concur with the fix?
>
> nice find btw. - are you running Valgrind on UML?

Thanks.  Yes, I am running Valgrind on UML.  I revisited the previous 
patches that allowed it and tried to remove any unnecessary changes.
The patches and a recipe on how to make it work can be found on the
UML wiki: http://uml.jfdi.org/uml/Wiki.jsp?page=ValgrindingUML

I'll stir up trouble by posting the kernel patches on lkml after a
little more cleanup.

--
Steve
