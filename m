Return-Path: <linux-kernel-owner+w=401wt.eu-S1761320AbZCRWAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761320AbZCRWAU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 18:00:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761214AbZCRV6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 17:58:36 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54732 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761188AbZCRV6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 17:58:34 -0400
Date: Wed, 18 Mar 2009 22:59:01 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Vernon Mauery <vernux@us.ibm.com>
Cc: Eilon Greenstein <eilong@broadcom.com>, Andi Kleen <andi@firstfloor.org>,
       netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: High contention on the sk_buff_head.lock
Message-ID: <20090318215901.GV11935@one.firstfloor.org>
References: <49C12E64.1000301@us.ibm.com> <87prge1rhu.fsf@basil.nowhere.org> <49C16294.8050101@us.ibm.com> <1237412732.29116.2.camel@lb-tlvb-eliezer> <49C16CD4.3010708@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C16CD4.3010708@us.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Thanks.  I will test to see how this affects this lock contention the
> next time the broadcom hardware is available.

The other strategy to reduce lock contention here is to use TSO/GSO/USO.
With that the lock has to be taken less often because there are less packets
travelling down the stack. I'm not sure how well that works with netperf style 
workloads though. Using multiple TX queues is probably better though if you have
capable hardware. Or ideally both.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
