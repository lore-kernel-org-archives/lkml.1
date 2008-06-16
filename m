Return-Path: <linux-kernel-owner+w=401wt.eu-S1756601AbYFPQpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601AbYFPQpe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 12:45:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754458AbYFPQp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 12:45:26 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:43808 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754449AbYFPQpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 12:45:25 -0400
Message-ID: <48569895.7020701@nortel.com>
Date: Mon, 16 Jun 2008 10:45:09 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: linux-kernel@vger.kernel.org, vatsa@linux.vnet.ibm.com,
       a.p.zijlstra@chello.nl
Subject: Re: odd timing bug with cgroups?
References: <4852E8D5.3000503@nortel.com> <47364.1213416931@turing-police.cc.vt.edu>
In-Reply-To: <47364.1213416931@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jun 2008 16:45:15.0717 (UTC) FILETIME=[5A6B0750:01C8CFD0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> On Fri, 13 Jun 2008 15:38:29 MDT, Chris Friesen said:

>>This seems odd...I would think that as soon as the fork() call returns 
>>in the parent we should be able to put that task into a group.

> I'm admittedly shooting in the dark here, but remember that a successful
> fork() call returns *twice*.  Just because the *parent* has returned
> doesn't mean that the *child* has finished all the processing and returned
> as well - it may be delayed by other kernel threads etc and still not quite
> ready for tweaking.

I was thinking something like this as well, like maybe we can't move the 
child to another group until it gets scheduled in once, or something 
similar.

If that is the case, I think it's a bug--on return from fork() the 
child's pid is visible (because the parent knows it) and so it should be 
valid to use for any operation that takes a pid.

Chris
