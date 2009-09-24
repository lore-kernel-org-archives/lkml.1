Return-Path: <linux-kernel-owner+w=401wt.eu-S1752836AbZIXPOD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836AbZIXPOD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 11:14:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752679AbZIXPOC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 11:14:02 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:33167 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbZIXPOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 11:14:01 -0400
Message-ID: <4ABB8CB5.9080402@in.ibm.com>
Date: Thu, 24 Sep 2009 20:43:57 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Frederik Deweerdt <frederik.deweerdt@xprog.eu>, greg@kroah.org,
       Lars Ericsson <Lars_Ericsson@telia.com>, David.Woodhouse@intel.com,
       linux-kernel@vger.kernel.org, "'Ivo van Doorn'" <ivdoorn@gmail.com>
Subject: Re: [patch -stable] firware_class oops: fix firmware_loading_store
 locking
References: <20090916205717.GB12117@gambetta> <8A019019C4474E589B9EC14F451C0579@gotws1589> <20090921133223.GA13038@gambetta> <alpine.LFD.2.01.0909230936320.3303@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0909230936320.3303@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> I don't think this is correct.
>
> I think you should protect the FW_STATUS_LOADING bit too, shouldn't you?
>
> As it is, it does this:
>
> 	if (test_bit(FW_STATUS_LOADING, &fw_priv->status)) {
> 		mutex_lock(&fw_lock);
> 		...
> 		clear_bit(FW_STATUS_LOADING, &fw_priv->status);
> 		mutex_unlock(&fw_lock);
> 		break;
> 	}
>
> and if this code can race (which it obviously can, since your addition of 
> fw_lock mutex matters), then I think it can race on that FW_STATUS_LOADING 
> bit too. No?
>
> So my gut feel is that the whole damn function should be protected by the 
> mutex_lock thing. IOW, the patch would be something like the appended.
>
> UNTESTED. Somebody needs to test this, verify, and send it back to me.
>   
I did a quick boot test with this patch and didn't find any issues.

But that said i haven't been able to recreate the problem reported by Lars,
so not sure how relevant would be the test results from me.

Thanks
-Sachin


-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

