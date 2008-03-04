Return-Path: <linux-kernel-owner+w=401wt.eu-S1762959AbYCDHLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762959AbYCDHLm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 02:11:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756365AbYCDHLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 02:11:34 -0500
Received: from el-out-1112.google.com ([209.85.162.178]:16547 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756056AbYCDHLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 02:11:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=xawC9EycfQGQZq9cdrnSMjcg2JeTR/JfgKLmlcNYqRXAo0OpZXt5zcWIpGSli0tsCxZ7A9ypDbThMa6xeBN0VDmjg2vEbx/upIkqHlKHQjx1+VOpBe2K3EibON0ZZsaN3bon0g1490Xj27OfYrrUb6PARCRL4dzRCjIQDqgqaBk=
Message-ID: <76366b180803032311g40593189o47f727e4bba52c43@mail.gmail.com>
Date: Tue, 4 Mar 2008 02:11:31 -0500
From: "Andrew Paprocki" <andrew@ishiboo.com>
To: linux-kernel@vger.kernel.org
Subject: Geode LX800 hanging at boot in vesa_store_edid() w/ CONFIG_FIRMWARE_EDID=y
Cc: "Jordan Crouse" <jordan.crouse@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: c7eb74a86eace047
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a LX800 board which hangs at boot time *only* if no monitor is
plugged into the VGA port. It hangs for about 20 minutes and then
continues booting.  If a monitor is plugged into the system while it
is hung, it recovers after a few minutes and continues booting.  I
added puts() debugging in the kernel main() and it is hanging in
vesa_store_edid() in the first asm() call:

        /* Note: The VBE DDC spec is different from the main VESA spec;
           we genuinely have to assume all registers are destroyed here. */

        asm("pushw %%es; movw %2,%%es; "INT10"; popw %%es"
            : "+a" (ax), "+b" (bx)
            :  "c" (cx), "D" (di)
            : "esi");

After waiting for a really long time, this int10 finishes and it
executes the second asm() call which returns right away.  I never
tried booting the system without a head, so I never noticed this
problem before.  Does this point to some kind of BIOS bug?  The system
boots fine when CONFIG_FIRMWARE_EDID is disabled (I'm not even sure if
it should have been enabled in the first place), but I want to make
sure the manufacturer is alerted if there is a BIOS problem.

Thanks,
-Andrew
