Return-Path: <linux-kernel-owner+w=401wt.eu-S1761910AbXH3AwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761910AbXH3AwS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 20:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758599AbXH3AwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 20:52:09 -0400
Received: from twinlark.arctic.org ([207.29.250.54]:40180 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758101AbXH3AwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 20:52:07 -0400
Message-ID: <46D614AF.8070206@kernel.org>
Date: Wed, 29 Aug 2007 17:51:59 -0700
From: Andrew Morgan <morgan@kernel.org>
User-Agent: Thunderbird 2.0.0.6 (Macintosh/20070728)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serge@hallyn.com>
CC: Adrian Bunk <bunk@kernel.org>, sds@tycho.nsa.gov, chrisw@sous-sol.org,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [2.6 patch] remove securebits
References: <20070824210649.GG30705@stusta.de> <20070824211942.GA24478@vino.hallyn.com> <46CFA6F2.9030209@kernel.org> <20070825182846.GN30705@stusta.de> <20070827150941.GA31042@vino.hallyn.com> <20070827151751.GD4121@stusta.de> <20070827152817.GA31632@vino.hallyn.com> <20070827155855.GE4121@stusta.de> <46D3CCBA.1020204@kernel.org> <20070828181959.GA24270@vino.hallyn.com>
In-Reply-To: <20070828181959.GA24270@vino.hallyn.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Serge E. Hallyn wrote:
> To summarize more clearly, I think that so long as we support
> process trees with a sort of !SECURE_NOROOT support, that
> support should include the ability to use prctl(KEEP_CAPS) the
> way one uses it now.

> When a process tree is in strict capability mode,
> prctl(PR_{G,S}ET_KEEP_CAPS) should return -EINVAL.

I agree. I'll try to code it up in a way that its clear how to delete
this functionality when folk realize they no longer need it...

- -static inline int get_file_caps(struct linux_binprm *bprm)
+int cap_bprm_set_security(struct linux_binprm *bprm)
 {
 	bprm_clear_caps(bprm);
+	bprm_force_uid0_caps(bprm);
+	current->keep_capabilities = 0;

> This is being moved from bprm_apply to bprm_set, which moves it
> earlier.  If exec fails later on, keep_capabilities might be set
> to 0 even though exec failed.

I'll look at it again, but I had thought I had preserved the previous
behavior with this condensed version of the code. Are you suggesting an
improvement to what was there, or pointing out I'm inadvertently
breaking the old behavior?

Thanks

Andrew
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFG1hSu+bHCR3gb8jsRAhHJAJ9Pn8w2InrhbNjBjpqT9NEE0HX61QCgkBR8
Bo1xJcZGqbsr+IhQ+DDyENA=
=PKx4
-----END PGP SIGNATURE-----
