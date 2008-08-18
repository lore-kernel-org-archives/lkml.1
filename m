Return-Path: <linux-kernel-owner+w=401wt.eu-S1756357AbYHRSey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756357AbYHRSey (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 14:34:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754111AbYHRSep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 14:34:45 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:35075 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754096AbYHRSeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 14:34:44 -0400
Message-ID: <48A9BF9C.80108@freescale.com>
Date: Mon, 18 Aug 2008 13:29:48 -0500
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Steven Rostedt <srostedt@redhat.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Eran Liberty <liberty@extricom.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: ftrace introduces instability into kernel 2.6.27(-rc2,-rc3)
References: <48591941.4070408@extricom.com> <48A92E15.2080709@extricom.com> <48A9901B.1080900@redhat.com> <20080818154746.GA26835@Krystal> <48A9AFA7.8080508@freescale.com> <alpine.DEB.1.10.0808181425090.796@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.1.10.0808181425090.796@gandalf.stny.rr.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
>> Should use a "b" constraint for %2, or you could get r0. 
> 
> I will make an updated patch.
> 
>> Or, use an "m"
>> constraint with %U2%X2 after the lwz/stw. 
> 
> The 'b' seems easier ;-)

The advantage of the latter is that it allows GCC to choose indexed or 
update instructions -- but that's merely an optimization.  Switching to 
"b" is enough to avoid the potential bug.

>> %1 also needs to be an early clobber.
> 
> Not exactly sure what you mean by the above.

%1 is written to before some inputs are consumed, so you need to use 
"=&r" rather than "=r" so that GCC won't use the same register for both.

-Scott
