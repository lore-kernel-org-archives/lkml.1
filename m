Return-Path: <linux-kernel-owner+w=401wt.eu-S1751761AbZL1Ov7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751761AbZL1Ov7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 09:51:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751483AbZL1Ov6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 09:51:58 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:56692 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbZL1Ov5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 09:51:57 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: serge@hallyn.com, serue@us.ibm.com, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: A basic question about the security_* hooks
In-Reply-To: Your message of "Mon, 28 Dec 2009 20:51:49 +0900."
             <200912282051.BIF64080.VOMtFOOLSHJFFQ@I-love.SAKURA.ne.jp>
From: Valdis.Kletnieks@vt.edu
References: <20091225055034.GA374@us.ibm.com> <20091226195043.GA1945@heat> <20091227031631.GA17629@hallyn.com> <200912271302.JBH64754.JtLMFQVOSOFFHO@I-love.SAKURA.ne.jp> <22669.1261911374@localhost>
            <200912282051.BIF64080.VOMtFOOLSHJFFQ@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1262011906_3923P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 28 Dec 2009 09:51:46 -0500
Message-ID: <9291.1262011906@localhost>
X-Mirapoint-Received-SPF: 128.173.34.103 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=zidane.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020208.4B38C603.0239,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1262011906_3923P
Content-Type: text/plain; charset=us-ascii

On Mon, 28 Dec 2009 20:51:49 +0900, Tetsuo Handa said:

(Hit send too soon)

> Both SELinux and TOMOYO have ability to cover all processes (from /sbin/init
> till /sbin/poweroff) or targeted processes (e.g. only daemons). But SELinux is
> not widely used for protecting all processes. TOMOYO can provide some
> protection for processes which SELinux doesn't protect.

OK, this was what I was talking about - what processes does TOMOYO protect
that SELinux doesn't?  Or are you suggesting "use TOMOYO when using the SELinux
'targeted' policy that only tracks some processes"?  It would seem that a better
solution there would be to just go ahead and use the 'strict' or 'mls' policies
if you want coverage of all processes - having some processes under SELinux
and some under TOMOYO rules is just asking for confusion...

> Also, people know we sometimes need to restrict string parameters for avoiding
> unwanted consequence. TOMOYO can pay attention to string parameters whereas
> SELinux can't.

Which string parameters are these?  Perhaps a better approach than trying to
layer all of TOMOYO on SELinux is to create a small targeted "look at string
parameters" LSM and run *that* on top. Would require LSM stacking, but so would
doing all of TOMOYO.


--==_Exmh_1262011906_3923P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLOMYCcC3lWbTT17ARAhQkAKCfCx8S///E6KWFgaspck4ao3FHWgCfa7L2
lPl0TyShPxgFLRprFm+ci5E=
=09Li
-----END PGP SIGNATURE-----

--==_Exmh_1262011906_3923P--

