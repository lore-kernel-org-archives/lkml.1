Return-Path: <linux-kernel-owner+w=401wt.eu-S1763219AbXJMT0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763219AbXJMT0l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 15:26:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762685AbXJMT0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 15:26:16 -0400
Received: from web36611.mail.mud.yahoo.com ([209.191.85.28]:46286 "HELO
	web36611.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1762641AbXJMT0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 15:26:14 -0400
X-YMail-OSG: CXeDxrEVM1m3L1CMP_jkHazIAQQEMGzHipmogFdW3zLkAtYK5M5iMyajSoGn1AVr_MTFC7Yjgw--
X-RocketYMMF: rancidfat
Date: Sat, 13 Oct 2007 12:26:13 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH] Version 6 (2.6.23) Smack: Simplified Mandatory Access Control Kernel
To: Al Viro <viro@ftp.linux.org.uk>, Casey Schaufler <casey@schaufler-ca.com>
Cc: torvalds@osdl.org, akpm@osdl.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
In-Reply-To: <20071013060400.GD8181@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <737394.85994.qm@web36611.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Al Viro <viro@ftp.linux.org.uk> wrote:

> On Fri, Oct 12, 2007 at 10:01:17PM -0700, Casey Schaufler wrote:
> 
> What do you need smk_sb for?  Looks like dead weight...

Reminant of an abandoned thought process. Cleaning.

> smk_read_load(): obvious seq_file candidate.
> smk_read_cipso(): ditto.
> 
> What protects smk_cipso_written?  BTW, its use on the read side is an
> atrocity...
> 
> smk_write_doi() - WTF would NUL-terminate temp[]?  You run sscanf on
> it...
> smk_write_direct() - ditto
> smk_write_ambient() - ditto
> smk_read_ambient() - who said that you won't get write between strlen()
> and simple_read_from_buffer()?

Eek. The smackfs code does look pretty crufty in the
context of seq_file, doesn't it? I will have a go at
cleaning that up some.

> smk_import_entry():
> > +	for (skp = smack_known; skp != NULL; skp = skp->smk_next)
> > +		if (skp->smk_known == smack)
> > +			break;
> Really?  With smack[] being an auto array?

Nope. What you see there is a flaw, a mistake, a bug.
And a serious memory use problem, too. Fix in test.
Thank you.

> That's from quick look through the read/write in there; I hadn't really
> looked into parsers or deeper into the guts.

Your suggestions regarding seq_file look helpful. Thank you.


Casey Schaufler
casey@schaufler-ca.com
