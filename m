Return-Path: <linux-kernel-owner+w=401wt.eu-S1751944AbZFHFB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944AbZFHFB4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 01:01:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751334AbZFHFBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 01:01:49 -0400
Received: from mail-pz0-f171.google.com ([209.85.222.171]:58251 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbZFHFBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 01:01:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=gyh8mw3yXEZOySbF2TVHfqRXe/y49uAo4YFTWz5UAMgrb9jumq5xRN20ju7NC5aKYw
         pB5pYJgjhPRoEvDHeVXNHo+AsW6vxbbM7XrDYZqa+zKhG6NVh7Yi06jzQw5773+8n8Eg
         7tJy+6BzaZjBKIfTUi1/zUdw0KOgC0hNHs19k=
MIME-Version: 1.0
Date: Mon, 8 Jun 2009 13:53:32 +0900
Message-ID: <90b950fc0906072153j6308059eq4d6f864c97a2003d@mail.gmail.com>
Subject: Samsung SoC Framebuffer Driver issue.
From: InKi Dae <daeinki@gmail.com>
To: ben@simtec.co.uk
Cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       Kyungmin Park <kmpark@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,  Ben  Dooks.

I am trying to develop Samsung SoC Framebuffer Driver for S5PC100 but
I faced some problems about design. so I have some questions about those.

there are some differences between LCD Controller registers of S3C64XX
and S5PC100 like the following.

. regiters not used by S3C64XX were added to S5PC100 also BPP MODE.
. WindowX Palette Data Index registers were removed from lcd
controller of S3C64XX and Palette Memory Registers were added to one
of S5PC100


1.
Your framebuffer driver, drivers/video/s3c-fb.c, is related to only S3C64XX.
and I'd like to divide framebuffer driver into common logical driver
for supporting S3C64XX and S5PC100 and S5PC100 specific driver.
but your driver needs to modifying because calling register control
commands in s3c-fb.c directly.

How do you think about that ?

2.
S3C64XX LCD Controller's registers are similar with S5PC100's, so I
wouldn't modify register prefix.
but some registers should added to definition file
(arch/arm/mach-s3c6400/include/mach/regs-fb.h).

which way do you prefer adding some registers to
arch/arm/mach-s3c6400/include/mach/regs-fb.h or creating new
definition file for S5PC100 ?

If you give me your comments for the issues above, I will modify
Samsung SoC Framebuffer Driver to be supported for S3C64XX and
S5PC100.
In the result, I expect that your driver will be divided into logical
driver and specific driver supporting S3C64XX and S5PC100 or either
S3C64XX or S5PC100.
If the driver would be completed, logical driver, s3c-fb.c, would
support S3C64XX, S5PC100 and also S5PC110.

Please give me your comments and advices.

Best Regards,
InKi Dae.
