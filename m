Return-Path: <linux-kernel-owner+w=401wt.eu-S1764106AbXGPRhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764106AbXGPRhZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 13:37:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753261AbXGPRhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 13:37:14 -0400
Received: from sj-iport-2-in.cisco.com ([171.71.176.71]:62045 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105AbXGPRhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 13:37:12 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAD9Jm0arR7PD/2dsb2JhbAA
X-IronPort-AV: i="4.16,542,1175497200"; 
   d="scan'208"; a="385958889:sNHT29474410"
To: Joachim Fenkes <fenkes@de.ibm.com>
Cc: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>,
       "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
Subject: Re: [PATCH 10/10] IB/ehca: Support large page MRs
X-Message-Flag: Warning: May contain useful information
References: <200707121745.27592.fenkes@de.ibm.com>
	<200707121754.20293.fenkes@de.ibm.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 16 Jul 2007 10:37:09 -0700
In-Reply-To: <200707121754.20293.fenkes@de.ibm.com> (Joachim Fenkes's message of "Thu, 12 Jul 2007 17:54:19 +0200")
Message-ID: <adaabtww8qi.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 16 Jul 2007 17:37:10.0178 (UTC) FILETIME=[EFFC1020:01C7C7CF]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > Add support for MR pages larger than 4K on eHCA2. This reduces firmware
 > memory consumption. If enabled via the mr_largepage module parameter, the MR
 > page size will be determined based on the MR length and the hardware
 > capabilities - if the MR is >= 16M, 16M pages are used, for example.

Why the module parameter?  Is there any reason a user would want to
turn this off?  Or conversely, why is it off by default?

Also this patch seems to depend heavily on the multiple EQ patch,
which I am holding off on now.  So you may want to rebase to my
current tree, which has all the ehca patches except the EQ one.

 >  static ssize_t ehca_show_nr_eqs(struct device *dev,
 >  				struct device_attribute *attr,
 >  				char *buf)
 >  {
 >  	return sprintf(buf, "%d\n", ehca_nr_eqs);
 >  }
 > -
 >  static DEVICE_ATTR(nr_eqs, S_IRUGO, ehca_show_nr_eqs, NULL);

Although trivial, this chunk doesn't really belong in this patch --
just fix it up in the multiple EQ patch (which I haven't merged yet).

 - R.
