Return-Path: <linux-kernel-owner+w=401wt.eu-S1757046AbYJ3QRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757046AbYJ3QRS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 12:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756856AbYJ3QQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 12:16:58 -0400
Received: from ik-out-1112.google.com ([66.249.90.177]:63792 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756674AbYJ3QQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 12:16:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=cdf/iWtIunaQLC1+Gj+583gT0VefzO/KCj1clGb/GZ1FaiQkeNM+Pp5W1xQ8EWIDg5
         5ePDHfDbhrentSzDvzpHWcguTqBdRp6sop+uZ/bZsflW6xqPisV00TfzGCI3EJD7VoWj
         C5Yav/0q5scYhuWtQ6NL5zpD/Ff7uGZq2E744=
Date: Thu, 30 Oct 2008 19:16:46 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Aristeu Rozanski <aris@redhat.com>
Subject: [RFC -tip] x86: nmi - add sensible names to nmi_watchdog boot param
Message-ID: <20081030161646.GC19888@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add sensible names as "lapic" and "ioapic" to
nmi_watchdog boot parameter. Sometimes it is not
that easy to recall what exactly nmi_watchdog=1
does mean so we allow the using of symbolic names here.

Old numeric values remain valid.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

 arch/x86/kernel/nmi.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/nmi.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/nmi.c	2008-10-27 21:35:21.000000000 +0300
+++ linux-2.6.git/arch/x86/kernel/nmi.c	2008-10-30 19:01:52.000000000 +0300
@@ -208,12 +208,17 @@ static int __init setup_nmi_watchdog(cha
 		++str;
 	}
 
-	get_option(&str, &nmi);
-
-	if (nmi >= NMI_INVALID)
-		return 0;
+	if (!strncmp(str, "lapic", 5))
+		nmi_watchdog = NMI_LOCAL_APIC;
+	else if (!strncmp(str, "ioapic", 6))
+		nmi_watchdog = NMI_IO_APIC;
+	else {
+		get_option(&str, &nmi);
+		if (nmi >= NMI_INVALID)
+			return 0;
+		nmi_watchdog = nmi;
+	}
 
-	nmi_watchdog = nmi;
 	return 1;
 }
 __setup("nmi_watchdog=", setup_nmi_watchdog);
