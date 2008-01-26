Return-Path: <linux-kernel-owner+w=401wt.eu-S1755869AbYAZQ2D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869AbYAZQ2D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 11:28:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752468AbYAZQ1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 11:27:51 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:38771 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbYAZQ1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 11:27:50 -0500
Date: Sat, 26 Jan 2008 17:27:48 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: monstr@monstr.eu
cc: linux-kernel@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       john.williams@petalogix.com, microblaze-uclinux@itee.uq.edu.au
Subject: Re: [PATCH 11/52] [microblaze] kernel modules support
In-Reply-To: <ac0947adfe718fcb4c0dc5f6f7ab64f8155541fb.1201107832.git.monstr@monstr.eu>
Message-ID: <Pine.LNX.4.64.0801261720310.15243@fbirervta.pbzchgretzou.qr>
References: <1201187014-3979-1-git-send-email-monstr@monstr.eu>
 <dbff6b883dbcb108db53e5093994c473946e1240.1201107832.git.monstr@monstr.eu>
 <ac0947adfe718fcb4c0dc5f6f7ab64f8155541fb.1201107832.git.monstr@monstr.eu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 24 2008 16:02, monstr@monstr.eu wrote:
>+
>+/* module handling */
>+EXPORT_SYMBOL(PAGE_OFFSET);

This looks really ugly. PAGE_OFFSET is usually a macro.
I looked in patch 29/52 where PAGE_OFFSET is defined (unsigned int 
PAGE_OFFSET), which got me wondered: PAGE_OFFSET can be a runtime 
variable when it is a constant on most other arches?

That being said, I'd use

#define PAGE_OFFSET __page_offset

in some header file and in the .c file:

	unsigned int __page_offset;
	EXPORT_SYMBOL(__page_offset);

that is how arch-frv and -uml seem to do it.

