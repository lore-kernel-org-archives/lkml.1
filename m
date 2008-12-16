Return-Path: <linux-kernel-owner+w=401wt.eu-S1754305AbYLPHgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305AbYLPHgh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 02:36:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752014AbYLPHgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 02:36:16 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:63034 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbYLPHgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 02:36:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:from;
        b=I4pEDcRK45atvzsF5TCUl6VvcNBYCYu4qFYf6lkz9JHra2pdNkkevVSFGsNrRuS6ek
         bqYessQbDLRJQ/HNOwpMfT3pHaQNHM3BWuhgW6ao0zI8nPbGDI4o4JcrVfhayQR8BgjF
         diPhMvoVK4M3fQnLX/dLsWytBgaOGX+fT6uwU=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 0/9] ide-atapi: remove ide_atapi_pc from the irq handler
Date: Tue, 16 Dec 2008 08:36:00 +0100
Message-Id: <1229412969-3552-1-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.0.4
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bart,

here's a first attempt at removing all references to ide_atapi_pc in the ATAPI
IRQ handler. I've moved some of the members to the drive struct and will deal
with them later :). The next step is to add an ide_atapi_queue_pc() routine
similar to ide_cd_queue_pc() and then rewrite all functions in the drivers to
use struct requests and local buffers instead of pc->buf and then, after that
works reliably, finally get rid of ide_atapi_pc completely.

This has been tested with ide-floppy.

 drivers/ide/ide-atapi.c        |  123 ++++++++++++++++-------------
 drivers/ide/ide-floppy.c       |   56 +++++++-------
 drivers/ide/ide-floppy.h       |    4 +-
 drivers/ide/ide-floppy_ioctl.c |   19 +++--
 drivers/ide/ide-tape.c         |  173 ++++++++++++++++++++++------------------
 include/linux/ide.h            |   20 +++--
 6 files changed, 214 insertions(+), 181 deletions(-)
