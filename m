Return-Path: <linux-kernel-owner+w=401wt.eu-S1757016AbZDDSL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757016AbZDDSL6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 14:11:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752227AbZDDSLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 14:11:50 -0400
Received: from twinlark.arctic.org ([208.69.40.136]:56128 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbZDDSLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 14:11:49 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sat, 04 Apr 2009 14:11:49 EDT
Message-ID: <49D7A11A.8010801@kernel.org>
Date: Sat, 04 Apr 2009 11:04:10 -0700
From: "Andrew G. Morgan" <morgan@kernel.org>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: linux-security-module@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
       James Morris <jmorris@namei.org>,
       Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH] don't raise all privs on setuid-root file with fE set
 (v2)
References: <20090402234714.GA2220@us.ibm.com>
In-Reply-To: <20090402234714.GA2220@us.ibm.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Serge E. Hallyn wrote:
> Distributions face a backward compatibility problem with starting to use
> file capabilities.  For instance, removing setuid root from ping and
> doing setcap cap_net_raw=pe means that booting with an older kernel
> or one compiled without file capabilities means ping won't work for
> non-root users.
> 
> In order to replace the setuid root bit on a capability-unaware
> program, one has to set the effective, or legacy, file capability,
> which makes the capability effective immediately.  This patch
> uses the legacy bit as a queue to not automatically add full

s/queue/cue/

> privilege to a setuid-root program.
> 
> So, with this patch, an ordinary setuid-root program will run with
> privilege.  But if /bin/ping has both setuid-root and cap_net_raw in
> fP and fE, then ping (when run by non-root user) will not run
> with only cap_net_raw.

Acked-by: Andrew G. Morgan <morgan@kernel.org>

Cheers

Andrew
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFJ16EX+bHCR3gb8jsRAsHzAKChHDKjcjuptab+7K6i3xuwYHqQ5wCbBt4C
hodJP4i1y7rJUGAytQHiouw=
=7PGT
-----END PGP SIGNATURE-----
