Return-Path: <linux-kernel-owner+w=401wt.eu-S1757909AbYFEMRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757909AbYFEMRT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 08:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756346AbYFEMRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 08:17:11 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:54220 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756309AbYFEMRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 08:17:10 -0400
Date: Thu, 5 Jun 2008 14:17:51 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Oberparleiter <oberparleiter@googlemail.com>
Subject: Re: [PATCH] kbuild: simplify module versioning procedure
Message-ID: <20080605121751.GA18634@uranus.ravnborg.org>
References: <48442052.6080506@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48442052.6080506@de.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter.

On Mon, Jun 02, 2008 at 06:31:14PM +0200, Peter Oberparleiter wrote:
> This patch used to be part of the gcov patch set but is no longer
> required. kbuild simplifications might still prove useful though.
It looks like a simplification but there is actually a reason why
it is done with a temporary fil in this way.

Consider a kernel build that is being terminated with ctrl-c
in the middle. If we when ctrl-c are hit are doing the final 
steps of genksyms then we will next time we type make
consider all done and we will not redo the modversioning
part of the rule because we have an updated .o file.

We have this issue in other places in the build system but
I have not audited the use of redirects yet.

But applying your patch would introduce yet another place where we
have such an issue and we want to get rid of the spots
where hitting ctrl-c can leave us with an inconsistent build.

So I will not apply this patch.

	Sam
