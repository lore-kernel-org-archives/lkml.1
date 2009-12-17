Return-Path: <linux-kernel-owner+w=401wt.eu-S932995AbZLQIb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932995AbZLQIb5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 03:31:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764098AbZLQIbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 03:31:55 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:49854 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764097AbZLQIby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 03:31:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=fI+9dR7Gr3QuSx10tTZo7ik1Mj2UwVxPqXv88VBTZeL/vd7U4WdQTPuajYGmXFhcII
         n9R35WaHDCJvIGpQc4BDbpjnOcV4/uvCD+8TAfd6PvRmWc/6qLyZcIShgUDrMQbd/lrE
         D0k4dNDTKA+UETlII4C8umLV1I1dffJFyDQeg=
MIME-Version: 1.0
Date: Thu, 17 Dec 2009 10:31:52 +0200
Message-ID: <b6fcc0a0912170031u162b7f56kf9f6adc23e24278c@mail.gmail.com>
Subject: revert "config FS_JOURNAL_INFO"
From: Alexey Dobriyan <adobriyan@gmail.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       h-shimamoto@ct.jp.nec.com
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can we please revert commit e4c570c4cb7a95dbfafa3d016d2739bf3fdfe319
"task_struct: make journal_info conditional"

I think I gave a good enough arguments to not merge it.
To iterate:
* patch makes impossible to start using ext3 on EXT3_FS=n kernels
without reboot.
* this is done only for one pointer on task_struct

None of config options which define task_struct are tristate directly
or effectively.

There are other examples where we don't do this:
* quota stuff on superblock aren't ifdeffed because of modular XFS
with quota support.
* exports operations and  s_anon for NFS
and so on
