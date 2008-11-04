Return-Path: <linux-kernel-owner+w=401wt.eu-S1754468AbYKDXkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468AbYKDXkM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 18:40:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755312AbYKDXh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 18:37:59 -0500
Received: from ns1.suse.de ([195.135.220.2]:47228 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757122AbYKDXh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 18:37:57 -0500
Date: Tue, 4 Nov 2008 15:31:13 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Evgeniy Manachkin <sfstudio@mail.ru>,
       Alan Cox <alan@redhat.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: [patch 08/57] kbuild: mkspec - fix build rpm
Message-ID: <20081104233113.GI659@suse.de>
References: <20081104232144.186593464@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="kbuild-mkspec-fix-build-rpm.patch"
In-Reply-To: <20081104233028.GA659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Evgeniy Manachkin <sfstudio@mail.ru>

commit 46dca86cb93db80992a45e4b55737ff2b2f61cd0 upstream
Date: Wed, 15 Oct 2008 23:37:26 +0600
Subject: [patch 08/57] kbuild: mkspec - fix build rpm

This is patch to fix incorrect mkspec script to make rpm correctly at 2.6.27 vanilla kernel.
This is regression in 2.6.27. 2.6.26 make rpm work good.
In 2.6.27 'make rpm' say error from rpmbuild "Many unpacked files (*.fw)."

Signed-off-by: Evgeniy Manachkin <sfstudio@mail.ru>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 scripts/package/mkspec |    3 +++
 1 file changed, 3 insertions(+)

--- a/scripts/package/mkspec
+++ b/scripts/package/mkspec
@@ -64,8 +64,10 @@ fi
 echo "%install"
 echo "%ifarch ia64"
 echo 'mkdir -p $RPM_BUILD_ROOT/boot/efi $RPM_BUILD_ROOT/lib/modules'
+echo 'mkdir -p $RPM_BUILD_ROOT/lib/firmware'
 echo "%else"
 echo 'mkdir -p $RPM_BUILD_ROOT/boot $RPM_BUILD_ROOT/lib/modules'
+echo 'mkdir -p $RPM_BUILD_ROOT/lib/firmware'
 echo "%endif"
 
 echo 'INSTALL_MOD_PATH=$RPM_BUILD_ROOT make %{_smp_mflags} modules_install'
@@ -92,5 +94,6 @@ echo "%files"
 echo '%defattr (-, root, root)'
 echo "%dir /lib/modules"
 echo "/lib/modules/$KERNELRELEASE"
+echo "/lib/firmware"
 echo "/boot/*"
 echo ""

-- 
