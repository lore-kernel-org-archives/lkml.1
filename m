Return-Path: <linux-kernel-owner+w=401wt.eu-S965382AbYCSVDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965382AbYCSVDi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:03:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760642AbYCSTyB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:54:01 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:41946 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754402AbYCSTx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:53:59 -0400
X-IronPort-AV: E=Sophos;i="4.25,519,1199692800"; 
   d="scan'208";a="17846670"
To: Hoang-Nam Nguyen <HNGUYEN@de.ibm.com>
Cc: Christoph Raisch <raisch@de.ibm.com>, general@lists.openfabrics.org,
       Hal Rosenstock <hal.rosenstock@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [PATCH 1/3] Infiniband: make ehca_pd use struct pid pointer rather than pid_t
X-Message-Flag: Warning: May contain useful information
References: <OF4F7C6111.9AA26F4F-ONC1257410.00599780-C1257410.005E3475@de.ibm.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 18 Mar 2008 11:27:00 -0700
In-Reply-To: <OF4F7C6111.9AA26F4F-ONC1257410.00599780-C1257410.005E3475@de.ibm.com> (Hoang-Nam Nguyen's message of "Tue, 18 Mar 2008 18:09:22 +0100")
Message-ID: <adazlsvopl7.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 18 Mar 2008 18:27:01.0018 (UTC) FILETIME=[A84887A0:01C88925]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Right, above checking is based on a very simple policy "creator of a
 > resource is also the owner in term of releasing it" and will not cover
 > other customized patterns. We had a case - believe on sles9, in which
 > a child process manipulated/released resources from parent one, and
 > it was not easy to find the bug.

Hmm, I can see how that might be ugly.  On the other hand it doesn't
seem like the unix way for a process not to be able to do something
with a file if it has a valid fd.

 > Wrt/ your actual question: we can remove the tgid stuff from ehca kernel
 > code. When do you expect me to send a patch at latest?

I don't think it's super-urgent.  If you can't do it, say, by the end
of this week, then I'll apply Pavel's patch so we don't block his
progress on namespace stuff.  But I would still like to get a patch to
move this out of ehca at some point, so please don't drop it.

If you guys think there is value in having the checks, then please
send a patch to add the ownership stuff to the uverbs core and we can
argue about it then.

Thanks,
  Roland

