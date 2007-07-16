Return-Path: <linux-kernel-owner+w=401wt.eu-S1755836AbXGPUiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836AbXGPUiO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 16:38:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751996AbXGPUh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 16:37:59 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:9445 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754213AbXGPUh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 16:37:58 -0400
In-Reply-To: <adalkdgz65x.fsf@cisco.com>
Subject: Re: [PATCH 01/10] IB/ehca: Support for multiple event queues
To: Roland Dreier <rdreier@cisco.com>
Cc: Christoph Raisch <raisch@de.ibm.com>,
       "OF-General" <general@lists.openfabrics.org>,
       Joachim Fenkes <fenkes@de.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       Roland Dreier <rolandd@cisco.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
Message-ID: <OF2377E85C.B05BDE94-ONC125731A.006E64A7-C125731A.00714F9E@de.ibm.com>
From: Hoang-Nam Nguyen <HNGUYEN@de.ibm.com>
Date: Mon, 16 Jul 2007 22:37:44 +0200
X-MIMETrack: Serialize by Router on D12ML065/12/M/IBM(Release 7.0.2HF71 | November 3, 2006) at
 16/07/2007 22:37:49
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier <rdreier@cisco.com> wrote on 16.07.2007 18:04:26:
> Do you have any data on how well this round-robin assignment works?
> It seems not quite right to me for the driver to advertise nr_eqs
> completion vectors, but then if round-robin is turned on to ignore the
> consumer's decision about which vector to use.
No, I've no figures to provide here. The background of this dist_eqs
option is actually to allow us testing across all event queues
without to change the testcases resp consumers to use certain
event queue number. Thus, I should comment it as EXPERIMENTAL?
> Maybe if round-robin is turned on you should report 0 as the number of
> completion vectors?  Or maybe we should allow well-known values for
> the completion vector passed to ib_create_cq to allow consumers to
> specify a policy (like round robin) instead of a particular vector?
> Maybe the whole interface is broken and we should only be exposing
> policies to consumers instead of the specific vector?
Agree in that device driver should not overwrite consumer's policy
of event queue assigment. Since dist_eqs is disabled as default,
there's no issue, isn't it?
Regarding ib_verbs: perhaps we should provide create/destroy_eq()
and let upper level protocols or consumers dictate the assignment
to cq by passing an event queue pointer to create_cq()...
> I think I would rather hold off on multiple EQs for this merge window
> and plan on having something really solid and thought-out for 2.6.24.
Fair enough. However why don't let us gather experience with this
feature now? Should we remove dist_eqs option for more consistency?
Thanks
Nam

