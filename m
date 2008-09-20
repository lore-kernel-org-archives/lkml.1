Return-Path: <linux-kernel-owner+w=401wt.eu-S1753139AbYITRo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139AbYITRo3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 13:44:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750979AbYITRoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 13:44:21 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:58197 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbYITRoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 13:44:21 -0400
X-Greylist: delayed 1310 seconds by postgrey-1.27 at vger.kernel.org; Sat, 20 Sep 2008 13:44:20 EDT
Date: Sat, 20 Sep 2008 13:22:19 -0400
Message-Id: <200809201722.m8KHMJEJ024123@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linuxfoundation.org
CC: linux-kernel@vger.kernel.org
Subject: alloc_creds ignores gfp arg (MMOTM 2008-09-18-18-08)
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

alloc_creds (kernel/cred.c) takes a gfp arg, but ignores it and hardcodes
GFP_KERNEL.

Erez.


/*
 * Allocate new credentials
 */
struct cred *alloc_creds(const struct cred *old, gfp_t gfp)
{
	struct cred *new;

	new = kmem_cache_alloc(cred_jar, GFP_KERNEL);
	if (!new)
		return NULL;
	if (old)
		memcpy(new, old, sizeof(struct cred));
	return new;
}
