Return-Path: <linux-kernel-owner+w=401wt.eu-S1763952AbXF1GKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763952AbXF1GKo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 02:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762953AbXF1GKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 02:10:34 -0400
Received: from twinlark.arctic.org ([207.29.250.54]:34960 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762779AbXF1GKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 02:10:31 -0400
Message-ID: <468350D1.9010902@kernel.org>
Date: Wed, 27 Jun 2007 23:10:25 -0700
From: Andrew Morgan <morgan@kernel.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070531)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: Chris Wright <chrisw@sous-sol.org>, Andrew Morgan <agm@google.com>,
       casey@schaufler-ca.com, Andrew Morton <akpm@google.com>,
       Stephen Smalley <sds@tycho.nsa.gov>, KaiGai Kohei <kaigai@kaigai.gr.jp>,
       James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] file capabilities: get_file_caps cleanups
References: <20070628002041.GA10429@sergelap.austin.ibm.com>
In-Reply-To: <20070628002041.GA10429@sergelap.austin.ibm.com>
X-Enigmail-Version: 0.94.3.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

This contains a typo:

Serge E. Hallyn wrote:
>>From 588755d9498c87c4e963527ba0f49c11107de354 Mon Sep 17 00:00:00 2001
> From: Serge E. Hallyn <serue@us.ibm.com>
> Date: Wed, 27 Jun 2007 19:55:27 -0400
> Subject: [PATCH 1/1] file capabilities: get_file_caps cleanups
> 
> Two cleanups relating to set_file caps.
[...]
> @@ -187,12 +186,21 @@ out:
>  	dput(dentry);
>  	if ((void *)dcaps != (void *)&v1caps)
>  		kfree(dcaps);
Move this two lines down (rc defaults to 0 in goto above):
from here-->
> +clear_caps:
> +	if (rc) {
to here-->
> +		cap_clear (bprm->cap_inheritable);
> +		cap_clear (bprm->cap_permitted);
> +		cap_clear (bprm->cap_effective);
> +	}
>  	return rc;

Cheers

Andrew

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQFGg1DNQheEq9QabfIRApNqAJ99rNMF4VU/FPOolDLHlXbbQ2MRMwCeO3Fy
8ze7XhlBuBKdHElbZmWFJ5Y=
=gAEK
-----END PGP SIGNATURE-----
