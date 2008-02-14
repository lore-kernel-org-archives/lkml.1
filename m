Return-Path: <linux-kernel-owner+w=401wt.eu-S932208AbYBNTjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208AbYBNTjk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 14:39:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756405AbYBNTjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 14:39:31 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45910 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754937AbYBNTja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 14:39:30 -0500
Date: Thu, 14 Feb 2008 11:39:29 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Steve Wise <swise@opengridcomputing.com>
cc: Felix Marti <felix@chelsio.com>, Roland Dreier <rdreier@cisco.com>,
       Rik van Riel <riel@redhat.com>, steiner@sgi.com,
       Andrea Arcangeli <andrea@qumranet.com>, a.p.zijlstra@chello.nl,
       izike@qumranet.com, linux-kernel@vger.kernel.org, avi@qumranet.com,
       linux-mm@kvack.org, daniel.blueman@quadrics.com,
       Robin Holt <holt@sgi.com>, general@lists.openfabrics.org,
       Andrew Morton <akpm@linux-foundation.org>,
       kvm-devel@lists.sourceforge.net
Subject: Re: [ofa-general] Re: Demand paging for memory regions
In-Reply-To: <47B45994.7010805@opengridcomputing.com>
Message-ID: <Pine.LNX.4.64.0802141137140.500@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0802081540180.4291@schroedinger.engr.sgi.com><20080208234302.GH26564@sgi.com><20080208155641.2258ad2c.akpm@linux-foundation.org><Pine.LNX.4.64.0802081603430.4543@schroedinger.engr.sgi.com><adaprv70yyt.fsf@cisco.com><Pine.LNX.4.64.0802081614030.5115@schroedinger.engr.sgi.com><adalk5v0yi6.fsf@cisco.com><Pine.LNX.4.64.0802081634070.5298@schroedinger.engr.sgi.com><20080209012446.GB7051@v2.random><Pine.LNX.4.64.0802081725200.5445@schroedinger.engr.sgi.com><20080209015659.GC7051@v2.random><Pine.LNX.4.64.0802081813300.5602@schroedinger.engr.sgi.com><20080209075556.63062452@bree.surriel.com><Pine.LNX.4.64.0802091345490.12965@schroedinger.engr.sgi.com><ada3arzxgkz.fsf_-_@cisco.com><47B2174E.5000708@opengridcomputing.com><Pine.LNX.4.64.0802121408150.9591@schroedinger.engr.sgi.com>
 <adazlu5vlub.fsf@cisco.com> <8A71B368A89016469F72CD08050AD334026D5C23@maui.asicdesigners.com>
 <47B45994.7010805@opengridcomputing.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Feb 2008, Steve Wise wrote:

> Note that for T3, this involves suspending _all_ rdma connections that are in
> the same PD as the MR being remapped.  This is because the driver doesn't know
> who the application advertised the rkey/stag to.  So without that knowledge,
> all connections that _might_ rdma into the MR must be suspended.  If the MR
> was only setup for local access, then the driver could track the connections
> with references to the MR and only quiesce those connections.
> 
> Point being, it will stop probably all connections that an application is
> using (assuming the application uses a single PD).

Right but if the system starts reclaiming pages of the application then we 
have a memory shortage. So the user should address that by not running 
other apps concurrently. The stopping of all connections is still better 
than the VM getting into major trouble. And the stopping of connections in 
order to move the process memory into a more advantageous memory location 
(f.e. using page migration) or stopping of connections in order to be able 
to move the process memory out of a range of failing memory is certainly 
good.


