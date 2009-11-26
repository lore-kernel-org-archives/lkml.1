Return-Path: <linux-kernel-owner+w=401wt.eu-S1758688AbZKZQjC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758688AbZKZQjC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 11:39:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758528AbZKZQjB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 11:39:01 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:56874 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475AbZKZQjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 11:39:00 -0500
To: Patrick McHardy <kaber@trash.net>
Cc: Arnd Bergmann <arnd@arndb.de>, David Miller <davem@davemloft.net>,
       virtualization@lists.linux-foundation.org,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Anna Fischer <anna.fischer@hp.com>, netdev@vger.kernel.org,
       bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Mark Smith <lk-netdev@lk-netdev.nosense.org>,
       Gerhard Stenzel <gerhard.stenzel@de.ibm.com>,
       Jens Osterkamp <jens@linux.vnet.ibm.com>,
       Patrick Mullaney <pmullaney@novell.com>,
       Stephen Hemminger <shemminger@vyatta.com>
References: <1259024166-28158-1-git-send-email-arnd@arndb.de>
	<m1aayb6bfg.fsf@fess.ebiederm.org> <4B0C2824.5010502@trash.net>
	<200911261621.28298.arnd@arndb.de> <4B0E9FD0.4040107@trash.net>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 26 Nov 2009 08:38:53 -0800
In-Reply-To: <4B0E9FD0.4040107@trash.net> (Patrick McHardy's message of "Thu\, 26 Nov 2009 16\:33\:36 +0100")
Message-ID: <m1r5rlz1eq.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Patrick McHardy <kaber@trash.net>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH 1/4] veth: move loopback logic to common location
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patrick McHardy <kaber@trash.net> writes:

> Arnd Bergmann wrote:
>> On Tuesday 24 November 2009, Patrick McHardy wrote:
>>> Eric W. Biederman wrote:
>>>> I don't quite follow what you intend with dev_queue_xmit when the macvlan
>>>> is in one namespace and the real physical device is in another.  Are
>>>> you mentioning that the packet classifier runs in the namespace where
>>>> the primary device lives with packets from a different namespace?
>>> Exactly. And I think we should make sure that the namespace of
>>> the macvlan device can't (deliberately or accidentally) cause
>>> misclassification.
>> 
>> This is independent of my series and a preexisting problem, right?
>
> Correct.
>
>> Which fields do you think need to be reset to maintain namespace
>> isolation for the outbound path in macvlan?
>
> In addition to those already handled, I'd say
>
> - priority: affects qdisc classification, may refer to classes of the
>   old namespace
> - ipvs_property: might cause packets to incorrectly skip netfilter hooks
> - nf_trace: might trigger packet tracing
> - nf_bridge: contains references to network devices in the old NS,
>   also indicates packet was bridged
> - iif: index is only valid in the originating namespace
> - tc_index: classification result, should only be set in the namespace
>   of the classifier
> - tc_verd: RTTL etc. should begin at zero again
> - probably secmark.

Wow.  I thought we were trying to reduce skbuff, where did all of those
fields come from?  Regarless that sounds like a good list to get stomped.

Eric

