Return-Path: <linux-kernel-owner+w=401wt.eu-S1762753AbYCSUyD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762753AbYCSUyD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:54:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759233AbYCSTs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:48:28 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:12936 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759225AbYCSTs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:48:27 -0400
In-Reply-To: <adaprtsf1ww.fsf@cisco.com>
Subject: Re: [PATCH 1/3] Infiniband: make ehca_pd use struct pid pointer rather than
 pid_t
To: Roland Dreier <rdreier@cisco.com>
Cc: Christoph Raisch <raisch@de.ibm.com>, general@lists.openfabrics.org,
       Hal Rosenstock <hal.rosenstock@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>,
       Pavel Emelyanov <xemul@openvz.org>
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
Message-ID: <OF4F7C6111.9AA26F4F-ONC1257410.00599780-C1257410.005E3475@de.ibm.com>
From: Hoang-Nam Nguyen <HNGUYEN@de.ibm.com>
Date: Tue, 18 Mar 2008 18:09:22 +0100
X-MIMETrack: Serialize by Router on D12ML065/12/M/IBM(Release 7.0.2FP2HF322 | September
 26, 2007) at 18/03/2008 18:09:23
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  > Reason for above checking is to prevent a child process releasing
>  > a resource that the parent process has created and still wants to use.
>  > Do you think that's something we can generalize into ib_core?
> Clearly if we want that check then it should be in the core uverbs
> module.  But I'm not sure why we would want that check -- I don't see
> any realistic scenario where that would cause problems, and it seems
> at least as likely that the check would break an app that
> intentionally does something clever.
Right, above checking is based on a very simple policy "creator of a
resource is also the owner in term of releasing it" and will not cover
other customized patterns. We had a case - believe on sles9, in which
a child process manipulated/released resources from parent one, and
it was not easy to find the bug.
Wrt/ your actual question: we can remove the tgid stuff from ehca kernel
code. When do you expect me to send a patch at latest?

Nam

