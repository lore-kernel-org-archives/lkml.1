Return-Path: <linux-kernel-owner+w=401wt.eu-S1754506AbYBTMHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506AbYBTMHv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 07:07:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751299AbYBTMHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 07:07:43 -0500
Received: from fk-out-0910.google.com ([209.85.128.185]:45981 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbYBTMHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 07:07:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=HKIfRvpSvsS3jeuSZ0RPngfJJJwystwGXyG0vYG8IZ/vBDWFwVSIHu3XatgoXuJbjJ0ma1cwaBiiTbz/uj7qQPdZDZhqn3EqDqQOqFSx7blLf80lS96EzYyS7rqLyPfyTn9WBG6zjuYoePG9OZZNL1pQEdw5QwgVUH+BVFy8khc=
Date: Wed, 20 Feb 2008 12:08:29 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [BUG?] APM is hidden in menuconfig
Message-ID: <20080220120828.GD3885@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I needed APM to have poweroff on old box. So, in 2.6.24.2 menuconfig:

1) Power management options -->
   No APM.
2) [*] Power Management support
   No APM. I can see ACPI...
3) I try searching with "/" + "APM"
   APM [=n]
   Depends on: !X86_VOYAGER && X86_32 && PM_SLEEP && !X86_VISWS
4) I check above: all correct except:
   Symbol: PM_SLEEP [=n]
   No more "depends on".
5) Exit menuconfig - enter grep:
6) Some time wasting in arch/.
7) less kernel/power/Kconfig:
   config PM_SLEEP
        bool
        depends on SUSPEND || HIBERNATION
        default y
   ... 
   config SUSPEND
        bool "Suspend to RAM and standby"
        depends on PM
        depends on SUSPEND_UP_POSSIBLE || SUSPEND_SMP_POSSIBLE
        default y
        ---help---
          Allow the system to enter sleep states in which main memory is
          powered and thus its contents are preserved, such as the
          suspend-to-RAM state (i.e. the ACPI S3 state).

8) Back to menuconfig:
   [*] Suspend to RAM and standby

   Bingo! APM revealed! (And not even "DEPRECATED"!)

So, has it to be so hard? It seems not - at least in good old times...

Regards,
Jarek P.
