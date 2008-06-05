Return-Path: <linux-kernel-owner+w=401wt.eu-S1755866AbYFEJnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866AbYFEJnd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 05:43:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752904AbYFEJnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 05:43:24 -0400
Received: from mail.ocs.com.au ([202.134.241.204]:17963 "EHLO mail.ocs.com.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752713AbYFEJnY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 05:43:24 -0400
X-Greylist: delayed 1435 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Jun 2008 05:43:23 EDT
X-Mailer: exmh version 2.7.2 01/07/2005 (debian 1:2.7.2-12) with nmh-1.2
From: Keith Owens <kaos@ocs.com.au>
To: Sam Ravnborg <sam@ravnborg.org>
cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Paulo Marques <pmarques@grupopie.com>
Subject: Re: [RFC PATCH] drop support for KALLSYMS_EXTRA_PASS 
In-reply-to: Your message of "Tue, 03 Jun 2008 23:07:32 +0200."
             <20080603210732.GA6247@uranus.ravnborg.org> 
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Thu, 05 Jun 2008 19:19:24 +1000
Message-ID: <17789.1212657564@ocs10w>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg (on Tue, 3 Jun 2008 23:07:32 +0200) wrote:
>We have not seen any reports on inconsistent kallsysms data recently
>as in the last one or two years. At least I do not recall these
>and google had no hits in my searching.
>
>So I suggest removing this as to simplify the final linking.
>When doing "make allyesconfig" build this extra linking
>takes considerably time (and I usually forgoet to turn it off).
>
>In addition this patch removes the debug target: debug_kallsyms
>
>diff --git a/Makefile b/Makefile
>-define verify_kallsyms
>-	$(Q)$(if $($(quiet)cmd_sysmap),                                      \
>-	  echo '  $($(quiet)cmd_sysmap)  .tmp_System.map' &&)                \
>-	  $(cmd_sysmap) .tmp_vmlinux$(last_kallsyms) .tmp_System.map
>-	$(Q)cmp -s System.map .tmp_System.map ||                             \
>-		(echo Inconsistent kallsyms data;                            \
>-		 echo Try setting CONFIG_KALLSYMS_EXTRA_PASS;                \
>-		 rm .tmp_kallsyms* ; /bin/false )
>-endef

I am not happy about removing the check for inconsistent kallsyms data.
Changes to the tool chain could cause this problem to recur and we
would not pick up on it.  If we do keep the check for inconsistent data
then we still need some way for the user to continue while the problem
is investigated.

Since your real complaint seems to be the extra time taken in make
allyesconfig then the solution is easy.  Change CONFIG_KALLSYMS_EXTRA_PASS
to a Makefile option, KALLSYMS_EXTRA_PASS=y.  No extra time required in
make allyesconfig.

