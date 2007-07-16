Return-Path: <linux-kernel-owner+w=401wt.eu-S1760404AbXGPUfG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760404AbXGPUfG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 16:35:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754430AbXGPUey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 16:34:54 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:60026 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbXGPUex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 16:34:53 -0400
In-Reply-To: <adalkdgz65x.fsf@cisco.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Christoph Raisch <raisch@de.ibm.com>,
       "OF-General" <general@lists.openfabrics.org>,
       Hoang-Nam Nguyen <hnguyen@de.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       Roland Dreier <rolandd@cisco.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
MIME-Version: 1.0
Subject: Re: [PATCH 01/10] IB/ehca: Support for multiple event queues
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
From: Joachim Fenkes <FENKES@de.ibm.com>
Message-ID: <OF82B8C559.721FE4D8-ONC125731A.00700205-C125731A.00711653@de.ibm.com>
Date: Mon, 16 Jul 2007 22:34:19 +0200
X-MIMETrack: Serialize by Router on D12ML064/12/M/IBM(Release 7.0.2HF71 | November 3, 2006) at
 16/07/2007 22:34:27,
	Serialize complete at 16/07/2007 22:34:27
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier <rdreier@cisco.com> wrote on 16.07.2007 18:04:26:

> It seems not quite right to me for the driver to advertise nr_eqs
> completion vectors, but then if round-robin is turned on to ignore the
> consumer's decision about which vector to use.

The round-robin feature was primarily meant as a debug/evaluation feature; 
it is not supposed to be active by default. ULP programmers can, for 
example, quickly evaluate the performance increase that comp_vectors could 
give them, without changing their code. Without this debug option, the 
comp_vector policy is still up to the ULPs.
 
> Maybe if round-robin is turned on you should report 0 as the number of
> completion vectors?

That sounds like a reasonable idea -- I'll change that right away.

> Maybe the whole interface is broken and we should only be exposing
> policies to consumers instead of the specific vector?

If so, I think the policies should be handled by the IB core code instead 
of being re-invented by each driver. The IB core would then again pass 
actual comp_vector values to the driver.
 
> I think I would rather hold off on multiple EQs for this merge window
> and plan on having something really solid and thought-out for 2.6.24.

It's your call, but the code is there and I don't expect it to change a 
lot later, so it could be used by others to get a first impression of 
what's possible using comp_vectors and to gather some experience with 
them.

Regards,
  Joachim
