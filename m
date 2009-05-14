Return-Path: <linux-kernel-owner+w=401wt.eu-S1753310AbZENPym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbZENPym (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 11:54:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751718AbZENPyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 11:54:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:37370 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486AbZENPyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 11:54:32 -0400
Subject: Re: Next May 13:[drivers/base/firmware*] Bug while booting on x86
From: David Woodhouse <dwmw2@infradead.org>
To: Sachin Sant <sachinp@in.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
In-Reply-To: <4A0AC5E6.2010402@in.ibm.com>
References: <20090513164832.c8a0de7d.sfr@canb.auug.org.au>
	 <4A0AC5E6.2010402@in.ibm.com>
Content-Type: text/plain
Date: Thu, 14 May 2009 16:54:27 +0100
Message-Id: <1242316467.3393.14.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 (2.26.1-2.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-13 at 18:36 +0530, Sachin Sant wrote:
> BUG: unable to handle kernel NULL pointer dereference at 0000050c
> IP: [<c0119c5d>] kunmap+0x33/0x59

Oops. Does this fix it?

--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -328,7 +328,7 @@ firmware_data_write(struct kobject *kobj, struct
bin_attribute *bin_attr,
 
 		memcpy(page_data + page_ofs, buffer, page_cnt);
 
-		kunmap(page_data);
+		kunmap(fw_priv->pages[page_nr]);
 		buffer += page_cnt;
 		offset += page_cnt;
 		count -= page_cnt;

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

