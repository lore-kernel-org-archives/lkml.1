Return-Path: <linux-kernel-owner+w=401wt.eu-S1762704AbXEJXtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762704AbXEJXtq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 19:49:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755657AbXEJXtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 19:49:39 -0400
Received: from gw.goop.org ([64.81.55.164]:40195 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754858AbXEJXtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 19:49:39 -0400
Message-ID: <4643AF8F.5040705@goop.org>
Date: Thu, 10 May 2007 16:49:35 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: David Chinner <dgc@sgi.com>
CC: Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Matt Mackall <mpm@selenic.com>, xfs@oss.sgi.com
Subject: Re: 2.6.21-git10/11: files getting truncated on xfs? or maybe an
 nlink problem?
References: <20070509231643.GM85884050@sgi.com> <4642598E.3000607@goop.org> <20070510000119.GO85884050@sgi.com> <46426194.3040403@goop.org> <46439185.5060207@redhat.com> <464392B4.3070009@goop.org> <464393E1.3050705@redhat.com> <46439491.9010604@goop.org> <20070510225834.GF86004887@sgi.com> <4643A5B2.3060906@goop.org> <20070510232729.GH86004887@sgi.com>
In-Reply-To: <20070510232729.GH86004887@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Chinner wrote:
> Ok, this is important to kow becase we merged a mod around that time
> that changes the way we handle the updates to the file size i.e. the
> fix for the NULL-files-on-crash problem:
>
> http://git2.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=ba87ea699ebd9dd577bf055ebc4a98200e337542
>
> and that means the size of the file is not updated to the incore
> cached inode until after the data write is complete. The symptoms
> being seen would match with a inode-not-being-written-after-last-
> data-write-bug in this mod....
>   

Yes, that does look like a good candidate.  Should I try to
before-and-after this change?

    J
