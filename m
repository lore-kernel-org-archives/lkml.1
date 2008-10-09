Return-Path: <linux-kernel-owner+w=401wt.eu-S1758116AbYJIHgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758116AbYJIHgR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 03:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755983AbYJIHgD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 03:36:03 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:46216 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755948AbYJIHgB (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 03:36:01 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: John Kacur <jkacur@gmail.com>
Cc: Bryan Wu <cooloney@kernel.org>, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org, Cliff Cai <cliff.cai@analog.com>
Subject: Re: Fwd: [PATCH 7/9] ASoC: Blackfin: I2S CPU DAI driver
In-Reply-To: Your message of "Thu, 09 Oct 2008 08:58:08 +0200."
             <520f0cf10810082358t274a46afy7d9c5bbc5ca56de7@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <1220516528-20301-1-git-send-email-cooloney@kernel.org> <1220516528-20301-8-git-send-email-cooloney@kernel.org> <20080904144343.GB32531@rakim.wolfsonmicro.main> <520f0cf10810082353r2694535evc3edbcb2b3c76796@mail.gmail.com>
            <520f0cf10810082358t274a46afy7d9c5bbc5ca56de7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1223537753_7177P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 09 Oct 2008 03:35:53 -0400
Message-ID: <38521.1223537753@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1223537753_7177P
Content-Type: text/plain; charset=us-ascii

On Thu, 09 Oct 2008 08:58:08 +0200, John Kacur said:

> My eyes fell upon this switch statement, probably I have similar
> criticisms as to what has already been said, but:
> 1. Surely the default case is also an -EINVAL
> 2. Why not let all the EINVALS fall through, it will shorten up the
> code, and IMO make it more readable, something like this?
> +       switch (fmt & SND_SOC_DAIFMT_MASTER_MASK) {
> +       case SND_SOC_DAIFMT_CBM_CFM: /* Passing Case */
> +               break;
> +       case SND_SOC_DAIFMT_CBS_CFS: /* Failing Cases */
> +       case SND_SOC_DAIFMT_CBM_CFS:
> +       case SND_SOC_DAIFMT_CBS_CFM:
> +               ret = -EINVAL;
> +               break;
> +       default:
> +               printk(KERN_INFO "Unknown SND_SOC_DAIFMT kind\n");
> +               ret = -EINVAL;
> +               break;
> +       }

Even shorter, but puts the default in a non-standard place:

+       switch (fmt & SND_SOC_DAIFMT_MASTER_MASK) {
+       case SND_SOC_DAIFMT_CBM_CFM: /* Passing Case */
+               break;
+       default:			/* So much Fail we should say something */
+               printk(KERN_INFO "Unknown SND_SOC_DAIFMT kind\n");
+       case SND_SOC_DAIFMT_CBS_CFS: /* Failing Cases */
+       case SND_SOC_DAIFMT_CBM_CFS:
+       case SND_SOC_DAIFMT_CBS_CFM:
+               ret = -EINVAL;
+               break;
+	}

(I see a checkpatch update to check where default: is, coming in 3.. 2.. 1.. :)


--==_Exmh_1223537753_7177P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFI7bRZcC3lWbTT17ARAmCBAJ0WnjsEdPPb/yVOCA7+c4RV3VWWWACeKniQ
ByWIBDPOxcKOcTLhH37kiOA=
=jy4h
-----END PGP SIGNATURE-----

--==_Exmh_1223537753_7177P--
