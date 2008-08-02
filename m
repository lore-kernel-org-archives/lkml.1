Return-Path: <linux-kernel-owner+w=401wt.eu-S1754575AbYHBWhB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575AbYHBWhB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 18:37:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712AbYHBWgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 18:36:53 -0400
Received: from jenny.ondioline.org ([66.220.1.122]:39148 "EHLO
	jenny.ondioline.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbYHBWgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 18:36:52 -0400
From: Paul Collins <paul@burly.ondioline.org>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-kernel@vger.kernel.org, nfsv4@linux-nfs.org, linuxppc-dev@ozlabs.org,
       Neil Brown <neilb@suse.de>
Subject: Re: nfsd, v4: oops in find_acceptable_alias, ppc32 Linux, post-2.6.27-rc1
References: <87tze38vzt.fsf@burly.wgtn.ondioline.org>
	<20080802184554.GB715@fieldses.org>
Date: Sun, 03 Aug 2008 10:36:51 +1200
In-Reply-To: <20080802184554.GB715@fieldses.org> (J. Bruce Fields's message of
	"Sat, 2 Aug 2008 14:45:54 -0400")
Message-ID: <87abfvm4cc.fsf@burly.wgtn.ondioline.org>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"J. Bruce Fields" <bfields@fieldses.org> writes:

> On Sun, Aug 03, 2008 at 12:03:18AM +1200, Paul Collins wrote:
>> I just got the oops below on a ppc32 NFS4 server.  I was cross-compiling
>> Linux with an amd64 client at the time.  The server is running Linus's
>> tree as of 94ad374a0751f40d25e22e036c37f7263569d24c, the client is
>> running 2.6.26.
>> 
>> The server's kernel was cross-compiled with gcc 4.2.4-3 and binutils
>> 2.18.50.20080610-1, both built from the Debian sources following their
>> toolchain-building procedures.
>
> Without having really thought about this,
>
> 	496d6c32d4d057cb44272d9bd587ff97d023ee92 "nfsd: fix spurious
> 	EACCESS in reconnect_path()"
>
> is one suspect; it might be worth checking whether the problem's
> reproduceable with that reverted.  But I assume we're not so lucky as to
> have a 100% reproduceable problem here?

Unknown.  I've kicked off a fresh build.  Here's hoping!

> What do your export options look like?

  $ cat /etc/exports
  /srv/nfsv4            *(sec=krb5:krb5i:krb5p,rw,fsid=0,crossmnt,insecure,no_subtree_check)
  /srv/nfsv4/home/paul  *(sec=krb5:krb5i:krb5p,rw,insecure,no_subtree_check)
  $ mount | grep bind
  /home/paul on /srv/nfsv4/home/paul type none (rw,bind)

-- 
Paul Collins
Wellington, New Zealand

Dag vijandelijk luchtschip de huismeester is dood
