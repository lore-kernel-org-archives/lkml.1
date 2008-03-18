Return-Path: <linux-kernel-owner+w=401wt.eu-S1752751AbYCSTaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751AbYCSTaj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 15:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753712AbYCST0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:26:20 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:56441 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681AbYCST0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:26:17 -0400
In-Reply-To: <adatzj5f4sx.fsf@cisco.com>
Subject: Re: [PATCH 1/3] Infiniband: make ehca_pd use struct pid pointer rather than
 pid_t
To: Roland Dreier <rdreier@cisco.com>
Cc: Christoph Raisch <raisch@de.ibm.com>, general@lists.openfabrics.org,
       Hal Rosenstock <hal.rosenstock@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>,
       Pavel Emelyanov <xemul@openvz.org>
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
Message-ID: <OFCEB1A067.C70D2E66-ONC1257410.0055A0B0-C1257410.005729C4@de.ibm.com>
From: Hoang-Nam Nguyen <HNGUYEN@de.ibm.com>
Date: Tue, 18 Mar 2008 16:52:27 +0100
X-MIMETrack: Serialize by Router on D12ML065/12/M/IBM(Release 7.0.2FP2HF322 | September
 26, 2007) at 18/03/2008 16:52:28
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roland!
>  > The task_struct->tgid field is about to become deprecated, due to
>  > pid namespaces make tasks have many pids, not one. The infiniband
>  > driver is one of the code, that still uses it in some places.
>
> Looks fine in terms of the changes it makes, but actually it seems
> that the ehca use of this is completely bogus and the ownership
> checking should be removed.
>
> The core ib_uverbs module has checks that make sure that objects can
> only be accessed through the file that they were created through; of
> course there are tricky ways a file can be passed from one process to
> another, but I don't think we want to disallow userspace processes
> from trying to do interesting stuff as long as it doesn't hurt anything.
>
> In other words-- ehca shouldn't be looking at tgids or anything like
> that at all.  If there are missing checks then they should be in the
> core userspace verbs stuff; but I think what we have is actually OK.
>
> ehca guys, what do you think?
Reason for above checking is to prevent a child process releasing
a resource that the parent process has created and still wants to use.
Do you think that's something we can generalize into ib_core?
Regards
Nam

