Return-Path: <linux-kernel-owner+w=401wt.eu-S1760671AbYHHVMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760671AbYHHVMv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 17:12:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754182AbYHHVMn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 17:12:43 -0400
Received: from fk-out-0910.google.com ([209.85.128.186]:54863 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934AbYHHVMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 17:12:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=dVFIHz0pHcimJLIF6C/zqCcbHaGgckqF2BR9BXHoRZoeY8W4dfQYPj5BjX5tKIHiOi
         OpQS7KUFFBF7Ww6isUynBY0sESnu8wTQKMhp13pB7gDoPPMIo0JUgLS5Nn7UuezP1JOv
         nOlrEbXdz7+RnJ5AKQnGzcXLMkEGkT/UbQa3A=
Date: Sat, 9 Aug 2008 01:12:36 +0400
From: Alexander Beregalov <a.beregalov@gmail.com>
To: joern@logfs.org, linux-kernel@vger.kernel.org
Subject: LogFS: confused with using s64 and u64
Message-ID: <20080808211236.GB5093@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joern

I am a bit confused with mixing signed and unsigned types here:


static inline u64 dev_ofs(struct super_block *sb, u32 segno, u32 ofs)
{
	return ((u64)segno << logfs_super(sb)->s_segshift) + ofs;
}

static s64 logfs_get_free_bytes(struct logfs_area *area, size_t bytes)
{
	s32 ofs;
	...
	ofs = area->a_used_bytes;
	...
	return dev_ofs(area->a_sb, area->a_segno, ofs);
}

Can you please explain why do you use s64 for function which returns u64?
