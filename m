Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752336AbYLRQp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336AbYLRQp2 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 11:45:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751185AbYLRQpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 11:45:10 -0500
Received: from mx2.redhat.com ([66.187.237.31]:45490 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771AbYLRQpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 11:45:08 -0500
Message-ID: <494A7E0D.6050200@redhat.com>
Date: Thu, 18 Dec 2008 11:45:01 -0500
From: Daniel J Walsh <dwalsh@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Justin Mattock <justinmattock@gmail.com>
CC: SE-Linux <selinux@tycho.nsa.gov>, tresys <refpolicy@oss.tresys.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [refpolicy] ath9k capability=16 won't compile into policy
References: <dd18b0c30812161426l678b4bcx104efd63797c162d@mail.gmail.com>
In-Reply-To: <dd18b0c30812161426l678b4bcx104efd63797c162d@mail.gmail.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Justin Mattock wrote:
> I'm not too sure if I should post this with SELinux,
> refpolicy, or kernel.org,(or even wpasupplicant);
>  so I decided to do all to the best of my knowledge.
> when using the ath9k module with the latest git
> kernel(or atleast a few days old); and the latest refpolicy (svn)
> I'm seeing this avc denial show up:
> 
> Dec 16 12:33:32 name kernel: [   20.415785] type=1400
> audit(1229459612.411:3): avc:  denied  { sys_module } for  pid=2510
> comm="wpa_supplicant" capability=16
> scontext=system_u:system_r:system_dbusd_t:s0
> tcontext=system_u:system_r:system_dbusd_t:s0 tclass=capability
> Dec 16 12:33:32 name kernel: [   20.428494] type=1300
> audit(1229459612.411:3): arch=40000003 syscall=54 success=no exit=-19
> a0=9 a1=8933 a2=bfadd94c a3=bfadd94c items=0 ppid=1 pid=2510
> auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0
> fsgid=0 tty=(none) ses=4294967295 comm="wpa_supplicant"
> exe="/sbin/wpa_supplicant" subj=system_u:system_r:system_dbusd_t:s0
> key=(null)
> 
> the allow rule is:(with ath9k module)
> allow system_dbusd_t self:capability sys_module;
> which in turn will be rejected by checkpolicy
> (capability 16)
> when compiling the policy.
> 
> If I use the madwifi module the avc is similar but produces
> allow system_dbusd_t self:capability { sys_admin }
> (capability 12)
> and will be accepted by checkpolicy.
> 
> As for setup I'm using NetworkManager from
> intrepid as well as wpasupplicant
> 
> Any info would be appreciated so I can test this module out
> and feel better knowing the module is not being denied in any
> way, that might cause a false positive, or some other weirdness.
> 
> 
> regards;
We label wpa_supplicant as NetworkManager_exec_t and have dbus
transition to this domain.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iEYEARECAAYFAklKfg0ACgkQrlYvE4MpobPltQCfbcRlboJohHcUaUaASFMbj1LK
/9AAoNPuDJuPv3B4tpikLzsjUPYCUe4I
=Nozo
-----END PGP SIGNATURE-----
