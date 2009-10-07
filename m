Return-Path: <linux-kernel-owner+w=401wt.eu-S1759696AbZJGSGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759696AbZJGSGe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 14:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758551AbZJGSGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 14:06:33 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:40907 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757999AbZJGSGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 14:06:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=vZUi/AjNBEAwuAm6TxJWStPZqf3doCc3DIxNqQSO0+0vqcKauopgjwphI1aKzvM4QK
         /fko5VHBkOTIz0fmdGsofdSgUm/zcqbWjZqkzgGFHOFgyuxIYKIY6jY/feAdSjFDoyQ3
         StMEC7tY+kCaz2TywVo1t93WdVk+OiSOFEmP0=
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>
Cc: Oliver Neukum <oliver@neukum.org>, Alan Stern <stern@rowland.harvard.edu>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 0/4]: USB: ftdi_sio: fix regression in 2.6.31 and clean up
Date: Wed,  7 Oct 2009 20:05:03 +0200
Message-Id: <1254938707-6996-1-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.6.5.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

These patches clean up the ftdi_sio driver and fixes

 1) a long outstanding bug manifesting itself as 
 
 	BUG: sleeping function called from invalid context at kernel/mutex.c:280

 2) a couple of regressions in 2.6.31 (stalled reads and unthrottle race)
    due to changes in the tty layer.

Please have a look at it so we can get something back-ported to stable as the
ftdi_sio driver is currently completly broken and unusable due to the stalled
reads.

Note that the patches do not add suspend/resume support to the driver (but the
clean up should make it easier to implement).

Thanks to Alan Cox, Oliver Neukum, and Alan Stern for all comments and
suggestions so far.

Thanks,
Johan


drivers/usb/serial/ftdi_sio.c |  422 +++++++++++++----------------------------
 1 files changed, 129 insertions(+), 293 deletions(-)

