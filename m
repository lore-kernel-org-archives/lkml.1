Return-Path: <linux-kernel-owner+w=401wt.eu-S1759302AbXIYClQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759302AbXIYClQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 22:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755139AbXIYClF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 22:41:05 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:54724 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754993AbXIYClE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 22:41:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=gDn5gs0TrZlth88PREb6wYegb4571g25gJbkCG3UkPggAqiapi9RmUY+0Hm3EAjSPk673511IQWHzDvoANiLgh+06BPKOMnHXPKzshBgecVvz8uy4/bRpQbWVkYpjqmJmf4b/uFp57fAQKRsPkUdJuPApuICVi9r3p8w6DKPTvQ=
Message-ID: <46F874DB.5070205@gmail.com>
Date: Tue, 25 Sep 2007 11:39:23 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Jonathan Corbet <corbet@lwn.net>, ebiederm@xmission.com,
       cornelia.huck@de.ibm.com, greg@kroah.com, stern@rowland.harvard.edu,
       kay.sievers@vrfy.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] module: implement module_inhibit_unload()
References: <25380.1190671205@lwn.net>  <46F845B2.7030002@gmail.com>	 <1190677332.27805.229.camel@localhost.localdomain>	 <46F86727.4050004@gmail.com> <1190686320.27805.258.camel@localhost.localdomain>
In-Reply-To: <1190686320.27805.258.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
>>> I really wonder if an explicit "kill_this_attribute()" is a better way
>>> to go than this...
>> I think this sort of temporary unload blocking would be useful for other
>> cases like this.
> 
> I hope not: this doesn't work in general.  Calling into a module after
> ->exit has called assumes that the exit function doesn't free up or
> overwrite stuff the other functions need.

Right, the sole purpose the unload inhibition is to hold onto the 'code'
section from going away.  The rest of object lifetime management should
be implemented using separate mechanisms anyway.  I was talking about
similar cases where the 'code' should be protected for a short time.

Thanks.

-- 
tejun
