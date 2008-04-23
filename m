Return-Path: <linux-kernel-owner+w=401wt.eu-S964892AbYDWBZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964892AbYDWBZo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 21:25:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756770AbYDWBZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 21:25:36 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:46977 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990AbYDWBZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 21:25:36 -0400
From: Roland Dreier <rdreier@cisco.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org
Subject: Re: [bisected] Latest git not seeing HD with sata_nv
References: <adazlrlcw9f.fsf@cisco.com>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 22 Apr 2008 18:25:34 -0700
In-Reply-To: <adazlrlcw9f.fsf@cisco.com> (Roland Dreier's message of "Tue, 22
	Apr 2008 16:20:12 -0700")
Message-ID: <adave29cqgh.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 23 Apr 2008 01:25:34.0853 (UTC) FILETIME=[EDC0E350:01C8A4E0]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > It seems that commit 305d2a1a ("libata: unify mechanism to request
 > follow-up SRST") causes sata_nv not to see the HD on a system I have
 > here; with current git (80750147), I get this in my bootlog:

I wonder if this is related to the code

static int nv_hardreset(struct ata_link *link, unsigned int *class,
			unsigned long deadline)
{
	unsigned int dummy;

	/* SATA hardreset fails to retrieve proper device signature on
	 * some controllers.  Don't classify on hardreset.  For more
	 * info, see http://bugzilla.kernel.org/show_bug.cgi?id=3352
	 */
	return sata_sff_hardreset(link, &dummy, deadline);
}

It seems especially suspicious given that 305d2a1a touches
sata_sff_hardreset...

 - R.
