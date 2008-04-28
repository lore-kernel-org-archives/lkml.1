Return-Path: <linux-kernel-owner+w=401wt.eu-S933588AbYD1KDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933588AbYD1KDy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 06:03:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762992AbYD1KDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 06:03:44 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:44792 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755248AbYD1KDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 06:03:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:references:in-reply-to:cc:mime-version:content-type:content-transfer-encoding:message-id;
        b=KHRiW9c92G43s+ZUDmiRVHy9gWFDV0ZiiPM/uNatGClzNoeyLCovF47gePJMT1YBiFAl1l6pytj9TOhA6SktOraQtuyf1RcnMXFZBHVNUuaoxUmtUq3IeOYvCfkddNhb66itVl4AO5RAf1HzWhk2wpuTACJ1PWMPu7Wp8nbR/vM=
From: Daniel Klaffenbach <danielklaffenbach@gmail.com>
To: Len Brown <lenb@kernel.org>
Subject: Re: [2.6.25-stable PATCH] regression: powertop says 120K wakeups/sec
Date: Mon, 28 Apr 2008 12:09:47 +0200
User-Agent: KMail/1.9.9
References: <200804242015.19462.lenb@kernel.org>
In-Reply-To: <200804242015.19462.lenb@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       venkatesh.pallipadi@intel.com
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3129415.DJzEZSymnR";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200804281209.47927.danielklaffenbach@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3129415.DJzEZSymnR
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

> commit 0fda6b403f0eca66ad8a7c946b3996e359100443
>
> Patch to fix huge number of wakeups reported due to recent changes in
> processor_idle.c. The problem was that the entry_method determination was
> broken due to one of the recent commits (bc71bec91f987) causing
> C1 entry to not to go to halt.
>
> http://lkml.org/lkml/2008/3/22/124
>
> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> Signed-off-by: Len Brown <len.brown@intel.com>
OK, this fixes my issue with the massive amount of wakeups:
http://lkml.org/lkml/2008/4/24/70

However the CPU does not really go to C1 or C2 after applying this patch to=
=20
the latest git kernel:

Cn                Avg residency       P-states (frequencies)
C0 (cpu running)        (99,4%)         1,80 Ghz     0,0%
C1                0,0ms ( 0,0%)         1,60 Ghz     0,0%
C2                0,0ms ( 0,6%)          800 Mhz   100,0%

=2D Daniel

--nextPart3129415.DJzEZSymnR
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBIFaJrM8RD99ZskA8RAnwsAJ9dJFMYybFlYXS8N7bWDLK+1Wo/7wCeOl4l
1baAPQDgPPvfrgWJOOG/2f4=
=UVCY
-----END PGP SIGNATURE-----

--nextPart3129415.DJzEZSymnR--
