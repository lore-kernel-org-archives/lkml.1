Return-Path: <linux-kernel-owner+w=401wt.eu-S1762098AbXH3PER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762098AbXH3PER (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 11:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759337AbXH3PEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 11:04:06 -0400
Received: from pat.uio.no ([129.240.10.15]:53354 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759161AbXH3PEF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 11:04:05 -0400
Subject: Re: NFS4 authentification / fsuid
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0708301640030.24730@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0708301610290.24730@fbirervta.pbzchgretzou.qr>
	 <1188484155.6755.38.camel@heimdal.trondhjem.org>
	 <1188484337.6755.41.camel@heimdal.trondhjem.org>
	 <Pine.LNX.4.64.0708301640030.24730@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain
Date: Thu, 30 Aug 2007 11:04:00 -0400
Message-Id: <1188486240.6755.51.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.092)
X-UiO-Scanned: 17DD52D4FDE5C3F44A1467E6A98EFD976AF2165D
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 71 total 3567378 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-30 at 16:42 +0200, Jan Engelhardt wrote:
> On Aug 30 2007 10:29, Trond Myklebust wrote:
> >On Thu, 2007-08-30 at 16:12 +0200, Jan Engelhardt wrote:
> >> 
> >> with NFS3, there is this 'root hole', i.e. any person who has a root 
> >> account (perhaps by use of a laptop) can mount an export (let's say this 
> >> export had the "root_squash" option), and still have a look at the user 
> >> files, because he can locally setuid() into another user.
> >> 
> >> So I was looking for alternatives. CIFS is my favorite candidate, but it 
> >> has a few issues right now. So does sshfs and about everything I have 
> >> come across. Since I remember NFS4 can use KRB5 authentification, my 
> >> question is, will the NFS(4) server process run with an fsuid equal to 
> >> the user that authenticated?
> >
> >NFSv3 should work fine with krb5 too, but that won't solve your problem
> >with setuid: kerberos saves the TGT in a file on /tmp, so root can still
> >suid and grab your cred (and the same goes for CIFS).
> 
> Hm? I do not see this problem with CIFS. The user may have local
> root, but on the server, he only has his non-root account on the
> server, and as such, can only operate on the server using this
> non-root fsuid.

With CIFS or other password based protocols (including RPCSEC_GSS) all
the root user needs in order to steal your identity is to grab a copy of
your password or a credential. It is not quite as trivial to do as
changing uid, but it is hardly rocket science if the compromised machine
is one that you log into regularly.

>  Did I miss something? (Especially the /dev/mem thing
> is not quite clear to me.)
> 
> >BTW: even when this task is done, a creative root can still find ways to
> >subvert the security (he can read /dev/mem, replace the kernel with a
> >compromised one, ....). The bottom line is that if you can't trust root,
> >don't even log in.

What I'm saying is that the superuser can pretty much do whatever it
takes to grab either your kerberos password (e.g. install a keyboard
listener), a stored credential (read the contents of your kerberos
on-disk credential cache), or s/he can access the cached contents of the
file by hunting through /dev/kmem.

IOW: There is no such thing as security on a root-compromised machine.

Trond

