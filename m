Return-Path: <linux-kernel-owner+w=401wt.eu-S1755616AbXKFIzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616AbXKFIzU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 03:55:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751729AbXKFIzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 03:55:07 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:27846 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327AbXKFIzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 03:55:06 -0500
Subject: problem in follow_hugetlb_page on ppc64 architecture with get_user_pages
To: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>, general@lists.openfabrics.org
Cc: agl@us.ibm.com, Hoang-Nam Nguyen <HNGUYEN@de.ibm.com>,
       Roland Dreier <rdreier@cisco.com>
X-Mailer: Lotus Notes Release 8.0 August 02, 2007
Message-ID: <OF6FC435A0.F59C9AD9-ONC125738B.002A5195-C125738B.002A424A@de.ibm.com>
From: Christoph Raisch <RAISCH@de.ibm.com>
Date: Tue, 6 Nov 2007 08:42:40 +0100
X-MIMETrack: Serialize by Router on D12ML067/12/M/IBM(Release 7.0.2HF71 | November 3, 2006) at
 06/11/2007 09:55:02
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,
if get_user_pages is used on a hugetlb vma, and there was no previous write
to the pages,
follow_hugetlb_page will call
ret = hugetlb_fault(mm, vma, vaddr, 0),
although the page should be used for write access in get_user_pages.

We currently see this when testing Infiniband on ppc64 with ehca +
hugetlbfs.
>From reading the code this should also be an issue on other architectures.
Roland, Adam, are you aware of anything in this area with mellanox
Infiniband cards or other usages with I/O adapters?

Gruss / Regards
Christoph R. + Nam Ng.


