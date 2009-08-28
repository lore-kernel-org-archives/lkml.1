Return-Path: <linux-kernel-owner+w=401wt.eu-S1752795AbZH1M6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795AbZH1M6Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 08:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752595AbZH1M6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 08:58:23 -0400
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:57500 "EHLO
	QMTA05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752535AbZH1M6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 08:58:23 -0400
Message-ID: <4A97D471.5030100@byu.net>
Date: Fri, 28 Aug 2009 06:58:25 -0600
From: Eric Blake <ebb9@byu.net>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.23) Gecko/20090812 Thunderbird/2.0.0.23 Mnenhy/0.7.6.666
MIME-Version: 1.0
To: Florian Weimer <fweimer@bfk.de>
CC: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bug-coreutils@gnu.org, bug-gnulib@gnu.org,
       Ulrich Drepper <drepper@redhat.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] open: introduce O_NOSTD
References: <4A9285FC.8000606@byu.net>	<1251202593-3676-1-git-send-email-ebb9@byu.net>	<alpine.DEB.2.00.0908251420190.18518@makko.or.mcafeemobile.com>	<4A968FF8.8050109@byu.net> <82k50puxx8.fsf@mid.bfk.de>	<4A97D16D.5060003@byu.net> <82ocq0p0ba.fsf@mid.bfk.de>
In-Reply-To: <82ocq0p0ba.fsf@mid.bfk.de>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

According to Florian Weimer on 8/28/2009 6:52 AM:
>> If the caller requested O_CLOEXEC, then your version takes 3, 5, or
>> 7 syscalls depending on how many std fds were closed, while my
>> version takes 3 syscalls regardless of how many std fds were closed.
> 
> I really don't see a way around that.  You can't pick a descriptor and
> hope that it's unused.

fcntl(,F_DUPFD,3) is NOT like dup2.  It picks the next available
descriptor that is at least 3.

- --
Don't work too hard, make some time for fun as well!

Eric Blake             ebb9@byu.net
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (Cygwin)
Comment: Public key at home.comcast.net/~ericblake/eblake.gpg
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkqX1HEACgkQ84KuGfSFAYAzYQCgnwad5k39bZJqw3Wg1vMED/Fd
zjYAmwenJlImBUE33geRdHC6aoVSx7JG
=omNI
-----END PGP SIGNATURE-----
