Return-Path: <linux-kernel-owner+w=401wt.eu-S1752455AbZJWP6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455AbZJWP6f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 11:58:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752391AbZJWP6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 11:58:35 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:12595 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299AbZJWP6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 11:58:34 -0400
Message-ID: <4AE1D2AA.8060200@hp.com>
Date: Fri, 23 Oct 2009 11:58:34 -0400
From: Vlad Yasevich <vladislav.yasevich@hp.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Amerigo Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [Patch] sctp: remove deprecated SCTP_GET_*_OLD stuffs
References: <20091015082849.4605.48311.sendpatchset@localhost.localdomain> <4AE0C64A.9080400@hp.com> <20091022214439.GA2635@merkur.ravnborg.org>
In-Reply-To: <20091022214439.GA2635@merkur.ravnborg.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Sam Ravnborg wrote:
> On Thu, Oct 22, 2009 at 04:53:30PM -0400, Vlad Yasevich wrote:
>>> diff --git a/include/net/sctp/user.h b/include/net/sctp/user.h
>>> index be2334a..0991f1b 100644
>>> --- a/include/net/sctp/user.h
>>> +++ b/include/net/sctp/user.h
>>> @@ -131,14 +131,6 @@ enum sctp_optname {
>>>  #define SCTP_SOCKOPT_BINDX_REM	SCTP_SOCKOPT_BINDX_REM
>>>  	SCTP_SOCKOPT_PEELOFF, 	/* peel off association. */
>>>  #define SCTP_SOCKOPT_PEELOFF	SCTP_SOCKOPT_PEELOFF
>>> -	SCTP_GET_PEER_ADDRS_NUM_OLD, 	/* Get number of peer addresss. */
>>> -#define SCTP_GET_PEER_ADDRS_NUM_OLD	SCTP_GET_PEER_ADDRS_NUM_OLD
>>> -	SCTP_GET_PEER_ADDRS_OLD, 	/* Get all peer addresss. */
>>> -#define SCTP_GET_PEER_ADDRS_OLD	SCTP_GET_PEER_ADDRS_OLD
>>> -	SCTP_GET_LOCAL_ADDRS_NUM_OLD, 	/* Get number of local addresss. */
>>> -#define SCTP_GET_LOCAL_ADDRS_NUM_OLD	SCTP_GET_LOCAL_ADDRS_NUM_OLD
>>> -	SCTP_GET_LOCAL_ADDRS_OLD, 	/* Get all local addresss. */
>>> -#define SCTP_GET_LOCAL_ADDRS_OLD	SCTP_GET_LOCAL_ADDRS_OLD
>>>  	SCTP_SOCKOPT_CONNECTX_OLD, /* CONNECTX old requests. */
>> After running the regression suite against this patch I find that we can't
>> remove the enum values.  Removing the enums changes the value for the remainder
>> of the definitions and breaks binary compatibility for applications that use
>> those trailing options.
>>
>> You should be ok with removing the #defines and actual code that uses them,
>> but not the enums.  You can even rename the enums, but we must preserve
>> numeric ordering.
> 
> If we really depend on the actual value of an enum as in this case,
> then e should assign them direct to better document this.
> 
> 	Sam
> 

I agree.  I have a patch that converts the enum to just a #define section that
I'll apply on top of this removal patch and document the deletion.

-vlad
