Return-Path: <linux-kernel-owner+w=401wt.eu-S1758203AbYD2Qn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758203AbYD2Qn4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 12:43:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754241AbYD2Qns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 12:43:48 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:36122 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753629AbYD2Qnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 12:43:47 -0400
From: Roland Dreier <rdreier@cisco.com>
To: Stefan Roscher <ossrosch@linux.vnet.ibm.com>
Cc: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, "OF-EWG" <ewg@lists.openfabrics.org>,
       hnguyen@de.ibm.com, raisch@de.ibm.com, fenkes@de.ibm.com
Subject: Re: [PATCH] IB/ehca: Allocate event queue size depending on max number of CQs and QPs
References: <200804291744.17235.ossrosch@linux.vnet.ibm.com>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 29 Apr 2008 09:43:42 -0700
In-Reply-To: <200804291744.17235.ossrosch@linux.vnet.ibm.com> (Stefan
	Roscher's message of "Tue, 29 Apr 2008 17:44:15 +0200")
Message-ID: <adafxt4y5kx.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 29 Apr 2008 16:43:42.0984 (UTC) FILETIME=[2F511880:01C8AA18]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > 
 > Signed-off-by: Stefan Roscher <stefan.roscher at de.ibm.com>

Kind of an inadequate changelog ;)

Is this a fix or an enhancement or what?

 > +	if (atomic_read(&shca->num_cqs) >= ehca_max_cq) {

 > +	if (atomic_read(&shca->num_qps) >= ehca_max_qp) {

These are racy in the sense that multiple simultaneous calls to
create_cq/create_qp might end up exceeding the ehca_max_cq limit.  Is
that an issue?

You could close the race by using atomic_add_unless() and testing the
return value (and being careful to do atomic_dec() on error paths after
you bump num_cqs/num_qps).

 - R.
