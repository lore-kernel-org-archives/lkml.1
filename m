Return-Path: <linux-kernel-owner+w=401wt.eu-S1753303AbYAPKCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303AbYAPKCg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 05:02:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751748AbYAPKC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 05:02:27 -0500
Received: from mu-out-0910.google.com ([209.85.134.188]:32259 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbYAPKC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 05:02:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=bwLq1Hki2cF1hnYpLUu+zcAcmA3udFDcakLvAeORcKLmSciB7z6EGhbt111CCjuxjXeJC4ho7yrp9uZQPmdqvjo38/KRYQ6Eo+LthQF+WZFKThCFKiFcbIKhCx8AKaTVauZl9Rrh0Z10ktzxjbE21iOBj1pjQV8yWrv5wdKFbas=
Message-ID: <91b13c310801160202y833df7bs37cbb5827e875569@mail.gmail.com>
Date: Wed, 16 Jan 2008 18:02:22 +0800
From: "rae l" <crquan@gmail.com>
To: "Rusty Russell" <rusty@rustcorp.com.au>
Subject: [RFC on MODULE SUPPORT] hello, Rusty, Should we provide module information even if the kernel module compiled built-in with bzImage?
Cc: open-iscsi@googlegroups.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hello, Rusty:
I encountered a problem when modules compiled built-in with bzImage:

open-iscsi is an iSCSI software, it has a userspace daemon(iscsid) and
a userspace mani tool(iscsiadm) and a kernel module
(scsi_transport_iscsi),
recently the kernel module has been accepted into the official kernel
release; since the module licensed with GPL, it could be compiled as
built-in,

but when I compiled the module within the bzImage, the problem appeared:

tux ~ # iscsid -f
iscsid: Missing or Invalid version from
/sys/module/scsi_transport_iscsi/version. Make sure a up to date
scsi_transport_iscsi module is loaded and a up todate version of
iscsid is running. Exiting...

this is just because iscsid hope there's an external module could be
under /sys/module, and read the kernel module's version information,
but if the module compiled built-in, all its module information
discarded and it doesn't appeared under /sys/module/, that would break
iscsid.

Now the problem is:

Should we provide module information under
/sys/module/<module-name>/... even if the module compiled built-in
with bzImage?
Or just this module(scsi_transport_iscsi) should be marked with [M] only?

if the former solution is preferred, I would be happy to work on
MODULE_INFO-like macros improvements with CONFIG_MODULE undefined.

-- 
Denis
