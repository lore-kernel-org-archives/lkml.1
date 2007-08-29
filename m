Return-Path: <linux-kernel-owner+w=401wt.eu-S1756337AbXH2Clo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756337AbXH2Clo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 22:41:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753934AbXH2Cle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 22:41:34 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:32178 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753549AbXH2Cle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 22:41:34 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=sdRNwmWUo+qMaXQkrW+1yExPV8oNGa5KA9PI3tGNbKXO5zzf3o2PbgrEOQb2+jPyZVVhB/0OBLI+0MnA89n2irYTkhMwCAY0QUvHnPzKX9QR8uYFh27wQg1NLLQ5Pxe5VqJy0L93ErDYROq1PGNlCYBdeixXe4KOoSyegiE86iU=  ;
X-YMail-OSG: xXg6PegVM1mOJ2Pd..wY6Q7GrnNHrlPs7xibvAS5ADxCXz1ONem23vl9gAiDslKjlGK.Sy80Cg--
Message-ID: <46D4DCD5.4030601@yahoo.com.au>
Date: Wed, 29 Aug 2007 12:41:25 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: "Huang, Ying" <ying.huang@intel.com>
CC: "Hu, Fenghua" <fenghua.hu@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Machek <pavel@ucw.cz>, nigel@nigel.suspend2.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Alan Stern <stern@rowland.harvard.edu>,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] [RFC][PATCH 0/2 -mm] kexec based hibernation
References: <9D7649D18729DE4BB2BD7B494F7FEDC257EA60@pdsmsx415.ccr.corp.intel.com> <1188180997.3247.68.camel@caritas-dev.intel.com>
In-Reply-To: <1188180997.3247.68.camel@caritas-dev.intel.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Huang, Ying wrote:
> On Mon, 2007-08-27 at 09:28 +0800, Hu, Fenghua wrote:
> 
>>One quick question is, can it improve hiberation/wakeup time?
> 
> 
> In general, for kexec based hibernation, what increases
> hibernation/wakeup time:
> 
> - One extra Linux boot is needed to hibernate and wakeup.
> 
> 
> What decreases hibernation/wakeup time:
> 
> - Most hibernation/wakeup work is done in full functional user space
> program, so it is possible to do some optimization, such as parallel
> compression.

- It does not have to reclaim pagecache before suspend?

- It does not have to restore working set afterwards?

(You could do this to reduce image size, of course, but it can
be optional which is nice).


> So, I think the kexec based hibernation may be slower than original
> implementation in general. In this prototype implementation, the
> hibernation/wakeup time is much longer than original hibernation/wakeup
> implementation. But it has much to be optimized and I think it can
> approach the speed of the original implementation after optimization.

Also, don't just look at the time to do a simple suspend/resume cycle,
but the full cost of going from working state to working state (eg.
grep a kernel tree or two!).

Although the kexec details are out of my league, I really like
everything about the concept :) Nice work.

-- 
SUSE Labs, Novell Inc.
