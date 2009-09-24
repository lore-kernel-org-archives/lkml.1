Return-Path: <linux-kernel-owner+w=401wt.eu-S1752672AbZIXNaC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbZIXNaC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 09:30:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752513AbZIXNaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 09:30:00 -0400
Received: from mail-yw0-f174.google.com ([209.85.211.174]:55026 "EHLO
	mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637AbZIXN36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 09:29:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=R5dOnPh+fClTlv81/WX+kk6c3dBFpb3j22gkpXLtN5w2T4glpcMu3CI8Kq8hFXDTNT
         JE7HDmBRoAy0w+SxVncrw/2fbp5c4taZ+UbpYonacVZvEdGOGfD9sjxpZg3STI6+PPnl
         YUBaEMUgSv4B2GxYCBo43SJaT7pJxsnSYm41Y=
MIME-Version: 1.0
Date: Thu, 24 Sep 2009 21:24:45 +0800
Message-ID: <b6a2187b0909240624u2821a312ub6d02df21d552248@mail.gmail.com>
Subject: linux-2.6.31 INIT: open(/dev/console): Input/output error (due to 
	commit b50989dc444599c8b21edc23536fc305f4e9b7d5)
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>, Alan Cox <alan@linux.intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Latest linux pull few days ago broke the console.

The error during boot up while switching from init S to M showed

INIT: open(/dev/console): Input/output error


Reverting this commit solves the problem. This is 100% repeatable on a
"real" machine, but does not show up on kvm or vmware guest console.


commit b50989dc444599c8b21edc23536fc305f4e9b7d5
Author: Alan Cox <alan@linux.intel.com>
Date:   Sat Sep 19 13:13:22 2009 -0700

    tty: make the kref destructor occur asynchronously

    We want to be able to sleep in the destructor for USB at least. It isn't a
    hot path so just pushing it to a work queue doesn't really cause any
    difficulty.

    Signed-off-by: Alan Cox <alan@linux.intel.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>



Thanks,
Jeff
