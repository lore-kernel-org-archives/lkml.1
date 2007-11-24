Return-Path: <linux-kernel-owner+w=401wt.eu-S1754612AbXKXRQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612AbXKXRQx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 12:16:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752550AbXKXRQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 12:16:45 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:48833 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752024AbXKXRQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 12:16:44 -0500
Date: Sat, 24 Nov 2007 18:16:31 +0100
From: Adrian Bunk <bunk@kernel.org>
To: sfrench@samba.org
Cc: linux-cifs-client@lists.samba.org, linux-kernel@vger.kernel.org
Subject: fs/cifs/cifsacl.c: check-after-use
Message-ID: <20071124171631.GA6835@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The Coverity checker spotted the following check-after-use in 
fs/cifs/cifsacl.c:

<--  snip  -->

...
static void parse_dacl(struct cifs_acl *pdacl, char *end_of_acl,
                       struct cifs_sid *pownersid, struct cifs_sid *pgrpsid,
                       struct inode *inode)
{
...
        if (end_of_acl < (char *)pdacl + le16_to_cpu(pdacl->size)) {
...                                                  ^^^^^^^^^^^
        if (!pdacl) {
...

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

