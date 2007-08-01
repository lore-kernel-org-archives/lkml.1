Return-Path: <linux-kernel-owner+w=401wt.eu-S1755164AbXHAVta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164AbXHAVta (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 17:49:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbXHAVtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 17:49:21 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:14570 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbXHAVtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 17:49:20 -0400
X-IronPort-AV: i="4.19,210,1183348800"; 
   d="scan'208"; a="47145458:sNHT31780833"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Greg KH" <gregkh@suse.de>
Subject: debugfs helper for decimal challenged
Date: Wed, 1 Aug 2007 17:52:58 -0400
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708011752.58481.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 01 Aug 2007 21:49:09.0463 (UTC) FILETIME=[CA63DE70:01C7D485]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg:

For those of us who forget that when bits 21 and bit 31 in a hardware 
register exposed with debugfs, I should see 2149580800 when I cat it (vs
0x80200000), any objections to providing a hex output interface to the 
debugfs?

Since the input side already takes decimal & hex, I don't think this is a big
change:

DEFINE_SIMPLE_ATTRIBUTE(fops_x16, debugfs_u16_get, debugfs_u16_set, "0x%04llx\n");

struct dentry *debugfs_create_x16(const char *name, mode_t mode,
                                  struct dentry *parent, u16 *value)
{
        return debugfs_create_file(name, mode, parent, value, &fops_x16);
}

DEFINE_SIMPLE_ATTRIBUTE(fops_x32, debugfs_u32_get, debugfs_u32_set, "0x%08llx\n");

struct dentry *debugfs_create_x32(const char *name, mode_t mode,
                                  struct dentry *parent, u32 *value)
{
        return debugfs_create_file(name, mode, parent, value, &fops_x32);
}

If this is OK - I will send a real patch.

-Robin
