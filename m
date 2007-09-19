Return-Path: <linux-kernel-owner+w=401wt.eu-S1760159AbXISR2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760159AbXISR2r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 13:28:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756648AbXISR2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 13:28:35 -0400
Received: from web36611.mail.mud.yahoo.com ([209.191.85.28]:23699 "HELO
	web36611.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759618AbXISR2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 13:28:33 -0400
X-YMail-OSG: 8Q3YlYAVM1mn524WUEmnj.NZJEfv8RLjTbXoCpgZqsTCTRgFMvC8Td6uJAlH2uMrlMNQZqTiqA--
X-RocketYMMF: rancidfat
Date: Wed, 19 Sep 2007 10:28:32 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH 2/3] CRED: Split the task security data and move part of it into struct cred
To: David Howells <dhowells@redhat.com>, viro@ftp.linux.org.uk,
       hch@infradead.org, Trond.Myklebust@netapp.com, sds@tycho.nsa.gov,
       casey@schaufler-ca.com
Cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
In-Reply-To: <20070919161759.8334.11581.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <843863.97817.qm@web36611.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- David Howells <dhowells@redhat.com> wrote:

> Move into the cred struct the part of the task security data that defines how
> a
> task acts upon an object.  The part that defines how something acts upon a
> task
> remains attached to the task.

This seems to me to be an unnatural and inappropriate separation.
Move the whole of the security blob into the cred if you must have
a cred (which I was soooo glad Linux didn't have after having dealt
with it in Solaris) rather than having two blobs to deal with. If an
LSM requires a different treatment between when a task is a subject
and when it is an object the LSM should handle that itself.

> For SELinux this requires some of task_security_struct to be split off into
> cred_security_struct which is then attached to struct cred.  Note that the
> contents of cred_security_struct may not be changed without the generation of
> a
> new struct cred.
> 
> The split is as follows:
> 
>  (*) create_sid, keycreate_sid and sockcreate_sid just move across.
> 
>  (*) sid is split into victim_sid - which remains - and action_sid - which
>      migrates.
> 
>  (*) osid, exec_sid and ptrace_sid remain.
> 
> victim_sid is the SID used to govern actions upon the task.  action_sid is
> used
> to govern actions made by the task.

So put all these fields into one blob and attach them to the cred.
Actually, if you put all these fields in the task blob maybe you
don't need to do your COW thing at all.
 



Casey Schaufler
casey@schaufler-ca.com
