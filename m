Return-Path: <linux-kernel-owner+w=401wt.eu-S1760611AbXH3O31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760611AbXH3O31 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 10:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756714AbXH3O3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 10:29:19 -0400
Received: from pat.uio.no ([129.240.10.15]:54882 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756461AbXH3O3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 10:29:18 -0400
Subject: Re: NFS4 authentification / fsuid
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0708301610290.24730@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0708301610290.24730@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain
Date: Thu, 30 Aug 2007 10:29:15 -0400
Message-Id: <1188484155.6755.38.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.093)
X-UiO-Scanned: 3C9D530EFF8EB52FA153EB616EA2B664A19C1D8D
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 704 total 3566749 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-30 at 16:12 +0200, Jan Engelhardt wrote:
> Hi,
> 
> 
> with NFS3, there is this 'root hole', i.e. any person who has a root 
> account (perhaps by use of a laptop) can mount an export (let's say this 
> export had the "root_squash" option), and still have a look at the user 
> files, because he can locally setuid() into another user.
> 
> So I was looking for alternatives. CIFS is my favorite candidate, but it 
> has a few issues right now. So does sshfs and about everything I have 
> come across. Since I remember NFS4 can use KRB5 authentification, my 
> question is, will the NFS(4) server process run with an fsuid equal to 
> the user that authenticated?
> 
> 
> thanks,
> 	Jan

NFSv3 should work fine with krb5 too, but that won't solve your problem
with setuid: kerberos saves the TGT in a file on /tmp, so root can still
suid and grab your cred (and the same goes for CIFS).

We've got people working on fixing this problem using David Howells'
keyrings, but it will probably be a while until we've solved all the
upcall issues, and it will probably take even longer to push the
kerberos changes back to the official MIT etc distros.

Cheers
  Trond

