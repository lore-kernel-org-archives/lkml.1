Return-Path: <linux-kernel-owner+w=401wt.eu-S1755502AbYKZNrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502AbYKZNrs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 08:47:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754820AbYKZNpC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 08:45:02 -0500
Received: from mtagate1.de.ibm.com ([195.212.17.161]:52157 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754807AbYKZNpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 08:45:00 -0500
In-Reply-To: <aday6z7csb4.fsf@cisco.com>
References: <200806061835.43802.fenkes@de.ibm.com>	<48499C11.7030504@gmail.com> <200811251358.06729.fenkes@de.ibm.com> <aday6z7csb4.fsf@cisco.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Alexander Schmidt1 <ALEXSCHM@de.ibm.com>,
       Christoph Raisch <RAISCH@de.ibm.com>,
       OF-EWG <ewg@lists.openfabrics.org>,
       OF-General <general@lists.openfabrics.org>,
       Hoang-Nam Nguyen <HNGUYEN@de.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       LinuxPPC-Dev <linuxppc-dev@ozlabs.org>,
       Roland Dreier <rolandd@cisco.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
MIME-Version: 1.0
Subject: Re: [PATCH] IB/ehca: Change misleading error message
X-KeepSent: DC616681:53A831E8-C125750D:0046F124;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Release 8.0.1 HF105 April 10, 2008
From: Joachim Fenkes <FENKES@de.ibm.com>
Message-ID: <OFDC616681.53A831E8-ONC125750D.0046F124-C125750D.004B8673@de.ibm.com>
Date: Wed, 26 Nov 2008 14:44:56 +0100
X-MIMETrack: Serialize by Router on D12ML064/12/M/IBM(Release 8.0.1|February 07, 2008) at
 26/11/2008 14:44:57,
	Serialize complete at 26/11/2008 14:44:57
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier <rdreier@cisco.com> wrote on 26.11.2008 00:13:51:

> That's too bad... I applied this patch but out of curiousity, why
> doesn't the hot-remove/hot-add work?  I would have thought that
> re-registering all of memory after the hot-add would do the right thing.

That's right, but right now, we simply try to register all of memory from 
KERNELBASE to high_memory, which works right until we have memory holes in 
the middle; then the hypervisor will reject our page registrations. Same 
goes for huge (16GB) pages, by the way. We're working on a solution to 
this.

Cheers,
  Joachim
