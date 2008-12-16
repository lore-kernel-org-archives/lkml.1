Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1757878AbYLPW1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757878AbYLPW1L (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 17:27:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753691AbYLPW0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 17:26:55 -0500
Received: from ik-out-1112.google.com ([66.249.90.181]:9739 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684AbYLPW0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 17:26:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=DhJBUW3Ljjo2W45TBqJ1SnCbUjDoNVNX/aXQu/lFwD8tWs3fXnW9LvRE2ViFQg5LC0
         QGf8Ug9J2ic8EKuUlkiczXaL4jUnQyv5wYRUufZcpqFauqlB3Wben2r/4rcR/8xytKH5
         qSLQ8g+KIqtfYcm8kWeGAsG8Etaz55tZ2IsJs=
Message-ID: <dd18b0c30812161426l678b4bcx104efd63797c162d@mail.gmail.com>
Date: Tue, 16 Dec 2008 14:26:52 -0800
From: "Justin Mattock" <justinmattock@gmail.com>
To: SE-Linux <selinux@tycho.nsa.gov>, tresys <refpolicy@oss.tresys.com>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: ath9k capability=16 won't compile into policy
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not too sure if I should post this with SELinux,
refpolicy, or kernel.org,(or even wpasupplicant);
 so I decided to do all to the best of my knowledge.
when using the ath9k module with the latest git
kernel(or atleast a few days old); and the latest refpolicy (svn)
I'm seeing this avc denial show up:

Dec 16 12:33:32 name kernel: [   20.415785] type=1400
audit(1229459612.411:3): avc:  denied  { sys_module } for  pid=2510
comm="wpa_supplicant" capability=16
scontext=system_u:system_r:system_dbusd_t:s0
tcontext=system_u:system_r:system_dbusd_t:s0 tclass=capability
Dec 16 12:33:32 name kernel: [   20.428494] type=1300
audit(1229459612.411:3): arch=40000003 syscall=54 success=no exit=-19
a0=9 a1=8933 a2=bfadd94c a3=bfadd94c items=0 ppid=1 pid=2510
auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0
fsgid=0 tty=(none) ses=4294967295 comm="wpa_supplicant"
exe="/sbin/wpa_supplicant" subj=system_u:system_r:system_dbusd_t:s0
key=(null)

the allow rule is:(with ath9k module)
allow system_dbusd_t self:capability sys_module;
which in turn will be rejected by checkpolicy
(capability 16)
when compiling the policy.

If I use the madwifi module the avc is similar but produces
allow system_dbusd_t self:capability { sys_admin }
(capability 12)
and will be accepted by checkpolicy.

As for setup I'm using NetworkManager from
intrepid as well as wpasupplicant

Any info would be appreciated so I can test this module out
and feel better knowing the module is not being denied in any
way, that might cause a false positive, or some other weirdness.


regards;
-- 
Justin P. Mattock
