Return-Path: <linux-kernel-owner+w=401wt.eu-S1756105AbXJCNlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105AbXJCNlS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 09:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754227AbXJCNlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 09:41:08 -0400
Received: from mail2.asahi-net.or.jp ([202.224.39.198]:43329 "EHLO
	mail.asahi-net.or.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753232AbXJCNlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 09:41:06 -0400
X-Greylist: delayed 1687 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Oct 2007 09:41:06 EDT
Message-ID: <470395B3.2020904@kaigai.gr.jp>
Date: Wed, 03 Oct 2007 22:14:27 +0900
From: KaiGai Kohei <kaigai@kaigai.gr.jp>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
CC: jmorris@namei.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, chrisw@sous-sol.org
Subject: Re: [TOMOYO 05/15](repost) Domain transition handler functions.
References: <200710022144.BFF09817.VFFOOJLSFHtQMO@I-love.SAKURA.ne.jp>	<Xine.LNX.4.64.0710020557170.21841@us.intercode.com.au>	<200710032024.DJF78662.FHOLtMSFOOFJVQ@I-love.SAKURA.ne.jp>	<20071003.204356.05853536.yoshfuji@linux-ipv6.org>	<Xine.LNX.4.64.0710030529580.6431@us.intercode.com.au> <200710032204.DFF51552.OFOSOFMVQtHLJF@I-love.SAKURA.ne.jp>
In-Reply-To: <200710032204.DFF51552.OFOSOFMVQtHLJF@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa wrote:
> James Morris wrote:
>> I'm pretty sure that the singly linked list idea has been rejected a few 
>> times.  Just use the existing API.
> Too bad...
> 
> Well, is there a way to avoid read_lock when reading list?
> 
> Currently, TOMOYO Linux avoids read_lock, on the assumption that
> (1) First, ptr->next is initialized with NULL.
> (2) Later, ptr->next is assigned non-NULL address.
> (3) Assigning to ptr->next is done atomically.
> 
> Regards.

Is it all of the purpose for the list structure?
If so, you can apply RCU instead to avoid read lock
when scanning the list, like:

rcu_read_lock();
list_for_each_entry(...) {
     ....
}
rcu_read_unlock();

-- 
KaiGai Kohei <kaigai@kaigai.gr.jp>
