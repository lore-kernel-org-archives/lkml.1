Return-Path: <linux-kernel-owner+w=401wt.eu-S1759606AbXHaP0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759606AbXHaP0P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 11:26:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756383AbXHaP0B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 11:26:01 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:53982 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756174AbXHaP0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 11:26:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=gjmpKgtAxOBvk7PdXdK2C4bAZPj0pTtISJfgPTG1UL1wUceumEgaP1XxcaZp8MFINTz/nqPWpLNpb3rBaSHWyH14VkwZi9kEk62S+zWSOGgwbH9AHK1NPU3GxjNeBPyjtAlNhcASVCy0hp+sXDxGC980lGQGjRHGhfxNGBnSIII=
Message-ID: <379fb4870708310825o70509368l490ac9063ce09866@mail.gmail.com>
Date: Fri, 31 Aug 2007 17:25:55 +0200
From: "anon... anon.al" <anon.asdf@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: memory barrier to ensure copy_to_user() completes
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

a)
Which memory barrier do I require if I need to ensure that a
copy_to_user(dest, src, len) completes before the next statement?

copy_to_user(dest, src, len) ;
//rmb(); OR wmb(); OR barrier(); OR mb(); ??????
//next statement;

I'm guessing:
Use rmb() to be sure that all of src is in registers, before continuing.
Use wmb() to be sure that all of src is actually written to dest
memory, before continuing.
?

b)

If I'm writing to hardware, and need to ensure the correct order, I'll
use wmb(), right?
e.g.:

#define HW_address1 20
#define HW_address2 40

*((int *)HW_address1) = 0x00000001;
wmb();  // is this good???
*((int *)HW_address2) = 0x00000010;


Thanks - Albert
