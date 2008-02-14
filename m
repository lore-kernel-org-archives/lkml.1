Return-Path: <linux-kernel-owner+w=401wt.eu-S1764453AbYBNWoL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764453AbYBNWoL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 17:44:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754259AbYBNWn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 17:43:57 -0500
Received: from qb-out-0506.google.com ([72.14.204.238]:23362 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbYBNWn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 17:43:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=QsczdH+omZX8Vamnlhj1ARWgwknHIPWj5/49QocKCghDHZOdT16URK71fjrcN0Rq8bXNbIsxT3Vtn0jSG8ODghJAQnw/MQ39br7DWzzq2bYbiZrZq1eCc1F7DSBIdoHevUl668buKZ+/f/apNVm4q39Et9MEbcBV4j9GKkx3rCk=
Message-ID: <469958e00802141443g33448abcs3efa6d6c4aec2b56@mail.gmail.com>
Date: Thu, 14 Feb 2008 14:43:54 -0800
From: "Caitlin Bestler" <caitlin.bestler@neterion.com>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: [ofa-general] Re: Demand paging for memory regions
Cc: linux-kernel@vger.kernel.org, avi@qumranet.com, linux-mm@kvack.org,
       general@lists.openfabrics.org, kvm-devel@lists.sourceforge.net
In-Reply-To: <Pine.LNX.4.64.0802141219110.1041@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0802081540180.4291@schroedinger.engr.sgi.com>
	 <ada3arzxgkz.fsf_-_@cisco.com>
	 <47B2174E.5000708@opengridcomputing.com>
	 <Pine.LNX.4.64.0802121408150.9591@schroedinger.engr.sgi.com>
	 <adazlu5vlub.fsf@cisco.com>
	 <8A71B368A89016469F72CD08050AD334026D5C23@maui.asicdesigners.com>
	 <47B45994.7010805@opengridcomputing.com>
	 <Pine.LNX.4.64.0802141137140.500@schroedinger.engr.sgi.com>
	 <469958e00802141217i3a3d16a1k1232d69b8ba54471@mail.gmail.com>
	 <Pine.LNX.4.64.0802141219110.1041@schroedinger.engr.sgi.com>
X-Google-Sender-Auth: 1adaa8be58ad84cb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2008 at 12:20 PM, Christoph Lameter <clameter@sgi.com> wrote:
> On Thu, 14 Feb 2008, Caitlin Bestler wrote:
>
>  > So suspend/resume to re-arrange pages is one thing. Suspend/resume to cover
>  > swapping out pages so they can be reallocated is an exercise in futility. By the
>  > time you resume the connections will be broken or at the minimum damaged.
>
>  The connections would then have to be torn down before swap out and would
>  have to be reestablished after the pages have been brought back from swap.
>
>
I have no problem with that, as long as the application layer is responsible for
tearing down and re-establishing the connections. The RDMA/transport layers
are incapable of tearing down and re-establishing a connection transparently
because connections need to be approved above the RDMA layer.

Further the teardown will have visible artificats that the application
must deal with,
such as flushed Recv WQEs.

This is still, the RDMA device will do X and will not worry about Y. The reasons
for not worrying about Y could be that the suspend will be very short, or that
other mechanisms have taken care  of all the Ys independently.

For example, an HPC cluster that suspended the *entire* cluster would not
have to worry about dropped packets.
