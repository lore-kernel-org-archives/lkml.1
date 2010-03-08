Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960Ab0CHWiM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 17:38:12 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:40133 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755752Ab0CHWiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 17:38:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=v8nZWJojTbdaXKPlP/JePYQxtxS/sg/Ekv+dEmo6R8FFfaZmjAYSpKPBVwpCGWydva
         Dz6WJo58YXy7NSavoqw38OaWHr5dFRRgHSG6Iz083uU6siLBllD+CNS21AoReu+nde1J
         yoBC2I/RLHD+4wdC1meHCrwxIvJKt8FMEsCs4=
Date: Mon, 8 Mar 2010 23:38:00 +0100
From: Luca Tettamanti <kronos.it@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-kernel@vger.kernel.org
Subject: [BUG?] inquiry_cache_read: stack size
Message-ID: <20100308223759.GA27590@nb-core2.darkstar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marcel,
I'm compiling current -git kernel and noticed this warning:

net/bluetooth/hci_sysfs.c: In function 'inquiry_cache_read':
net/bluetooth/hci_sysfs.c:441: warning: the frame size of 4208 bytes is larger than 2048 bytes

which is caused by:

commit ca325f698996c1a0770a67f41e7dc97a007d8bc2
Author: Marcel Holtmann <marcel@holtmann.org>
Date:   Mon Feb 8 16:22:31 2010 +0100

    Bluetooth: Convert inquiry cache to use debugfs instead of sysfs

    The output of the inquiry cache is only useful for debugging
    purposes and so move it into debugfs.

This buffer on the stack:

    char buf[4096];

is likelly to cause troubles, since the kernel space stack is limited to
8K or even 4K (4KSTACKS).

Luca
