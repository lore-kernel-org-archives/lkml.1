Return-Path: <linux-kernel-owner+w=401wt.eu-S1753323AbZLCI1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbZLCI1g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 03:27:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752364AbZLCI1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 03:27:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31065 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751590AbZLCI1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 03:27:34 -0500
Message-ID: <4B17772A.80605@redhat.com>
Date: Thu, 03 Dec 2009 16:30:34 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>, Amerigo Wang <amwang@redhat.com>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [Patch] net: fix an array index overflow
References: <20091201082901.4678.16688.sendpatchset@localhost.localdomain> <20091202132427.GE5224@bicker>
In-Reply-To: <20091202132427.GE5224@bicker>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Carpenter wrote:
> On Tue, Dec 01, 2009 at 03:26:02AM -0500, Amerigo Wang wrote:
>> Don't use the address of an out-of-boundary element.
>>
>> Maybe this is not harmful at runtime, but it is still
>> good to improve it.
>>
>> Signed-off-by: WANG Cong <amwang@redhat.com>
>> Cc: David S. Miller <davem@davemloft.net>
>>
> 
> It may be coincidence but my static checker smatch also complains 
> about the code you modified.
> 
> It's the wrong idea to fix code to please a checker.  You end up
> doing things like adding an extra "return -ENOTREACHED" to silence
> warnings.  Then the next person who writes a checker has to figure
> out how to seperate the unreachable code which was added to suppress
> gcc warnings from bits which are unreachable because of typos.
> 
> Really any code that a human can read, a static checker should also
> be able to read.  Computer programs are just state machines.  At 
> the function level they are quite small state machines.  It's all
> logic and math which computers are very good at.  So it should be 
> fairly easy to fix the checker.  ;)
> 

Well, in some cases smatch seems really wrong, but not in this
case I think, or at least, smatch is suggesting us to improve
this code.

Please check Eric's reply in this thread, his patch looks nice
for me.

Thanks.

