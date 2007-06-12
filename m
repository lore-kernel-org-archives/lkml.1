Return-Path: <linux-kernel-owner+w=401wt.eu-S1753882AbXFLJzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbXFLJzt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 05:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751791AbXFLJzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 05:55:41 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:49366 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751751AbXFLJzl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 05:55:41 -0400
Message-Id: <466E89EB.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Tue, 12 Jun 2007 11:56:27 +0200
From: "Jan Beulich" <jbeulich@novell.com>
To: "Satyam Sharma" <satyam.sharma@gmail.com>
Cc: "Sam Ravnborg" <sam@ravnborg.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix improper .init-type section references
References: <466E66AE.76E4.0078.0@novell.com>
 <a781481a0706120242o5bcabee1ke67c96d5a7dd6cb0@mail.gmail.com>
In-Reply-To: <a781481a0706120242o5bcabee1ke67c96d5a7dd6cb0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> -static __init void kthreadd_setup(void)
>> +static noinline __init_refok void kthreadd_setup(void)
>>  {
>>         struct task_struct *tsk = current;
>
>This isn't ok. There isn't any __init function that is (safely) referenced
>by kthreadd_setup(), so we shouldn't really be marking it as such.
>Also, kthreadd_setup() is really only ever called at init time, so we'd
>want it to remain __init.

Oh, I see, I misunderstood the purpose of the tag - I assumed it would
mark an __init function that is known to only be referenced from init-only
code paths inside non-init functions (i.e. I didn't pay attention that the
resulting section's name is .text.init.refok, not .init.text.refok).

I have to admit I have some difficulty understanding when the tags
are going to be useful the way they are implemented right now.

>I believe the correct fix to silence modpost here would be to mark its
>caller kthreadd() also as __init, because it too is used only at init time?

I don't think so - it is my understanding that this is the body of a thread
that never dies.

Jan

