Return-Path: <linux-kernel-owner+w=401wt.eu-S1752528AbZKOJsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528AbZKOJsN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 04:48:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752465AbZKOJsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 04:48:13 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:39701 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375AbZKOJsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 04:48:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=subject:to:cc:from:reply-to:date:mime-version:content-type
         :content-transfer-encoding:message-id;
        b=qDNvDl8PshidLTY+wy0zwuY2C/nKMxV+NXP/IzmSnWtYSx2VfErD0qPA9+ZElEE68F
         P2PV4eoaf/jJPUsZeZ0ph98gCshycwk+1SCAXK85wTJXzUBzVvl77EiCJtDEl2fQUd2m
         QHDkVTSDQdiYItaOxv1TkloEvDLvSdp1MRj78=
Subject: [regression] [drm:i915_gem_execbuffer] *ERROR* Execbuf while wedged
To: linux-kernel@vger.kernel.org
Cc: Zhenyu Wang <zhenyu.z.wang@intel.com>,
       David Woodhouse <David.Woodhouse@intel.com>
From: Michael <schnitzelkuchen@googlemail.com>
Reply-To: schnitzelkuchen@googlemail.com
Date: Sun, 15 Nov 2009 10:48:13 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200911151048.13777.schnitzelkuchen@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone.

I tried 2.6.32-rc6 with my Dell Inspiron 1525, but the KDM didnt
display right - It was mostly black with only the cursor displayed.
Other things which use X dont work with the kernel, too.

dmesg shows the following:

i915: Waking up sleeping processes
[drm:i915_wait_request] *ERROR* i915_wait_request returns -5 (awaiting 5 at 3)
[drm:i915_gem_execbuffer] *ERROR* Execbuf while wedged
[drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU hung
render error detected, EIR: 0x00000000
i915: Waking up sleeping processes
[drm:i915_wait_request] *ERROR* i915_wait_request returns -5 (awaiting 12 at 
6)
[drm:i915_gem_execbuffer] *ERROR* Execbuf while wedged
eth0: no IPv6 routers present
[drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU hung
render error detected, EIR: 0x00000000
i915: Waking up sleeping processes
(...)
i915: Waking up sleeping processes
[drm:i915_wait_request] *ERROR* i915_wait_request returns -5 (awaiting
1161 at 1153)
[drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU hung
render error detected, EIR: 0x00000000
i915: Waking up sleeping processes
[drm:i915_wait_request] *ERROR* i915_wait_request returns -5 (awaiting
1163 at 1162)


GFX-Hardware is: Intel GM965/GL960 (rev0c)


After bisecting i got to the following commit:

176616814d700f19914d8509d9f65dec51a6ebf7 is the first bad commit
commit 176616814d700f19914d8509d9f65dec51a6ebf7
Author: Zhenyu Wang <zhenyu.z.wang@intel.com>
Date:   Mon Jul 27 12:59:57 2009 +0100

    intel_agp: Use PCI DMA API correctly on chipsets new enough to have IOMMU

    When graphics dma remapping engine is active, we must fill
    gart table with dma address from dmar engine, as now graphics
    device access to graphics memory must go through dma remapping
    table to get real physical address.

    Add this support to all drivers which use intel_i915_insert_entries()

    Signed-off-by: Zhenyu Wang <zhenyu.z.wang@intel.com>
    Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>

:040000 040000 2e225bb921aba5b816886d0d8ada8fd81e00e7a7
03d1ce91543e61975802c3a26df1ae5b75902b51 M	drivers



If you have any more questions, feel free to ask. (CC'ing would be a
good idea ;) )


Thanks everyone for the work for linux so far,

Michael
