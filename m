Return-Path: <linux-kernel-owner+w=401wt.eu-S1755688AbZC0IKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688AbZC0IKg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 04:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754842AbZC0IKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 04:10:20 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:46631 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501AbZC0IKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 04:10:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:user-agent:mime-version
         :content-type;
        b=TaCl1+NeaxY/4yA7kBA0HXZNOd6X9TTO/vABHvmPuYQWl4XpckAFagdelc8z1QSqtU
         1q3vKSSNKt1QcCIM8gUgZh8HfEc4l9XXXCAqd4IRXE2TAuFZgvMZcsnXAN6x/Q+w85E8
         kVvpaLZOcSaXwfpbbLxzdvhNEFSGimgRXy3iY=
Date: Fri, 27 Mar 2009 01:10:10 -0700 (PDT)
From: justinmattock@gmail.com
To: linux-kernel@vger.kernel.org
Subject: adding pat causes conflicting memory types
Message-ID: <alpine.LNX.2.00.0903270057060.2302@havk>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've seen this for sometime(and reported it a few months back),
but didn't experience any anomalies.
also have seen some(quick google) reports about this(people have been 
unable to boot there systems because of this)

with having pat enabled dmesg shows this:

[   34.699209] [drm] Initialized drm 1.1.0 20060810
[   34.724925] pci 0000:01:00.0: setting latency timer to 64
[   34.725318] [drm] Initialized radeon 1.29.0 20080528 on minor 0
[   35.192313] [drm] Setting GART location based on new memory map
[   35.193444] [drm] Loading R500 Microcode
[   35.193513] [drm] Num pipes: 1
[   35.193529] [drm] writeback test succeeded in 1 usecs
[   35.541595] X:1837 conflicting memory types 40000000-48000000 
write-combining<->uncached-minus
[   35.541602] reserve_memtype failed 0x40000000-0x48000000, track 
write-combining, req write-combining
[   36.081888] X:1837 conflicting memory types 40000000-48000000 
write-combining<->uncached-minus
[   36.081895] reserve_memtype failed 0x40000000-0x48000000, track 
write-combining, req write-combining


when disabling pat I get no message just this:

[   34.649170] Linux agpgart interface v0.103
[   34.699209] [drm] Initialized drm 1.1.0 20060810
[   34.724925] pci 0000:01:00.0: setting latency timer to 64
[   34.725318] [drm] Initialized radeon 1.29.0 20080528 on minor 0
[   35.192313] [drm] Setting GART location based on new memory map
[   35.193444] [drm] Loading R500 Microcode
[   35.193513] [drm] Num pipes: 1
[   35.193529] [drm] writeback test succeeded in 1 usecs


FWIW: with a macbook there is no inconvenience, but I guess that changes
with others.

-- Justin P. Mattock
