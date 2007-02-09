Return-Path: <linux-kernel-owner+w=401wt.eu-S1423038AbXBIRWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423038AbXBIRWk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 12:22:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423143AbXBIRWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 12:22:40 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:48860 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423038AbXBIRWj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 12:22:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:sender;
        b=oldIYUAJEIgO8zRXfoR//xbE0z35/oMdSJmpMQ8pdl7RpzS9/pY/o6+BH3gAEOdmAZ8i9IotjUFleNDMlQakDU88VHbJftTY508lVHi4fBFY4MYMlX7lwTpdcuKbB/4dr21+zsLN6tTkVSTPpR6ZuQcm2G25FvpGCtq5ItJfAcI=
From: Alon Bar-Lev <alonbl@opensc-project.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH 00/34] __initdata cleanup
Date: Fri, 9 Feb 2007 19:25:02 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, bwalle@suse.de,
       rmk+lkml@arm.linux.org.uk, spyro@f2s.com, davej@codemonkey.org.uk,
       hpa@zytor.com, Riley@williams.name, tony.luck@intel.com,
       geert@linux-m68k.org, zippel@linux-m68k.org, ralf@linux-mips.org,
       matthew@wil.cx, grundler@parisc-linux.org, kyle@parisc-linux.org,
       paulus@samba.org, schwidefsky@de.ibm.com, lethal@linux-sh.org,
       davem@davemloft.net, uclinux-v850@lsi.nec.co.jp, ak@muc.de,
       vojtech@suse.cz, chris@zankel.net, len.brown@intel.com, lenb@kernel.org,
       herbert@gondor.apana.org.au, viro@zeniv.linux.org.uk,
       bzolnier@gmail.com, dmitry.torokhov@gmail.com, dtor@mail.ru,
       jgarzik@pobox.com, linux-mm@kvack.org, dwmw2@infradead.org,
       patrick@tykepenguin.com, kuznet@ms2.inr.ac.ru, pekkas@netcore.fi,
       jmorris@namei.org, philb@gnu.org, tim@cyberelk.net, andrea@suse.de,
       ambx1@neo.rr.com, James.Bottomley@steeleye.com,
       linux-serial@vger.kernel.org
References: <200702091711.34441.alon.barlev@gmail.com> <20070209170005.GA8500@osiris.ibm.com>
In-Reply-To: <20070209170005.GA8500@osiris.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Message-Id: <200702091925.03314.alonbl@opensc-project.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 February 2007, Heiko Carstens wrote:
> And the top-level Makefile has:
> 
> CFLAGS          := -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs \
>                    -fno-strict-aliasing -fno-common
> 
> Note the -fno-common.
> 
> And indeed all the __initdata annotated local and global variables on
> s390 are in the init.data section. So I'm wondering what this patch
> series is about. Or I must have missed something.
> 

Hmmm... You have a valid point!
So it reduces the patch to the following.
>From the previous discussion I was afraid that I added some invalid variables.

Thanks!

Best Regards,
Alon Bar-Lev.

---

diff -urNp linux-2.6.20-rc6-mm3.org/arch/x86_64/kernel/e820.c linux-2.6.20-rc6-mm3/arch/x86_64/kernel/e820.c
--- linux-2.6.20-rc6-mm3.org/arch/x86_64/kernel/e820.c
+++ linux-2.6.20-rc6-mm3/arch/x86_64/kernel/e820.c
@@ -402,10 +402,10 @@ static int __init sanitize_e820_map(stru
 		struct e820entry *pbios; /* pointer to original bios entry */
 		unsigned long long addr; /* address for this change point */
 	};
-	static struct change_member change_point_list[2*E820MAX] __initdata;
-	static struct change_member *change_point[2*E820MAX] __initdata;
-	static struct e820entry *overlap_list[E820MAX] __initdata;
-	static struct e820entry new_bios[E820MAX] __initdata;
+	static struct change_member change_point_list[2*E820MAX] __initdata = {{0}};
+	static struct change_member *change_point[2*E820MAX] __initdata = {0};
+	static struct e820entry *overlap_list[E820MAX] __initdata = {0};
+	static struct e820entry new_bios[E820MAX] __initdata = {{0}};
 	struct change_member *change_tmp;
 	unsigned long current_type, last_type;
 	unsigned long long last_addr;
diff -urNp linux-2.6.20-rc6-mm3.org/fs/nfs/nfsroot.c linux-2.6.20-rc6-mm3/fs/nfs/nfsroot.c
--- linux-2.6.20-rc6-mm3.org/fs/nfs/nfsroot.c	2007-01-25 04:19:28.000000000 +0200
+++ linux-2.6.20-rc6-mm3/fs/nfs/nfsroot.c	2007-01-31 22:19:30.000000000 +0200
@@ -289,7 +289,7 @@ static int __init root_nfs_parse(char *n
  */
 static int __init root_nfs_name(char *name)
 {
-	static char buf[NFS_MAXPATHLEN] __initdata;
+	static char buf[NFS_MAXPATHLEN] __initdata = { 0, };
 	char *cp;
 
 	/* Set some default values */
diff -urNp linux-2.6.20-rc6-mm3.org/init/main.c linux-2.6.20-rc6-mm3/init/main.c
--- linux-2.6.20-rc6-mm3.org/init/main.c	2007-01-31 22:15:41.000000000 +0200
+++ linux-2.6.20-rc6-mm3/init/main.c	2007-01-31 22:19:30.000000000 +0200
@@ -470,7 +470,7 @@ static int __init do_early_param(char *p
 void __init parse_early_param(void)
 {
 	static __initdata int done = 0;
-	static __initdata char tmp_cmdline[COMMAND_LINE_SIZE];
+	static __initdata char tmp_cmdline[COMMAND_LINE_SIZE] = "";
 
 	if (done)
 		return;
diff -urNp linux-2.6.20-rc6-mm3.org/drivers/input/keyboard/amikbd.c linux-2.6.20-rc6-mm3/drivers/input/keyboard/amikbd.c
--- linux-2.6.20-rc6-mm3.org/drivers/input/keyboard/amikbd.c	2007-01-25 04:19:28.000000000 +0200
+++ linux-2.6.20-rc6-mm3/drivers/input/keyboard/amikbd.c	2007-01-31 22:19:30.000000000 +0200
@@ -215,7 +215,7 @@ static int __init amikbd_init(void)
 		set_bit(i, amikbd_dev->keybit);
 
 	for (i = 0; i < MAX_NR_KEYMAPS; i++) {
-		static u_short temp_map[NR_KEYS] __initdata;
+		static u_short temp_map[NR_KEYS] __initdata = {0};
 		if (!key_maps[i])
 			continue;
 		memset(temp_map, 0, sizeof(temp_map));
