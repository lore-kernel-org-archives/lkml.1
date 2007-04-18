Return-Path: <linux-kernel-owner+w=401wt.eu-S2992644AbXDROgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992644AbXDROgA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 10:36:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992646AbXDROf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 10:35:59 -0400
Received: from pat.uio.no ([129.240.10.15]:34848 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992644AbXDROf6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 10:35:58 -0400
Subject: Re: [Devel] Re: [patch 05/10] add "permit user mounts in new
	namespace" clone flag
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: ebiederm@xmission.com, serue@us.ibm.com, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, viro@ftp.linux.org.uk,
       containers@lists.osdl.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <E1HeAkl-000490-00@dorka.pomaz.szeredi.hu>
References: <20070412164620.588752236@szeredi.hu>
	 <20070412203208.GG27772@sergelap.austin.ibm.com>
	 <m1mz1cq3v6.fsf@ebiederm.dsl.xmission.com>
	 <1176713221.9488.17.camel@ram.us.ibm.com>
	 <E1HdNZn-0006i9-00@dorka.pomaz.szeredi.hu>
	 <1176716941.9488.57.camel@ram.us.ibm.com>
	 <E1HdNwV-0006l2-00@dorka.pomaz.szeredi.hu>
	 <m18xcsl3yc.fsf@ebiederm.dsl.xmission.com>
	 <E1HdTag-0007bd-00@dorka.pomaz.szeredi.hu>
	 <m1zm58jfj3.fsf@ebiederm.dsl.xmission.com>
	 <20070416195652.GA350@sergelap.austin.ibm.com>
	 <m1k5wbjrsh.fsf@ebiederm.dsl.xmission.com>
	 <E1HdlYr-00015O-00@dorka.pomaz.szeredi.hu>
	 <m1zm56j27m.fsf@ebiederm.dsl.xmission.com>
	 <E1HdsX6-0002Kl-00@dorka.pomaz.szeredi.hu>
	 <m1vefuixp5.fsf@ebiederm.dsl.xmission.com>
	 <E1He6C7-0003Xu-00@dorka.pomaz.szeredi.hu>
	 <1176904505.6796.79.camel@heimdal.trondhjem.org>
	 <E1HeAkl-000490-00@dorka.pomaz.szeredi.hu>
Content-Type: text/plain
Date: Wed, 18 Apr 2007 10:26:29 -0400
Message-Id: <1176906389.6796.96.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.057)
X-UiO-Scanned: 2DAB06528412A8C0205DCE63D6D79A2D32356145
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 984 total 1163193 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-18 at 16:03 +0200, Miklos Szeredi wrote:
> > Don't forget that almost all mount flags are per-superblock. How are you
> > planning on dealing with the case that one user mounts a filesystem
> > read-only, while another is trying to mount the same one read-write?
> 
> Yeah, I forgot, the per-mount read-only patches are not yet in.
> 
> That doesn't really change my agrument though.  _If_ the flag is per
> mount, then it makes sense to be able to change it on a master and not
> on a slave.  If mount flags are propagated, this is not possible.

Read-only isn't the only issue. On something like NFS, there are flags
to set the security flavour, turn on/off encryption etc.

If I mount your home directory using no encryption in my namespace, for
instance, then neither you nor the administrator will be able to turn it
on afterwards in yours without first unmounting it from mine so that the
superblock is destroyed.

Cheers
  Trond

