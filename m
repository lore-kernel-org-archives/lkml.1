Return-Path: <linux-kernel-owner+w=401wt.eu-S1764833AbXIMWCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764833AbXIMWCc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 18:02:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758123AbXIMWCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 18:02:22 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:4222 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758045AbXIMWCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 18:02:21 -0400
X-Server-Uuid: 6B5CFB92-F616-4477-B110-55F967A57302
Subject: Re: [ofa-general] InfiniBand/RDMA merge plans for 2.6.24
From: "Michael Chan" <mchan@broadcom.com>
To: "Roland Dreier" <rdreier@cisco.com>
cc: "Steve Wise" <swise@opengridcomputing.com>,
       "netdev" <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org, anilgv@broadcom.com, uri@broadcom.com
In-Reply-To: <adaps0ml18e.fsf@cisco.com>
References: <adahclymos8.fsf@cisco.com>
 <46E97BB0.9030106@opengridcomputing.com> <adaps0ml18e.fsf@cisco.com>
Date: Thu, 13 Sep 2007 15:59:18 -0700
Message-ID: <1189724358.9540.113.camel@dell>
MIME-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-8)
X-WSS-ID: 6AF76CE93K451238-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-09-13 at 14:11 -0700, Roland Dreier wrote:

> 
> I've been meaning to track down the bnx2 iscsi offload patch to look
> and see if this issue is addressed, since the same problem seems to
> exist: it seems an iscsi connection and a main stack tcp connection
> might share the same 4-tuple unless something is done to avoid that
> happening.
> 

iSCSI does not do passive listens, only active connections to the
target.  But you're right, the port space is still shared between iSCSI
and the main stack.  We currently rely on user apps binding to the main
stack to reserve certain ephemeral ports, and telling the iSCSI driver
which ports to use.

