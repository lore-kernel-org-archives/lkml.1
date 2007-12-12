Return-Path: <linux-kernel-owner+w=401wt.eu-S1760960AbXLLThn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760960AbXLLThn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 14:37:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758664AbXLLThe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 14:37:34 -0500
Received: from web36613.mail.mud.yahoo.com ([209.191.85.30]:31510 "HELO
	web36613.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758306AbXLLThd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 14:37:33 -0500
X-YMail-OSG: 6LJHd.4VM1l_xTu5oLI4QhWRMcZRp5JvV_ois5BSpnySgyymmQIwdS0lBiTDkS7m6EuAYDKpmA--
X-RocketYMMF: rancidfat
Date: Wed, 12 Dec 2007 11:37:32 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH 08/28] SECURITY: Allow kernel services to override LSM settings for task actions [try #2]
To: David Howells <dhowells@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>
Cc: dhowells@redhat.com, casey@schaufler-ca.com,
       Karl MacMillan <kmacmill@redhat.com>, viro@ftp.linux.org.uk,
       hch@infradead.org, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
In-Reply-To: <32168.1197484170@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <573241.88686.qm@web36613.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- David Howells <dhowells@redhat.com> wrote:

> Stephen Smalley <sds@tycho.nsa.gov> wrote:
> 
> > That sounds workable, although I think he will want a more specific hook
> > than security_secctx_to_secid(), or possibly a second hook call, that
> > would not only validate the context but authorize the use of it by the
> > cachefilesd process.  And then the security_task_kernel_act_as() hook
> > just takes the secid as input rather than the task struct of the daemon,
> > and applies it.  At that point, nfsd can use the same mechanism for
> > setting the acting SID based on the client process after doing its own
> > authorization.
> 
> I thought using secids was verboten as it made things too specific.

I have argued that in the past. I'm reasonably convinced that I have
lost that argument at least for the immediate future as audit, usb,
and networking are all dependent on them. I can't image an LSM that
manages to avoid them, at least for the short term. If secid's are
ever expundged from the kernel cachefiles will require reeducation,
but that will be a minor effort.

> Have you example code for the security hook you mention?  I'm not sure I
> understand why security_secctx_to_secid() is not sufficient.
> 
> Or is it that I need something that takes a secctx, converts it to a secid
> and
> authorises its use all in one go?
> If it's this, why can't that be rolles
> into
> security_task_kernel_act_as()?  That sets up a task_security struct which is
> then switched in and out without consultation of the LSM.

It would seem to me that security_secctx_to_secid() ought to suffice
if the application code was written correctly. Be aware that factors
outside the LSM may be important, too. As Stephen points out elsewhere,
Smack will require you have particular capabilities (CAP_MAC_OVERRIDE,
CAP_MAC_ADMIN) while a DAC LSM may require CAP_DAC_OVERRIDE. SELinux
is likely to be the odd duck in this pond in that it does not use the
capability mechanism in the way Nature intends it to be, opting to
treat "privilege" with a completely different model.


Casey Schaufler
casey@schaufler-ca.com
