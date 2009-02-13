Return-Path: <linux-kernel-owner+w=401wt.eu-S1759386AbZBMOWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759386AbZBMOWS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 09:22:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753135AbZBMOWC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 09:22:02 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47691 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752696AbZBMOWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 09:22:01 -0500
Date: Fri, 13 Feb 2009 15:21:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, jmorris@namei.sys, akpm@linux-foundation.org,
       serue@us.ibm.com, kosaki.motohiro@jp.fujitsu.com,
       linux-kernel@vger.kernel.org, vegard.nossum@gmail.com,
       containers@lists.osdl.org, snakebyte@gmx.de,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] User namespaces: Only put the userns when we unhash
	the uid
Message-ID: <20090213142114.GA24047@elte.hu>
References: <20090213140421.5698.86876.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090213140421.5698.86876.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Howells <dhowells@redhat.com> wrote:

> From: Serge E. Hallyn <serue@us.ibm.com>
> 
> uids in namespaces other than init don't get a sysfs entry.
> 
> For those in the init namespace, while we're waiting to remove
> the sysfs entry for the uid the uid is still hashed, and
> alloc_uid() may re-grab that uid without getting a new
> reference to the user_ns, which we've already put in free_user
> before scheduling remove_user_sysfs_dir().
> 
> Reported-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
> Acked-by: David Howells <dhowells@redhat.com>
> Tested-by: Ingo Molnar <mingo@elte.hu>

beyond the crashes, this should resolve this slab corruption
regression too:

Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12503
Subject         : [slab corruption] BUG key_jar: Poison overwritten
Submitter       : Ingo Molnar <mingo@elte.hu>
Date            : 2009-01-15 18:16 (25 days old)
References      : http://marc.info/?l=linux-kernel&m=123204353425825&w=4
Handled-By      : David Howells <dhowells@redhat.com>

	Ingo
