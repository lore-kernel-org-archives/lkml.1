Return-Path: <linux-kernel-owner+w=401wt.eu-S1755431AbZFSLPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431AbZFSLPU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 07:15:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752523AbZFSLPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 07:15:08 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:48140 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbZFSLPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 07:15:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=g0DUR/CJWp8zJIxhbsj2b8mKKxD5z/K0fDqBNKW0aJhS21P/WkkFhULcOJQifYTqEG
         iF+YF2hwHRC6qUQeF305QEtVlWRYguWTO059N0OVurUXv/mdBud7+WTSgZYocX4jVdZC
         Tb7YUbqXk4Wu1nbv2m/mt/iBjJJIReeHmvpMA=
MIME-Version: 1.0
Date: Fri, 19 Jun 2009 12:15:07 +0100
Message-ID: <87a5b0800906190415o1c70b6basfde98269dbacd00e@mail.gmail.com>
Subject: Mounting sysfs early
From: Will Newton <will.newton@gmail.com>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I currently have a problem with a driver that loads firmware from
userland. The boot process happens in this order:

1. Extract initramfs
2. Load drivers
3. Run init

Unfortunately it appears that step 2 is calling the hotplug helper
which tries to load firmware via sysfs, but sysfs is not mounted until
I have run init so the driver fails to initialise. What is the
recommended way to avoid this situation? Do I have to somehow build
the firmware into the kernel or can I get sysfs mounted before drivers
begin loading?

Thanks,
