Return-Path: <linux-kernel-owner+w=401wt.eu-S1753709AbZLVQvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709AbZLVQvX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 11:51:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752043AbZLVQvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 11:51:22 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:43728 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbZLVQvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 11:51:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=YN8XeWMm7wPtpUrEaMmFl95hoX/KnvR2BBagQjiY53Bn/x/XBdI+FnX7X/ER0yXIi0
         yaG8yoZWWG4oNeHx0RZojbfxEpH5LGeDnlGdaCNWbyJSsp7w2/+5xPA3Fw2985E87PRV
         eKXQywS20IfhTpJRFUlPF4WNUYz5K/wjPjooY=
MIME-Version: 1.0
Date: Tue, 22 Dec 2009 16:51:20 +0000
Message-ID: <74fd948d0912220851v354b1704xa55fc3c88e1c300c@mail.gmail.com>
Subject: WARN_ON at line 380 in kernel/smp.c under 2.6.32.2 + TuxOnIce + KDB
From: Pedro Ribeiro <pedrib@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I've been asked by Nigel Cunningham of TuxOnIce to forward this bug here.

While resuming from hibernate (using TuxOnIce) I'm seeing the WARN_ON
at line 380 in kernel/smp.c trigger from a kmap_high call right after
secondary processors have been brought down (the previous message is
"CPU1 is down").

I only have pictures of the backtrace (readable but not very good
quality, sorry).
http://img51.imageshack.us/img51/2312/stacktrace1.jpg
http://img195.imageshack.us/img195/3646/stacktrace2.jpg

At first I thought this was related to my battery saving script
messing with /proc/sys/vm/dirty_writeback_centisecs, but I'm not sure
right now, it still happens with the default value, so I'm clueless.

Mind you, this does not impede the resume - it just dumps this stack
trace and continues resuming happily.

Some information which might be helpful:
lspci -vv, http://pastebin.com/m2c217b4e
dmesg, http://pastebin.com/m491ab4db
.config, http://pastebin.com/m2e4352fe
(the pastebin links are good for a month)

My hardware is a Lenovo T400, and I'm using 2.6.32.2 + TuxOnIce + KDB patches.

Thanks for your help,
Pedro
