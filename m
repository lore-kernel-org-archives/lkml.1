Return-Path: <linux-kernel-owner+w=401wt.eu-S934307AbYBNWtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934307AbYBNWtX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 17:49:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933685AbYBNWs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 17:48:59 -0500
Received: from relay1.sgi.com ([192.48.171.29]:42207 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933576AbYBNWs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 17:48:58 -0500
Date: Thu, 14 Feb 2008 14:48:57 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Caitlin Bestler <caitlin.bestler@neterion.com>
cc: linux-kernel@vger.kernel.org, avi@qumranet.com, linux-mm@kvack.org,
       general@lists.openfabrics.org, kvm-devel@lists.sourceforge.net
Subject: Re: [ofa-general] Re: Demand paging for memory regions
In-Reply-To: <469958e00802141443g33448abcs3efa6d6c4aec2b56@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0802141445570.3298@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0802081540180.4291@schroedinger.engr.sgi.com> 
 <ada3arzxgkz.fsf_-_@cisco.com>  <47B2174E.5000708@opengridcomputing.com> 
 <Pine.LNX.4.64.0802121408150.9591@schroedinger.engr.sgi.com> 
 <adazlu5vlub.fsf@cisco.com>  <8A71B368A89016469F72CD08050AD334026D5C23@maui.asicdesigners.com>
  <47B45994.7010805@opengridcomputing.com>  <Pine.LNX.4.64.0802141137140.500@schroedinger.engr.sgi.com>
  <469958e00802141217i3a3d16a1k1232d69b8ba54471@mail.gmail.com> 
 <Pine.LNX.4.64.0802141219110.1041@schroedinger.engr.sgi.com>
 <469958e00802141443g33448abcs3efa6d6c4aec2b56@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Feb 2008, Caitlin Bestler wrote:

> I have no problem with that, as long as the application layer is responsible for
> tearing down and re-establishing the connections. The RDMA/transport layers
> are incapable of tearing down and re-establishing a connection transparently
> because connections need to be approved above the RDMA layer.

I am not that familiar with the RDMA layers but it seems that RDMA has 
a library that does device driver like things right? So the logic would 
best fit in there I guess.

If you combine mlock with the mmu notifier then you can actually 
guarantee that a certain memory range will not be swapped out. The 
notifier will then only be called if the memory range will need to be 
moved for page migration, memory unplug etc etc. There may be a limit on 
the percentage of memory that you can mlock in the future. This may be 
done to guarantee that the VM still has memory to work with.


