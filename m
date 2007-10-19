Return-Path: <linux-kernel-owner+w=401wt.eu-S936202AbXJSSgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936202AbXJSSgU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 14:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760806AbXJSSgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 14:36:11 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:39997 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753761AbXJSSgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 14:36:10 -0400
Message-ID: <4718F918.8050904@garzik.org>
Date: Fri, 19 Oct 2007 14:36:08 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/9] irq-remove: driver non-trivial
References: <20071019075443.GA6407@havoc.gtf.org>	<20071019075640.GE6407@havoc.gtf.org> <m1hcknge5y.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1hcknge5y.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> [snip] Found issues and ran out of review bandwidth.

thanks for the comments!  I'll work through these.

There are definitely plenty of open issues I haven't yet tackled in the 
driver area, as you are seeing.  As you noted, a lot of these are with 
drivers doing weird things like calling their own interrupt function 
with (-1, NULL) or (0, NULL), which triggers some magic "I'm polling" 
behavior.


>>  	}
>>  __out:
>>  	spin_unlock(&mts->lock);
>> +
>> +	return IRQ_HANDLED;
> 
> Missing parport code change, see below.

those two parport changes were bogus, and actually got fixed up in patch #9

