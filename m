Return-Path: <linux-kernel-owner+w=401wt.eu-S1756649AbZJCQkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649AbZJCQkh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 12:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756158AbZJCQkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 12:40:37 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:64566 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756120AbZJCQkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 12:40:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:content-type;
        b=JHbTykb5P3lUNDkWblTLCMMmF2H9gn3GaMO6oJljHUjpHGVysIVfBrPCF6DvdrHUXb
         8R0PiBZHACnk37n5xs+sfOeb7ZUoDl/RLBwp/ifjcnkDKFR5FVrXzVcxtp34ypZRNIhd
         +raYfvzQtFOPC1GR1Kr4ySEzjA34FOTA2LeQc=
MIME-Version: 1.0
Date: Sat, 3 Oct 2009 12:39:59 -0400
X-Google-Sender-Auth: 51e723ee3a113453
Message-ID: <cb0375e10910030939v8d03df7m861a2f05219f173c@mail.gmail.com>
Subject: i915: high power consumption after suspend/resume
From: Andrew Lutomirski <luto@mit.edu>
To: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       intel-gfx@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi-

First, thanks for all the great work on i915's power saving features
-- power consumption on my laptop (Lenovo X200s) is now almost as low
on Linux as on Windows.

After a suspend/resume cycle, though, my power consumption usually
goes up by over a watt.  I think this is due to i915, because of an
experiment I did:

1. Boot with modesetting off into single user mode.
2. Suspend and resume
3. Reload i915 with modesetting on.  Power consumption is low.
4. Suspend and resume.  Power consumption is high.
5. Unbind and rebind i915.  Power consumption is high.
6. Suspend.  System hangs (seperate bug, I guess).

I get similar results if I boot single user with modesetting on: power
consumption is low, becomes high after suspend/resume, and goes low
again after rebinding i915.

This is on 2.6.32-rc1 + a little (i.e. 84d88d5d4e from Linus' tree
plus an ext4 fix).  I'm having trouble reproducing any of this on
2.6.31.

Thanks,
Andy
