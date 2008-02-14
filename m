Return-Path: <linux-kernel-owner+w=401wt.eu-S933675AbYBNPKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933675AbYBNPKV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 10:10:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752023AbYBNPJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 10:09:56 -0500
Received: from 209-198-142-2-host.prismnet.net ([209.198.142.2]:33617 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751422AbYBNPJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 10:09:55 -0500
Message-ID: <47B45994.7010805@opengridcomputing.com>
Date: Thu, 14 Feb 2008 09:09:08 -0600
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Felix Marti <felix@chelsio.com>
CC: Roland Dreier <rdreier@cisco.com>, Christoph Lameter <clameter@sgi.com>,
       Rik van Riel <riel@redhat.com>, steiner@sgi.com,
       Andrea Arcangeli <andrea@qumranet.com>, a.p.zijlstra@chello.nl,
       izike@qumranet.com, linux-kernel@vger.kernel.org, avi@qumranet.com,
       linux-mm@kvack.org, daniel.blueman@quadrics.com,
       Robin Holt <holt@sgi.com>, general@lists.openfabrics.org,
       Andrew Morton <akpm@linux-foundation.org>,
       kvm-devel@lists.sourceforge.net
Subject: Re: [ofa-general] Re: Demand paging for memory regions
References: <Pine.LNX.4.64.0802081540180.4291@schroedinger.engr.sgi.com><20080208234302.GH26564@sgi.com><20080208155641.2258ad2c.akpm@linux-foundation.org><Pine.LNX.4.64.0802081603430.4543@schroedinger.engr.sgi.com><adaprv70yyt.fsf@cisco.com><Pine.LNX.4.64.0802081614030.5115@schroedinger.engr.sgi.com><adalk5v0yi6.fsf@cisco.com><Pine.LNX.4.64.0802081634070.5298@schroedinger.engr.sgi.com><20080209012446.GB7051@v2.random><Pine.LNX.4.64.0802081725200.5445@schroedinger.engr.sgi.com><20080209015659.GC7051@v2.random><Pine.LNX.4.64.0802081813300.5602@schroedinger.engr.sgi.com><20080209075556.63062452@bree.surriel.com><Pine.LNX.4.64.0802091345490.12965@schroedinger.engr.sgi.com><ada3arzxgkz.fsf_-_@cisco.com><47B2174E.5000708@opengridcomputing.com><Pine.LNX.4.64.0802121408150.9591@schroedinger.engr.sgi.com> <adazlu5vlub.fsf@cisco.com> <8A71B368A89016469F72CD08050AD334026D5C23@maui.asicdesigners.com>
In-Reply-To: <8A71B368A89016469F72CD08050AD334026D5C23@maui.asicdesigners.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felix Marti wrote:

> 
> That is correct, not a change we can make for T3. We could, in theory,
> deal with changing mappings though. The change would need to be
> synchronized though: the VM would need to tell us which mapping were
> about to change and the driver would then need to disable DMA to/from
> it, do the change and resume DMA.
> 

Note that for T3, this involves suspending _all_ rdma connections that 
are in the same PD as the MR being remapped.  This is because the driver 
doesn't know who the application advertised the rkey/stag to.  So 
without that knowledge, all connections that _might_ rdma into the MR 
must be suspended.  If the MR was only setup for local access, then the 
driver could track the connections with references to the MR and only 
quiesce those connections.

Point being, it will stop probably all connections that an application 
is using (assuming the application uses a single PD).


Steve.
