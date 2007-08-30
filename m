Return-Path: <linux-kernel-owner+w=401wt.eu-S1762730AbXH3PM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762730AbXH3PM3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 11:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756868AbXH3PMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 11:12:20 -0400
Received: from mail.fieldses.org ([66.93.2.214]:58070 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758252AbXH3PMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 11:12:19 -0400
Date: Thu, 30 Aug 2007 11:12:14 -0400
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: NFS4 authentification / fsuid
Message-ID: <20070830151214.GG26863@fieldses.org>
References: <Pine.LNX.4.64.0708301610290.24730@fbirervta.pbzchgretzou.qr> <1188484155.6755.38.camel@heimdal.trondhjem.org> <1188484337.6755.41.camel@heimdal.trondhjem.org> <Pine.LNX.4.64.0708301640030.24730@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708301640030.24730@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2007 at 04:42:33PM +0200, Jan Engelhardt wrote:
> 
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
> non-root fsuid. Did I miss something? (Especially the /dev/mem thing
> is not quite clear to me.)

The server will run with an fsuid equal to the user that authenticated,
you're correct.  So if you require krb5 access on an export, then nfs
access to a file on the export should be permitted only on rpc's that
are authenticated using credentials of a user with permission to access
the file.

Trond's pointing out that when you give the client your krb5 credentials
you're trusting it to do only what you tell it to with them.  You have
to trust the client's kernel at the very least, and also root on that
client, for the forseeable future.

--b.
