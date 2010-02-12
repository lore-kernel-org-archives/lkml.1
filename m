Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab0BLVmG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 16:42:06 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:52272 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754589Ab0BLVmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 16:42:01 -0500
To: Greg KH <gregkh@suse.de>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       "Tejun Heo \<tj\@kernel.org\> Neil Brown" <neilb@suse.de>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] sysfs: Use sysfs_attr_init and sysfs_bin_attr_init on module dynamic attributes
References: <4B728CFE.40208@kernel.org> <m1sk992bji.fsf@fess.ebiederm.org>
	<20100210230544.GA678@suse.de> <m1ocjwwob1.fsf@fess.ebiederm.org>
	<4B73671E.2050105@kernel.org> <m1bpfvxt67.fsf_-_@fess.ebiederm.org>
	<m14olnxt3s.fsf_-_@fess.ebiederm.org>
	<m1ljezwean.fsf_-_@fess.ebiederm.org>
	<m1hbpnwe7i.fsf_-_@fess.ebiederm.org>
	<m1d40bwe5i.fsf_-_@fess.ebiederm.org> <20100211234221.GA10498@suse.de>
	<m1vde2vcxd.fsf_-_@fess.ebiederm.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 12 Feb 2010 13:41:56 -0800
In-Reply-To: <m1vde2vcxd.fsf_-_@fess.ebiederm.org> (Eric W. Biederman's message of "Fri\, 12 Feb 2010 04\:47\:10 -0800")
Message-ID: <m1fx56uo63.fsf_-_@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A little more whack-a-mole annotating the dynamic sysfs attributes.  I
had everything built into my earlier test kernel, and so I missed
these.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 kernel/module.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index e96b8ed..e7e94f7 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1080,6 +1080,7 @@ static void add_sect_attrs(struct module *mod, unsigned int nsect,
 		if (sattr->name == NULL)
 			goto out;
 		sect_attrs->nsections++;
+		sysfs_attr_init(&sattr->mattr.attr);
 		sattr->mattr.show = module_sect_show;
 		sattr->mattr.store = NULL;
 		sattr->mattr.attr.name = sattr->name;
@@ -1175,6 +1176,7 @@ static void add_notes_attrs(struct module *mod, unsigned int nsect,
 		if (!(sechdrs[i].sh_flags & SHF_ALLOC))
 			continue;
 		if (sechdrs[i].sh_type == SHT_NOTE) {
+			sysfs_bin_attr_init(nattr);
 			nattr->attr.name = mod->sect_attrs->attrs[loaded].name;
 			nattr->attr.mode = S_IRUGO;
 			nattr->size = sechdrs[i].sh_size;
@@ -1247,6 +1249,7 @@ int module_add_modinfo_attrs(struct module *mod)
 		if (!attr->test ||
 		    (attr->test && attr->test(mod))) {
 			memcpy(temp_attr, attr, sizeof(*temp_attr));
+			sysfs_attr_init(&temp_attr->attr);
 			error = sysfs_create_file(&mod->mkobj.kobj,&temp_attr->attr);
 			++temp_attr;
 		}
-- 
1.6.5.2.143.g8cc62

