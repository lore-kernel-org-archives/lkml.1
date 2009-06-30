Return-Path: <linux-kernel-owner+w=401wt.eu-S1753429AbZF3Riz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429AbZF3Riz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 13:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751621AbZF3Ris
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 13:38:48 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46977 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbZF3Rir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 13:38:47 -0400
Date: Tue, 30 Jun 2009 13:38:36 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, earl_chew@agilent.com,
       Oleg Nesterov <oleg@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andi Kleen <andi@firstfloor.org>, nhorman@tuxdriver.com
Subject: Re: [PATCH 0/3] exec: Make do_coredump more robust and safer when
	using pipes in core_pattern (v4)
Message-ID: <20090630173836.GA15612@hmsreliant.think-freely.org>
References: <20090622172818.GB14673@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090622172818.GB14673@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, Heres version 4 of this patch set.  Based on feedback from the past few days
I've made some changes (noted below).  I've tested all of these patches here,
and they work quite well, I'm able to prevent recursive core dumps, wait on
dumps to complete, and limit the number of dupms I handle in parallel

Change Notes:

1) Diffed against latest Linus kernel + Olegs cleanup patches to do_coredump

2) Refactored into 3 patches instead of two (I still don't think its needed, but
I've received more than one request to pull the sysctl into a separate patch, so
I'm going with consensus here, and it won't hurt anything anyway)

3) Changed how we detect completed user space processes.  We need to be able to
close a pipe and then wait on the pipe reader to finish with it.  As such we
have to do some trickery with the pipe readers and writers counts to make that
happen.

Patches in subsequent mails
Regards
Neil

