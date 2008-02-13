Return-Path: <linux-kernel-owner+w=401wt.eu-S932560AbYBMQNE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932560AbYBMQNE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 11:13:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755320AbYBMQMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 11:12:53 -0500
Received: from mtagate1.de.ibm.com ([195.212.29.150]:50618 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754735AbYBMQMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 11:12:52 -0500
In-Reply-To: <adazlu5vlub.fsf@cisco.com>
References: <Pine.LNX.4.64.0802081540180.4291@schroedinger.engr.sgi.com>	<20080208155641.2258ad2c.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0802081603430.4543@schroedinger.engr.sgi.com>	<adaprv70yyt.fsf@cisco.com>
	<Pine.LNX.4.64.0802081614030.5115@schroedinger.engr.sgi.com>	<adalk5v0yi6.fsf@cisco.com>
	<Pine.LNX.4.64.0802081634070.5298@schroedinger.engr.sgi.com>	<20080209012446.GB7051@v2.random>
	<Pine.LNX.4.64.0802081725200.5445@schroedinger.engr.sgi.com>	<20080209015659.GC7051@v2.random>
	<Pine.LNX.4.64.0802081813300.5602@schroedinger.engr.sgi.com>	<20080209075556.63062452@bree.surriel.com>
	<Pine.LNX.4.64.0802091345490.12965@schroedinger.engr.sgi.com>	<ada3arzxgkz.fsf_-_@cisco.com>
	<47B2174E.5000708@opengridcomputing.com>	<Pine.LNX.4.64.0802121408150.9591@schroedinger
 <adazlu5vlub.fsf@cisco.com>
Subject: Re: [ofa-general] Re: Demand paging for memory regions
To: Roland Dreier <rdreier@cisco.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <andrea@qumranet.com>, avi@qumranet.com,
       a.p.zijlstra@chello.nl, Christoph Lameter <clameter@sgi.com>,
       daniel.blueman@quadrics.com, general@lists.openfabrics.org,
       general-bounces@lists.openfabrics.org, Robin Holt <holt@sgi.com>,
       izike@qumranet.com, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Rik van Riel <riel@redhat.com>, steiner@sgi.com
X-Mailer: Lotus Notes Release 8.0 August 02, 2007
Message-ID: <OF02DFC038.7260E7CB-ONC12573EE.0047FE76-C12573EE.0042EBE0@de.ibm.com>
From: Christoph Raisch <RAISCH@de.ibm.com>
Date: Wed, 13 Feb 2008 13:11:51 +0100
X-MIMETrack: Serialize by Router on D12ML067/12/M/IBM(Release 7.0.2FP2HF322 | September
 26, 2007) at 13/02/2008 17:12:47
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>  > > Chelsio's T3 HW doesn't support this.


For ehca we currently can't modify a large MR when it has been allocated.
EHCA Hardware expects the pages to be there (MRs must not have "holes").
This is also true for the global MR covering all kernel space.
Therefore we still need the memory to be "pinned" if ib_umem_get() is
called.

So with the current implementation we don't have much use for a notifier.


"It is difficult to make predictions, especially about the future"
Gruss / Regards
Christoph Raisch + Hoang-Nam Nguyen



