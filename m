Return-Path: <linux-kernel-owner+w=401wt.eu-S1756827AbYJ3Qqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827AbYJ3Qqw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 12:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755627AbYJ3Qqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 12:46:35 -0400
Received: from threatwall.zlynx.org ([199.45.143.218]:36370 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755545AbYJ3Qqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 12:46:34 -0400
Message-ID: <4909E4DE.30207@acm.org>
Date: Thu, 30 Oct 2008 10:46:22 -0600
From: Zan Lynx <zlynx@acm.org>
User-Agent: Thunderbird 2.0.0.17 (Macintosh/20080914)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, jack@suse.cz
Subject: Re: 2.6.28-rc2-mm1: Build failure on fs/quota.o
References: <20081028233836.8b1ff9ae.akpm@linux-foundation.org>	<4908EA82.8090308@acm.org> <20081029161626.1fa5acb0.akpm@linux-foundation.org>
In-Reply-To: <20081029161626.1fa5acb0.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Envelope-From: zlynx@acm.org
X-Spam-Id: 20081030/1Kvaf8-0002Cv-OT-linux-kernel@vger.kernel.org:zlynx@acm.org:199.45.143.218
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Andrew Morton wrote:
> diff -puN include/linux/quotaops.h~quota-permit-separately-enabling-quota-accounting-and-enforcing-limits-fix include/linux/quotaops.h
> --- a/include/linux/quotaops.h~quota-permit-separately-enabling-quota-accounting-and-enforcing-limits-fix
> +++ a/include/linux/quotaops.h
> @@ -257,6 +257,11 @@ static inline int sb_any_quota_loaded(st
>  	return 0;
>  }
>  
> +static inline int sb_has_quota_active(struct super_block *sb, int type)
> +{
> +	return 0;
> +}
> +
>  static inline int sb_any_quota_active(struct super_block *sb)
>  {
>  	return 0;
> _
> 

Thank you.  This fixed the compilation error.

Now I can boot up to the point where the root filesystem fails to load.

No Reiser4 in this -mm.  I see that the old prepare and commit functions
were removed in 2.6.28.  Hopefully someone will fix Reiser4 so I don't
have to try doing it myself. :-)
- --
Zan Lynx
zlynx@acm.org

"Knowledge is Power.  Power Corrupts.  Study Hard.  Be Evil."
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkkJ5N0ACgkQolqWs/Y4NLyAtgCfdvhEF5x/80NLC9d/9jNTL1J2
DTYAoIDo+djCOleYRtt4+WSzIEFqgrnK
=Kr6s
-----END PGP SIGNATURE-----
