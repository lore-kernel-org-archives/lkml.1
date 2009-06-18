Return-Path: <linux-kernel-owner+w=401wt.eu-S1758256AbZFRC6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758256AbZFRC6f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 22:58:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752753AbZFRC6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 22:58:24 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:56787 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586AbZFRC6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 22:58:23 -0400
Message-ID: <4A39AD4C.6020807@nodomain.org>
Date: Thu, 18 Jun 2009 03:58:20 +0100
From: Tony Hoyle <tmh@nodomain.org>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Bug(?) in linux kernel EFI support
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm building kernels on an embedded system which uses an odd version of 
EFI (elilo/egrub don't run for example, only its own shipped boot.efi 
that loads a raw vmlinux).  I've been unable to get it to boot with any 
kernel > 2.6.24.7 - as in it doesn't start up far enough to get netconsole.

I've tracked it down to the following commit.  Prior to this commit, it 
boots.. after it, it doesn't:

e429795c68d3001ecae74f6465420c9f043b0ece is first bad commit
commit e429795c68d3001ecae74f6465420c9f043b0ece
Author: Huang, Ying <ying.huang@intel.com>
Date:   Wed Jan 30 13:31:19 2008 +0100

     x86: EFI runtime service support: remove duplicated code from efi_32.c

     This patch removes the duplicated code between efi_32.c and efi.c.

     Signed-off-by: Huang Ying <ying.huang@intel.com>
     Cc: Andi Kleen <ak@suse.de>
     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
     Signed-off-by: Ingo Molnar <mingo@elte.hu>
     Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

:040000 040000 e6ac42e8fddef99698e5ebb39ed0a3d0c18bf1ac 
1974f788a81cc6ced68ce87345e107e614691831 M	arch
:040000 040000 f7b172e407b45e571eac4612dc799e44e7b24928 
20608b877d79449318d72a31dc202f2341f0fceb M	include

Now I don't really understand the inner workings of EFI (or of the 
kernel for that matter).. I imagine 32bit EFI-only booting is fairly 
unusual and few platforms support it... is there anything that anyone 
can see that could cause a crash in this patch?

I have no ability to see the actual fault - The device has no console 
(the display is hardcoded to show a logo until X boots.. there's an fb 
driver shipped with it that appears to be able to override that but it's 
binary only*.  There's no serial port on the board, only USB & Ethernet 
- so I'm stuck with netconsole basically.  kexec doesn't work (memory 
regions have different names & kexec has hardcoded text searches.. 
patching it with the new names doesn't work either..).

I realise this makes things somewhat harder to debug :p  I call it 
challenging..

Tony

* despite a 'strings' saying GPL in the text.. sigh..
