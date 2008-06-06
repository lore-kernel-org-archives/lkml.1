Return-Path: <linux-kernel-owner+w=401wt.eu-S933479AbYFFVva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933479AbYFFVva (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 17:51:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760010AbYFFVvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 17:51:21 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:39542 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756304AbYFFVvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 17:51:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=rPBfHsTPgRktwAubQqTKrYDZTuP4W9IvjalWuf9EOuuIIttcOdUblqCLJEIgaXZuyc
         PgojDPKW1e4PE/bawxBRBEGsdJCSg/0FMZDqxrJDhUxFmUZz6ffESIRKPMlgZF8SJJCW
         yvtU0IkckV/76ODQwnSu6ehUu9afw/Mwz4nPo=
Date: Sat, 7 Jun 2008 01:47:09 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: sam@ravnborg.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] make clean: remove *.o.* as well
Message-ID: <20080606214709.GA8680@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Those are left presumably from aborted ccache(1) compilations:

	arch/x86/kernel/.tmp_io_apic_64.o.T5veul
	arch/x86/kvm/.tmp_x86.o.SZWn69
	arch/x86/mm/.tmp_pgtable.o.sL1LTf
	drivers/ieee1394/.tmp_ieee1394_transactions.o.bUj6o1
	drivers/infiniband/hw/mlx4/.tmp_main.o.vy0ep6

BTW, with git there is nice way to check for such nuisainces:

	make mrproper
	git-ls-files -o

should give empty output.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 Makefile |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/Makefile
+++ b/Makefile
@@ -1133,7 +1133,8 @@ clean: archclean $(clean-dirs)
 	@find . $(RCS_FIND_IGNORE) \
 		\( -name '*.[oas]' -o -name '*.ko' -o -name '.*.cmd' \
 		-o -name '.*.d' -o -name '.*.tmp' -o -name '*.mod.c' \
-		-o -name '*.symtypes' -o -name 'modules.order' \) \
+		-o -name '*.symtypes' -o -name 'modules.order'	\
+		-o -name '*.o.*' \) \
 		-type f -print | xargs rm -f
 
 # mrproper - Delete all generated files, including .config

