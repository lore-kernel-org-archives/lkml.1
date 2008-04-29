Return-Path: <linux-kernel-owner+w=401wt.eu-S1758999AbYD2SGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758999AbYD2SGA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 14:06:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758206AbYD2SF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 14:05:28 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:46265 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758203AbYD2SF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 14:05:27 -0400
Date: Tue, 29 Apr 2008 20:06:01 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Timur Tabi <timur@freescale.com>, Tony Breeds <tony@bakeyournoodle.com>,
       linux-kernel@vger.kernel.org
Subject: Re: cross-compiling on OS X, make menuconfig fails
Message-ID: <20080429180601.GA19652@uranus.ravnborg.org>
References: <481529B6.6030802@freescale.com> <20080428015151.GW20457@bakeyournoodle.com> <481739BF.8010305@freescale.com> <20080429164535.GB18018@uranus.ravnborg.org> <20080429172057.GN5882@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429172057.GN5882@ZenIV.linux.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Good grief, folks...

Thanks Al.
I've queued up the following patch.

	Sam

commit c99cc32e0d92f5fdbdd39a7f42cfff869062fff5
Author: Sam Ravnborg <sam@uranus.ravnborg.org>
Date:   Tue Apr 29 20:02:44 2008 +0200

    kconfig: made check-lxdialog more portable
    
    OS-X shell did not like 'echo -e' so implement
    suggestion from Al Viro to use a more portable construct.
    
    Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
    Cc: Al Viro <viro@ZenIV.linux.org.uk>

diff --git a/scripts/kconfig/lxdialog/check-lxdialog.sh b/scripts/kconfig/lxdialog/check-lxdialog.sh
index 62e1e02..5552154 100644
--- a/scripts/kconfig/lxdialog/check-lxdialog.sh
+++ b/scripts/kconfig/lxdialog/check-lxdialog.sh
@@ -36,8 +36,10 @@ trap "rm -f $tmp" 0 1 2 3 15
 
 # Check if we can link to ncurses
 check() {
-	echo -e " #include CURSES_LOC \n main() {}" |
-	    $cc -xc - -o $tmp 2> /dev/null
+        $cc -xc - -o $tmp 2>/dev/null <<'EOF'
+#include CURSES_LOC
+main() {}
+EOF
 	if [ $? != 0 ]; then
 	    echo " *** Unable to find the ncurses libraries or the"       1>&2
 	    echo " *** required header files."                            1>&2
