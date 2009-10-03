Return-Path: <linux-kernel-owner+w=401wt.eu-S1753671AbZJCQum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671AbZJCQum (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 12:50:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752672AbZJCQul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 12:50:41 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:65397 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428AbZJCQuk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 12:50:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=UH87ESFSAq2RozxdngleBJ9djY7/N6Z6xEFdr77G+rdUijtwrQDBgeMc1DyXBICCDY
         N5v74PiLPwpIy8Hnvn7km9x7qJv68J9tM74R49J772oxsUlopMcAwn4bxw4AhcIdCczB
         5IW7hcEDVmqkd+Og37iseMPYIYEpXQ1PCZOXU=
MIME-Version: 1.0
In-Reply-To: <cb0375e10910030939v8d03df7m861a2f05219f173c@mail.gmail.com>
References: <cb0375e10910030939v8d03df7m861a2f05219f173c@mail.gmail.com>
Date: Sat, 3 Oct 2009 12:50:01 -0400
X-Google-Sender-Auth: a5ac228bb62a80ea
Message-ID: <cb0375e10910030950kcd19fe9i7835eaaf4314c0fb@mail.gmail.com>
Subject: [resend] i915: high power consumption after suspend/resume
From: Andrew Lutomirski <luto@mit.edu>
To: intel-gfx@lists.freedesktop.org
Cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[resend b/c the intel-gfx list doesn't allow non-member posting]

Hi-

First, thanks for all the great work on i915's power saving features
-- power consumption on my laptop (Lenovo X200s) is now almost as low
on Linux as on Windows.

After a suspend/resume cycle, though, my power consumption usually
goes up by over a watt.  I think this is due to i915, because of an
experiment I did:

1. Boot with modesetting off into single user mode.
2. Suspend and resume
3. Reload i915 with modesetting on.  Power consumption is low.
4. Suspend and resume.  Power consumption is high.
5. Unbind and rebind i915.  Power consumption is high.
6. Suspend.  System hangs (seperate bug, I guess).

I get similar results if I boot single user with modesetting on: power
consumption is low, becomes high after suspend/resume, and goes low
again after rebinding i915.

This is on 2.6.32-rc1 + a little (i.e. 84d88d5d4e from Linus' tree
plus an ext4 fix).  I'm having trouble reproducing any of this on
2.6.31.

Thanks,
Andy
