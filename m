Return-Path: <linux-kernel-owner+w=401wt.eu-S1754030AbYHLPOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030AbYHLPOw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 11:14:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbYHLPOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 11:14:44 -0400
Received: from emulex.emulex.com ([138.239.112.1]:56550 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbYHLPOn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 11:14:43 -0400
From: James.Smart@Emulex.Com
content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: RFC: I/O bandwidth controller
X-MimeOLE: Produced By Microsoft Exchange V6.0.6619.12
Date: Tue, 12 Aug 2008 11:03:24 -0400
Message-ID: <D1D4C3FF75F9354393DB8314DF43DEF2E7F7ED@xbl3.emulex.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: RFC: I/O bandwidth controller
Thread-Index: Acj8g14F+MzS3/B+SNmfCy2Vprl+TAAB5/qQ
References: <1218117578.11703.81.camel@sebastian.kern.oss.ntt.co.jp><48A0A689.40908@gmail.com>	<loom.20080812T071504-212@post.gmane.org><20080812.201025.57762305.taka@valinux.co.jp><48A18854.9020000@gmail.com> <48A18B1F.6080000@gmail.com> <1218549276.4456.100.camel@sebastian.kern.oss.ntt.co.jp>
To: <fernando@oss.ntt.co.jp>, <righi.andrea@gmail.com>
Cc: <xen-devel@lists.xensource.com>, <containers@lists.linux-foundation.org>,
       <linux-kernel@vger.kernel.org>,
       <virtualization@lists.linux-foundation.org>, <taka@valinux.co.jp>,
       <dm-devel@redhat.com>, <agk@sourceware.org>, <baramsori72@gmail.com>,
       <dave@linux.vnet.ibm.com>, <ngupta@google.com>,
       <balbir@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fernando Luis Vázquez Cao wrote:
> > BTW as I said in a previous email, an interesting path to 
> be explored
> > IMHO could be to think in terms of IO time. So, look at the 
> time an IO
> > request is issued to the drive, look at the time the 
> request is served,
> > evaluate the difference and charge the consumed IO time to the
> > appropriate cgroup. Then dispatch IO requests in function of the
> > consumed IO time debts / credits, using for example a token-bucket
> > strategy. And probably the best place to implement the IO time
> > accounting is the elevator.
> Please note that the seek time for a specific IO request is strongly
> correlated with the IO requests that preceded it, which means that the
> owner of that request is not the only one to blame if it 
> takes too long
> to process it. In other words, with the algorithm you propose 
> we may end
> up charging the wrong guy.

I assume all of these discussions are focused on simple storage - disks
direct attached to a single server - and are not targeted at SANs with
arrays, multi-initiator accesses, and fabric/network impacts. True ? 
Such algorithms can be seriously off-base in these latter configurations.

-- james s
