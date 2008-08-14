Return-Path: <linux-kernel-owner+w=401wt.eu-S1758397AbYHNPSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758397AbYHNPSj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 11:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754824AbYHNPSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 11:18:31 -0400
Received: from brmea-mail-4.Sun.COM ([192.18.98.36]:42568 "EHLO
	brmea-mail-4.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047AbYHNPSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 11:18:30 -0400
Date: Thu, 14 Aug 2008 07:18:13 -0400
From: David Collier-Brown <davecb@sun.com>
Subject: Re: RFC: I/O bandwidth controller
In-reply-to: <48A18854.9020000@gmail.com>
To: righi.andrea@gmail.com
Cc: Hirokazu Takahashi <taka@valinux.co.jp>, baramsori72@gmail.com,
       balbir@linux.vnet.ibm.com, xen-devel@lists.xensource.com,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, dm-devel@redhat.com,
       agk@sourceware.org, dave@linux.vnet.ibm.com, ngupta@google.com
Reply-to: davecb@sun.com
Message-id: <48A41475.4070108@sun.com>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=us-ascii
Content-transfer-encoding: 7BIT
X-Accept-Language: en-us, en
References: <1218117578.11703.81.camel@sebastian.kern.oss.ntt.co.jp>
 <48A0A689.40908@gmail.com> <loom.20080812T071504-212@post.gmane.org>
 <20080812.201025.57762305.taka@valinux.co.jp> <48A18854.9020000@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; SunOS sun4u; en-US; rv:1.7) Gecko/20041221
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Righi wrote:
> A more complicated issue is how to evaluate the total IO bandwidth of a
> generic device. We can use some kind of averaging/prediction, but
> basically it would be inaccurate due to the mechanic of disks (head
> seeks, but also caching, buffering mechanisms implemented directly into
> the device, etc.). It's a hard problem. And the same problem exists also
> for proportional bandwidth as well, in terms of IO rate predictability I
> mean.

  Actually it's a little-known easy problem.

  The capacity planning community does it all the time, but then describes
it in terms that are only interesting (intelligible?) to an enthusiastic
amateur mathematician (;-))

  One finds the point, called N*, at which the throughput flattens
out and and the response time starts to grow without bounds, and
calls that level the maximum.

  In practice, one does an easier variant.  One sets a response-time 
limit and throttles *everyone* proportionally when th disk starts to 
regularly degrade beyond the limit.  Interestingly, because we're 
slowing the application to prevent slowing the disks, the value we 
pick needn't be terribly precise.  It also doesn't require any pre-
knowledge about the disks.

  Send me a note if you want to discuss this in more detail.

--dave
-- 
David Collier-Brown            | Always do right. This will gratify
Sun Microsystems, Toronto      | some people and astonish the rest
davecb@sun.com                 |                      -- Mark Twain
cell: (647) 833-9377, bridge: (877) 385-4099 code: 506 9191#
