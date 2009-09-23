Return-Path: <linux-kernel-owner+w=401wt.eu-S1752005AbZIWWbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005AbZIWWbe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 18:31:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751826AbZIWWbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 18:31:33 -0400
Received: from mail-yw0-f174.google.com ([209.85.211.174]:61437 "EHLO
	mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbZIWWbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 18:31:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZcbIawpk+Hh/CXscjZgLBdvXhQXopMwhD35VIV45lA1FrOiVzp+lxfcpDsi9CCd7zX
         KhebXx/KjA3OK3tXQvH6WNdl/yeBC6/VBhTjNiMIkdlJIQSkSSJMSS/tugTIcpPMDR+4
         JVgp/n9/m5nWhvfteUfSA2lT2x0FppH+RTi9A=
Date: Wed, 23 Sep 2009 22:31:10 +0000
From: Andy Spencer <andy753421@gmail.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Privilege dropping security module
Message-ID: <20090923223110.GA1449@c.hsd1.tn.comcast.net>
References: <20090923005644.GA28244@c.hsd1.tn.comcast.net>
 <4ABA892A.9090804@schaufler-ca.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_c-1550-1253745094-0001-2"
Content-Disposition: inline
In-Reply-To: <4ABA892A.9090804@schaufler-ca.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_c-1550-1253745094-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

> Hi Andy. Git is a wonderful tool, but if you want people to review
> your work you need to post patches.

Thanks for letting me know, I've posted a separate message with patch.


> And what do you propose as an interesting use case for dpriv?

I think the two most important things about dpriv is that it can be used
by ordinary users and that is can create policies programmatically.

Being able to use dpriv as a non root user is pretty strait forward. For
example, a user of a multi-user system may want to try some untrusted
code without risking access to the rest of the system:

  $ cd ~/my_project
  $ echo rxRX   /                > /sys/kernel/security/dpriv/stage
  $ echo X      $HOME            > /sys/kernel/security/dpriv/stage
  $ echo rwxRWX $HOME/my_project > /sys/kernel/security/dpriv/stage
  $ echo commit                  > /sys/kernel/security/dpriv/control
  $ patch < untrusted.patch
  $ make && ./src/some_exe

The above example also demonstrates how dpriv can be used
programmatically. That is, a policy for allowing read-write-exec access
to build and test tools in ~/my_project didn't have to exist ahead of
time.

A more realistic example might be for a virtual hosting web server where
you want apache to only have access to the files for the current virtual
host.

--=_c-1550-1253745094-0001-2
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkq6ocYACgkQz1OYJ/s1XTA+7ACfXLq1woc7IlG7FT04RrjgL7/X
TYYAnR18I+eAeTgpqP66naP1bRoS5Be1
=nLXJ
-----END PGP SIGNATURE-----

--=_c-1550-1253745094-0001-2--
