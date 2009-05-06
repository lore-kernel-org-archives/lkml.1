Return-Path: <linux-kernel-owner+w=401wt.eu-S1758525AbZEFLyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758525AbZEFLyq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 07:54:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755351AbZEFLyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 07:54:35 -0400
Received: from msux-gh1-uea02.nsa.gov ([63.239.67.2]:59474 "EHLO
	msux-gh1-uea02.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754851AbZEFLyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 07:54:35 -0400
Subject: Re: [PATCH] do_wait: do take security_task_wait() into account
From: Stephen Smalley <sds@tycho.nsa.gov>
To: James Morris <jmorris@namei.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>, Eric Paris <eparis@parisplace.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LRH.2.00.0905010851270.28491@tundra.namei.org>
References: <20090428223025.GA11997@redhat.com>
	 <20090428233305.GA14221@redhat.com> <20090429160123.GA4591@redhat.com>
	 <alpine.LRH.2.00.0905010851270.28491@tundra.namei.org>
Content-Type: text/plain
Organization: National Security Agency
Date: Wed, 06 May 2009 07:46:47 -0400
Message-Id: <1241610407.27629.8.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-01 at 08:51 +1000, James Morris wrote:
> On Wed, 29 Apr 2009, Oleg Nesterov wrote:
> 
> > I was never able to understand what should we actually do when
> > security_task_wait() fails, but the current code doesn't look right.
> > 
> > If ->task_wait() returns the error, we update *notask_error correctly.
> > But then we either reap the child (despite the fact this was forbidden)
> > or clear *notask_error (and hide the securiy policy problems).
> > 
> > This patch assumes that "stolen by ptrace" doesn't matter. If selinux
> > denies the child we should ignore it but make sure we report -EACCESS
> > instead of -ECHLD if there are no other eligible children.
> > 
> > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> 
> Applied to: 
> git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

FWIW, I confirmed that this corrected a FAIL in the ltp selinux
testsuite (wait test).

Tested-by:  Stephen Smalley <sds@tycho.nsa.gov>

-- 
Stephen Smalley
National Security Agency

