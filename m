Return-Path: <linux-kernel-owner+w=401wt.eu-S1753413AbZLHKHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbZLHKHz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 05:07:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbZLHKHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 05:07:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37956 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753130AbZLHKHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 05:07:54 -0500
Message-ID: <4B1E2626.9010005@redhat.com>
Date: Tue, 08 Dec 2009 18:10:46 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: Alan Cox <alan@linux.intel.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Greg Kroah-Hartman <gregkh@suse.de>, Joe Peterson <joe@skyrush.com>
Subject: Re: [Patch] tty: move a definition out of switch block
References: <20091201075744.4456.48125.sendpatchset@localhost.localdomain>	<20091201154412.4002a0d8@linux.intel.com>	<4B177878.2090002@redhat.com> <20091203111329.3558ea39@linux.intel.com>
In-Reply-To: <20091203111329.3558ea39@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> jumps to its first label at a first glance. I know in this case
>> the code is _not_ wrong, but again, it's not good for reading.
> 
> So this is just your personal preference ? That seems like pointless
> churn, especially given that many other people consider putting the
> variables there is better than
> 
> 	case foo:
> 	{
> 		Blah blah
> 	}
> 	}
> }
> 
> in switches

Well, in C99 6.5.4, it has a very good example to explain this.
See this example:

switch (xxx) {
	int a = 1; //<-- not initialized
	int b; //<-- seems to be skipped, but not
	func(&a); //<-- skipped;
case 1:
	//...
	break;
case 2:
	return a; //<-- uninitialized value;
}


So why not just:

int a = 1, b;
switch (xxx) {
case 1:
	// blah blah
}

? A first galance will know everything, no need to guess if
'switch' skips it or not.

