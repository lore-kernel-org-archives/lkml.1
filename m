Return-Path: <linux-kernel-owner+w=401wt.eu-S1753246AbZKLPSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246AbZKLPSY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 10:18:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753201AbZKLPSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 10:18:21 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52312 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753024AbZKLPSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 10:18:21 -0500
Date: Thu, 12 Nov 2009 07:17:47 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Tejun Heo <tj@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [GIT PULL] percpu fixes for 2.6.32-rc6
In-Reply-To: <4AFBEA4B.4070100@kernel.org>
Message-ID: <alpine.LFD.2.01.0911120714260.31845@localhost.localdomain>
References: <alpine.LFD.2.01.0911101042140.31845@localhost.localdomain> <4AF9BE3A.40409@kernel.org> <20091110193705.GA9011@elte.hu> <4AF9C402.9040800@kernel.org> <alpine.LFD.2.01.0911101338190.31845@localhost.localdomain> <4AFA35CB.5030801@kernel.org>
 <20091111113147.GB7487@elte.hu> <4AFAAC32.4020104@kernel.org> <20091111195751.GA13574@elte.hu> <4AFBDF43.3010703@kernel.org> <20091112103639.GB24684@elte.hu> <4AFBEA4B.4070100@kernel.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 12 Nov 2009, Tejun Heo wrote:
> 
> 11/12/2009 07:36 PM, Ingo Molnar wrote:
> > 
> > Breaking strings mid-sentence is something we try not to do. (If you 
> > know about places that do it 'quite often' then those places need fixing 
> > too.)
> 
> Oh... I do that all the time and I see a lot of them around too.

I hate them. I do greps for error messages, and it's annoying as hell if 
it's hard to find.

'checkpatch' is the major reason for them, but I think we've fixed 
checkpath long ago to not warn about long lines if they are due to a long 
string.

Strings should basically be broken up only at '\n' characters, so

	printk("This is a made-up example.\n"
		"Ok like this\n");

is fine, because you can expect to grep for "made-up example", but not 
over the newline.

				Linus
