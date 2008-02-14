Return-Path: <linux-kernel-owner+w=401wt.eu-S1756877AbYBNQYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877AbYBNQYT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 11:24:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753343AbYBNQYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 11:24:11 -0500
Received: from 209-198-142-2-host.prismnet.net ([209.198.142.2]:40165 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753183AbYBNQYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 11:24:09 -0500
Message-ID: <47B46AFB.9070009@opengridcomputing.com>
Date: Thu, 14 Feb 2008 10:23:23 -0600
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Robin Holt <holt@sgi.com>
CC: Felix Marti <felix@chelsio.com>, Roland Dreier <rdreier@cisco.com>,
       Christoph Lameter <clameter@sgi.com>, Rik van Riel <riel@redhat.com>,
       steiner@sgi.com, Andrea Arcangeli <andrea@qumranet.com>,
       a.p.zijlstra@chello.nl, izike@qumranet.com,
       linux-kernel@vger.kernel.org, avi@qumranet.com, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, general@lists.openfabrics.org,
       Andrew Morton <akpm@linux-foundation.org>,
       kvm-devel@lists.sourceforge.net
Subject: Re: [ofa-general] Re: Demand paging for memory regions
References: <adazlu5vlub.fsf@cisco.com> <8A71B368A89016469F72CD08050AD334026D5C23@maui.asicdesigners.com> <47B45994.7010805@opengridcomputing.com> <20080214155333.GA1029@sgi.com>
In-Reply-To: <20080214155333.GA1029@sgi.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robin Holt wrote:
> On Thu, Feb 14, 2008 at 09:09:08AM -0600, Steve Wise wrote:
>> Note that for T3, this involves suspending _all_ rdma connections that are 
>> in the same PD as the MR being remapped.  This is because the driver 
>> doesn't know who the application advertised the rkey/stag to.  So without 
> 
> Is there a reason the driver can not track these.
> 

Because advertising of a MR (ie telling the peer about your rkey/stag, 
offset and length) is application-specific and can be done out of band, 
or in band as simple SEND/RECV payload. Either way, the driver has no 
way of tracking this because the protocol used is application-specific.

>> Point being, it will stop probably all connections that an application is 
>> using (assuming the application uses a single PD).
> 
> It seems like the need to not stop all would be a compelling enough reason
> to modify the driver to track which processes have received the rkey/stag.
> 

Yes, _if_ the driver could track this.

And _if_ the rdma API and paradigm was such that the kernel/driver could 
keep track, then remote revokations of MR tags could be supported.

Stevo
