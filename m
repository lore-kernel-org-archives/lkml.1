Return-Path: <linux-kernel-owner+w=401wt.eu-S1765674AbYB1UCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765674AbYB1UCS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 15:02:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765482AbYB1UAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 15:00:04 -0500
Received: from web36613.mail.mud.yahoo.com ([209.191.85.30]:33167 "HELO
	web36613.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1761681AbYB1T77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 14:59:59 -0500
X-YMail-OSG: i1apEeMVM1kDOCWVixnyXPZUE0rXAOM_iOKzeR0sz6B0C8CTe022OFt7q6dEtLymeIZMg06a6g--
X-RocketYMMF: rancidfat
Date: Thu, 28 Feb 2008 11:59:58 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH 01/11] Security: Add hook to get full maclabel xattr name
To: Stephen Smalley <sds@tycho.nsa.gov>, casey@schaufler-ca.com
Cc: Dave Quigley <dpquigl@tycho.nsa.gov>, hch@infradead.org,
       viro@ftp.linux.org.uk, trond.myklebust@fys.uio.no, bfields@fieldses.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       LSM List <linux-security-module@vger.kernel.org>
In-Reply-To: <1204227035.31790.207.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <252958.17620.qm@web36613.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Stephen Smalley <sds@tycho.nsa.gov> wrote:

> 
> On Thu, 2008-02-28 at 11:23 -0800, Casey Schaufler wrote:
> ...
> > LSM is not supposed to be only for MAC and it's not supposed
> > to be only for label based schemes. It's supposed to be
> > for additional security restrictions. Providing an interface
> > that should be generally applicable with a name that
> > constrains it to a specific subset of those schemes is wrong.
> 
> Casey, you aren't listening (why am I surprised?).

I think that I am listening, and I appologize for doing
such a poor job of getting my view on the across.

> This is an interface to be used by NFS to get information from the
> security module.  The information desired is specific to the MAC
> labeling functionality in NFSv4 that is being proposed.

Do you understand that if the functionality being proposed
is specific to a particular file system it ought to be contained
in that file system, not proposed as a part of the general
purpose interface?

> That
> functionality is MAC specific (necessarily so, just like the ACL
> functionality is ACL specific).

The ACL funtionality over NFS could be done using general interfaces,
and there are examples (e.g. Irix) where it has been done. I
understand the rationale for the current implementation while
disagreeing with that rationale. Further, there is a major difference
between ACLs and a legitimate LSM (for MAC or DAC) in that ACLs
are a change to the Linux access control scheme (they interact with
the mode bits) whereas a legitimate LSM is strictly additional
restrictions.

> We are hiding the SELinux-specific bits
> behind the LSM interface, and non-MAC LSMs are free to return NULL in
> order to indicate that they don't support MAC labeling.  We do NOT want
> the capability module to return its security blob here, or any other
> non-MAC LSM - it will yield the wrong semantics for the NFS MAC support.

I should hope then that your SELinux specific NFS server should
look at the name presented and treat it appropriately.

> In any event, I don't think we need your permission.

You're correct, you don't. You can propose anything you like.
Don't take my criticisms personally, but I think you're wrong
on this one. I don't like to see this unnecessary limitation,
the kind that could haunt the code base for years, when it seems
pretty obvious that it could be better.



Casey Schaufler
casey@schaufler-ca.com
