Return-Path: <linux-kernel-owner+w=401wt.eu-S1760836AbXK1Loa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760836AbXK1Loa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 06:44:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759415AbXK1LoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 06:44:22 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:46767 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759226AbXK1LoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 06:44:21 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Ingo Molnar <mingo@elte.hu>
Cc: Albert Cahalan <acahalan@gmail.com>,
       Guillaume Chazarain <guichaz@yahoo.fr>, akpm@linux-foundation.org,
       mm-commits@vger.kernel.org, oleg@tv-sign.ru, rjw@sisk.pl,
       roland@redhat.com, xemul@openvz.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: + proc-fix-the-threaded-proc-self.patch added to -mm tree
References: <200711262339.lAQNdNrw029057@imap1.linux-foundation.org>
	<20071128014901.4b303954@inria.fr>
	<787b0d920711280141v463759efod86395c50c1b47c5@mail.gmail.com>
	<20071128104622.GB19694@elte.hu>
	<m1ve7mehcm.fsf@ebiederm.dsl.xmission.com>
Date: Wed, 28 Nov 2007 04:42:22 -0700
In-Reply-To: <m1ve7mehcm.fsf@ebiederm.dsl.xmission.com> (Eric W. Biederman's
	message of "Wed, 28 Nov 2007 04:31:53 -0700")
Message-ID: <m1r6iaegv5.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ebiederm@xmission.com (Eric W. Biederman) writes:

> I am not certain the two components make sense as we have a possible
> permission problem where it is remotely possible that a task will
> have permission to access /proc/<tid> but not /proc/<tgid>.

Got it.  I can totally avoid in permission issues by having a
follow_link method that just goes to the target directory without
checking permissions as we go.

So in the worst case with weird selinux permission rules you
might be able to access /proc/task but not /proc/self or
/proc/task/..

At least for what I care about, weird cases with unshare where the
mounts and the other namespaces may be different between threads in
someones home rolled thread package that uses CLONE_THREAD
we should be ok.

Eric

