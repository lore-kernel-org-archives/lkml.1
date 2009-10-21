Return-Path: <linux-kernel-owner+w=401wt.eu-S1754267AbZJUU5G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267AbZJUU5G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 16:57:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753812AbZJUU5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 16:57:05 -0400
Received: from mga06.intel.com ([134.134.136.21]:26396 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753739AbZJUU5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 16:57:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,599,1249282800"; 
   d="scan'208";a="561952782"
Message-ID: <4ADF75A2.50202@linux.intel.com>
Date: Thu, 22 Oct 2009 05:57:06 +0900
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Corey Minyard <minyard@acm.org>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>,
       "discuss@LessWatts.org" <discuss@LessWatts.org>,
       "openipmi-developer@lists.sourceforge.net" 
	<openipmi-developer@lists.sourceforge.net>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [Discuss] [PATCH] ipmi: use round_jiffies on timers to reduce
 timer overhead/wakeups
References: <20091021102822.5b32b2dc.randy.dunlap@oracle.com> <20091021114210.4d7e1ea9@linux.intel.com>	<4ADF57D7.7010808@intel.com> <20091021130348.cd521b0c.randy.dunlap@oracle.com> <4ADF6D76.7070409@acm.org>
In-Reply-To: <4ADF6D76.7070409@acm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corey Minyard wrote:
> Certainly.  Yes, some (probably most) IPMI hardware does not use
> interrupts, and unfortunately, it's not just older machines.  The driver
> used to poll more slowly, but in many cases the performance was
> unacceptable.

... but now it burns quite a bit of power (I'd not be surprised if it is 10 Watts extra on a 70W server)

is there any way to poll slowly until there is active ipmi traffic, during which we can then poll a bit faster.
... and then go back to slow polling when there is an ipmi idle period ?
