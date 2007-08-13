Return-Path: <linux-kernel-owner+w=401wt.eu-S943064AbXHMRO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S943064AbXHMRO2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 13:14:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1032080AbXHMQ6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 12:58:14 -0400
Received: from web36606.mail.mud.yahoo.com ([209.191.85.23]:33751 "HELO
	web36606.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965847AbXHMQ6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 12:58:11 -0400
X-YMail-OSG: B5HNFzAVM1lgPM03BSBV4l76rbJgsBPhTTHYMXF9Fs8aNWCEh6zaczymx_xOF1Vf06n.A.m.Dg--
X-RocketYMMF: rancidfat
Date: Mon, 13 Aug 2007 09:58:08 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH 00/16] Permit filesystem local caching [try #3]
To: David Howells <dhowells@redhat.com>, casey@schaufler-ca.com
Cc: dhowells@redhat.com, Stephen Smalley <sds@tycho.nsa.gov>,
       torvalds@osdl.org, akpm@osdl.org, steved@redhat.com,
       trond.myklebust@fys.uio.no, linux-fsdevel@vger.kernel.org,
       linux-cachefs@redhat.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       LSM List <linux-security-module@vger.kernel.org>
In-Reply-To: <13221.1187022703@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <959629.46851.qm@web36606.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- David Howells <dhowells@redhat.com> wrote:

> Casey Schaufler <casey@schaufler-ca.com> wrote:
> 
> > >   (1) int security_get_context(void **_context);
> > > 
> > > 	This allocates and gives the caller a blob that describes the current
> > > 	context of all the LSM module states attached to the current task and
> > > 	stores a pointer to it in *_context.
> > 
> > Is this intended to be anything more than a copy of current->security?
> 
> It has to be sufficient to fully effect security_push().

Which is why it requires an LSM interface. Just checking.

> > I assume that you're talking about the LSM specific data changing,
> > not the LSM itself.
> 
> Yes.
> 
> > If you change the task->security information you are definitly going
> > to change what other tasks can do to the calling task.
> 
> I dealt with that in my current act-as patch.  Under SELinux a task has two
> primary labels.  One with which it is labelled and is used to govern effects
> upon it, and one that is used to act upon things and follows changes to the
> former.

The specification of your push interface that the push operation
not affect how others access the process is OK for SELinux, but
not for any other MAC scheme that I've dealt with, and I think
that's most of them. Nuts. Smack, for example, uses exactly one
label on the process for all purposes.

Are you concerned about accesses other than signals? Signals
could be staitforward to deal with in a pushed situation, but
I'd hesitate to say that the solution would generalize without
additional thought.

> > >   (5) int security_xfrm_to_kernel_context(void *from, void **_to);
> > 
> > Woof. What are you transforming from? 
> 
> In CacheFiles case, the cachefilesd daemon's security label into the label
> the
> cache driver acts as on behalf of other processes.

I'm not sure I understand what this is doing.


Casey Schaufler
casey@schaufler-ca.com
