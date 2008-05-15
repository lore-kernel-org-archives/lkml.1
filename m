Return-Path: <linux-kernel-owner+w=401wt.eu-S1759958AbYEONoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759958AbYEONoq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 09:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753070AbYEONoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 09:44:38 -0400
Received: from wx-out-0506.google.com ([66.249.82.231]:59194 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843AbYEONoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 09:44:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:x-enigmail-version:content-type:content-transfer-encoding;
        b=oG0n6w4bN1r+ah4fNruh+Xtdl73C5O2CR2du9igPUsdR13HcJHS895dvB1vGiwurAVkJAAQs873x2N301yELwcfVeWPuN8Nuhj55kudiAaZmgYR+QtnNMsR3XaoZRwdemRBj3B2KLIgDesvRIVL6eCpnP2mfRlytcbhSktLmZcY=
Message-ID: <482C3E3E.9090204@gmail.com>
Date: Thu, 15 May 2008 15:44:30 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Sam Ravnborg <sam@uranus.ravnborg.org>
CC: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Michael Buesch <mb@bu3sch.de>,
       Gordon Farquharson <gordonfarquharson@gmail.com>
Subject: crossbuild fails in modpost
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

probably
4ce6efed48d736e3384c39ff87bda723e1f8e041
kbuild: soften modpost checks when doing cross builds

causes build failures on x86_64 kernel build on 32 bit machine:

make -f /local/xslaby/hid/scripts/Makefile.modpost
YYYYYYYYYYYYYY x86_64 x86_64
   scripts/mod/modpost -m -a -o /local/xslaby/buhid/Module.symvers    -S -K 
/local/xslaby/buhid/Module.markers -M /local/xslaby/buhid/Module.markers   -s
XXXXXXXXXXXXXXXXXX 20: 0 (2), 4 (4), 8 (4), 12 (8)
FATAL: drivers/hid/hid-apple: sizeof(struct hid_device_id)=20 is not a 
modulo of the size of section __mod_hid_device_table=648.
Fix definition of struct hid_device_id in mod_devicetable.h
make[2]: *** [__modpost] Error 1
make[1]: *** [modules] Error 2
make: *** [sub-make] Error 2

after sticking echo into:
  __modpost: $(modules:.ko=.o) FORCE
+       @echo YYYYYYYYYYYYYY $(KBUILD_BUILDHOST) $(ARCH)
         $(call cmd,modpost) $(wildcard vmlinux) $(filter-out FORCE,$^)

