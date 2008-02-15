Return-Path: <linux-kernel-owner+w=401wt.eu-S1761355AbYBOXwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761355AbYBOXwZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 18:52:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755667AbYBOXwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 18:52:18 -0500
Received: from mx.neterion.com ([72.1.205.142]:42655 "EHLO owa.neterion.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755096AbYBOXwR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 18:52:17 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [ofa-general] Re: Demand paging for memory regions
Date: Fri, 15 Feb 2008 18:50:08 -0500
Message-ID: <78C9135A3D2ECE4B8162EBDCE82CAD77030E2702@nekter>
In-Reply-To: <Pine.LNX.4.64.0802151445100.16270@schroedinger.engr.sgi.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [ofa-general] Re: Demand paging for memory regions
Thread-Index: AchwJS0QS4P5YXMyRmKtNLOhBX3NcQAB7ncA
References: <Pine.LNX.4.64.0802081540180.4291@schroedinger.engr.sgi.com>  <ada3arzxgkz.fsf_-_@cisco.com>  <47B2174E.5000708@opengridcomputing.com>  <Pine.LNX.4.64.0802121408150.9591@schroedinger.engr.sgi.com>  <adazlu5vlub.fsf@cisco.com>  <8A71B368A89016469F72CD08050AD334026D5C23@maui.asicdesigners.com>  <47B45994.7010805@opengridcomputing.com>  <Pine.LNX.4.64.0802141137140.500@schroedinger.engr.sgi.com>  <469958e00802141217i3a3d16a1k1232d69b8ba54471@mail.gmail.com>  <Pine.LNX.4.64.0802141219110.1041@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0802141445570.3298@schroedinger.engr.sgi.com> <78C9135A3D2ECE4B8162EBDCE82CAD77030E2456@nekter> <Pine.LNX.4.64.0802141836070.4898@schroedinger.engr.sgi.com> <78C9135A3D2ECE4B8162EBDCE82CAD77030E25BA@nekter> <Pine.LNX.4.64.0802151044310.12890@schroedinger.engr.sgi.com> <78C9135A3D2ECE4B8162EBDCE82CAD77030E25F1@nekter> <Pine.LNX.4.64.0802151158560.14517@schroedinger.engr.sgi.com> <78C9135A3D2ECE4B8162EBDCE82CAD77030E2657@nekter> <Pine.LNX.4.64.0802
	151445100.16270@schroedinger.engr.sgi.com>
From: "Caitlin Bestler" <Caitlin.Bestler@neterion.com>
To: "Christoph Lameter" <clameter@sgi.com>
Cc: <linux-kernel@vger.kernel.org>, <avi@qumranet.com>, <linux-mm@kvack.org>,
       <general@lists.openfabrics.org>, <kvm-devel@lists.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Christoph Lameter [mailto:clameter@sgi.com]
> Sent: Friday, February 15, 2008 2:50 PM
> To: Caitlin Bestler
> Cc: linux-kernel@vger.kernel.org; avi@qumranet.com;
linux-mm@kvack.org;
> general@lists.openfabrics.org; kvm-devel@lists.sourceforge.net
> Subject: RE: [ofa-general] Re: Demand paging for memory regions
> 
> On Fri, 15 Feb 2008, Caitlin Bestler wrote:
> 
> > There isn't much point in the RDMA layer subscribing to mmu
> > notifications
> > if the specific RDMA device will not be able to react appropriately
> when
> > the notification occurs. I don't see how you get around needing to
> know
> > which devices are capable of supporting page migration (via
> > suspend/resume
> > or other mechanisms) and which can only respond to a page migration
> by
> > aborting connections.
> 
> You either register callbacks if the device can react properly or you
> dont. If you dont then the device will continue to have the problem
> with
> page pinning etc until someone comes around and implements the
> mmu callbacks to fix these issues.
> 
> I have doubts regarding the claim that some devices just cannot be
made
> to
> suspend and resume appropriately. They obviously can be shutdown and
so
> its a matter of sequencing the things the right way. I.e. stop the app
> wait for a quiet period then release resources etc.
> 
> 

That is true. What some devices will be unable to do is suspend
and resume in a manner that is transparent to the application.
However, for the duration required to re-arrange pages it is 
definitely feasible to do so transparently to the application.

Presumably the Virtual Memory Manager would be more willing to
take an action that is transparent to the user than one that is
disruptive, although obviously as the owner of the physical memory
it has the right to do either.
