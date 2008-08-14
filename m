Return-Path: <linux-kernel-owner+w=401wt.eu-S1760050AbYHNR5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760050AbYHNR5x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 13:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759979AbYHNR5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 13:57:40 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:42019 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759602AbYHNR5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 13:57:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=BJoKJ6+Ih4mCgewYzG3B4UMYJE/B8DPRYzkbPw0H39kphXB93ffujv4ssHhXkSbXHd
         XoggQnCRmk61Fl97ph07WFgKjzqMQwxPdcLMlq4VG0atbw6thYYjchcQT/sZTa7XdhoZ
         FgHV965GRcSPDdyALZp88KkQYfpI3FowMHxRw=
Message-ID: <78ef7ce10808141057u5cf57eaj4ac9199ad550c76a@mail.gmail.com>
Date: Thu, 14 Aug 2008 20:57:37 +0300
From: "Mihaela Grigore" <grigore.mihaela@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: self-modifying code in 2.6 kernel for ppc writes into readonly section
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

There is a piece of code in the early initialization of the 2.6 kernel
that identifies the cpu type and then tries to eliminate code that
does not apply to the current cpu. This is done by writing nop's over
sections of code that are not needed (do_cpu_ftr_fixups in
arch/ppc/kernel/misc.S)

When I try to run the kernel in a ppc emulator, I get a segmentation
fault in do_cpu_ftr_fixups. From examining the section headers of the
vmlinux, the text section is marked as readonly. The piece of code
above mentioned is trying to write a nop to memory location inside the
text section which is readonly, so that explains the sigsegv  error.

Since the kernel does run on boards with ppc cpu's, can somebody
explain how come this is actually working ? Or if/where I am mistaking
with my assumptions ?

Thank you and please ass me in cc in a reply to this message
