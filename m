Return-Path: <linux-kernel-owner+w=401wt.eu-S1752683AbXIQGYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683AbXIQGYm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 02:24:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751730AbXIQGYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 02:24:35 -0400
Received: from sacred.ru ([62.205.161.221]:32951 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751606AbXIQGYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 02:24:34 -0400
Message-ID: <46EE1D01.3000208@openvz.org>
Date: Mon, 17 Sep 2007 10:21:53 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Serge E. Hallyn" <serue@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org, Alexey Dobriyan <adobriyan@openvz.org>
Subject: Re: [PATCH 2/2] Fix user namespace exiting OOPs
References: <46EA88BA.5020005@openvz.org>	<20070914182355.GA9810@sergelap.austin.ibm.com> <20070914193233.77138604.akpm@linux-foundation.org>
In-Reply-To: <20070914193233.77138604.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Mon, 17 Sep 2007 10:24:14 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 14 Sep 2007 13:23:55 -0500 "Serge E. Hallyn" <serue@us.ibm.com> wrote:
> 
>>> run on kernel with CONFIG_USER_NS turned on will oops the
>>> kernel immediately.
>>>
>>> This was spotted during OpenVZ kernel testing.
>>>
>>> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
>>> Signed-off-by: Alexey Dobriyan <adobriyan@openvz.org>
>> Good spot.  Interesting solution :)
>>
> 
> Do we want to fix this in 2.6.23?

This is not a security issue at all. This BUG can be triggered only
by CAP_SYS_ADMIN capable task on the kernel with CONFIG_USER_NS=y,
which is an EXPERIMENTAL depending option.

> If so then at present I'll need to merge 
> 
> kernel-userc-use-list_for_each_entry-instead-of-list_for_each.patch
> convert-uid-hash-to-hlist.patch
> fix-user-namespace-exiting-oops.patch
> 
> which is rather a lot of merging at this stage - surely more than
> is really needed?
> 

Thanks,
Pavel
