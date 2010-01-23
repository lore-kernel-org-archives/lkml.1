Return-Path: <linux-kernel-owner+w=401wt.eu-S1755350Ab0AWM4O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350Ab0AWM4O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 07:56:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755033Ab0AWM4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 07:56:13 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:47355 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671Ab0AWM4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 07:56:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=EEznFUWMwzGcfLLc6JpSMqXJlA7nNVJOvQghBOgoiWct+evMm4+Bua2zPykvD2jrIk
         54wbK1vpn3q5HudF+OY9AUPiBpr738BLNps2u7LzYYaSbeEsWMEuUxcJd8i69nZTSXvV
         fZRF5aA9GPunSKNgLJgVgJ5Mip5SojqkDd+Nc=
Message-ID: <4B5AF1E5.1070304@gmail.com>
Date: Sat, 23 Jan 2010 13:56:05 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.7) Gecko/20100111 SUSE/3.0.1-9.1 Thunderbird/3.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org, mm-commits@vger.kernel.org, airlied@linux.ie,
       dri-devel@lists.sourceforge.net, zhenyuw@linux.intel.com,
       yakui.zhao@intel.com
Subject: i915: gpu wedged [was: mmotm 2010-01-15-15-34 uploaded]
References: <201001152359.o0FNxVne006113@imap1.linux-foundation.org>
In-Reply-To: <201001152359.o0FNxVne006113@imap1.linux-foundation.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2010 12:34 AM, akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2010-01-15-15-34 has been uploaded to

So I've decided to switch to KMS on this kernel with
00:02.0 VGA compatible controller [0300]: Intel Corporation 82G33/G31
Express Integrated Graphics Controller [8086:29c2] (rev 02) (prog-if 00
[VGA controller])
        Subsystem: Intel Corporation 82G33/G31 Express Integrated
Graphics Controller [8086:29c2]
        Flags: bus master, fast devsel, latency 0, IRQ 26
        Memory at ffa80000 (32-bit, non-prefetchable) [size=512K]
        I/O ports at ec00 [size=8]
        Memory at d0000000 (32-bit, prefetchable) [size=256M]
        Memory at ff900000 (32-bit, non-prefetchable) [size=1M]
        Expansion ROM at <unassigned> [disabled]
        Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
        Capabilities: [d0] Power Management version 2
        Kernel driver in use: i915


with this X driver:
(II) Module intel: vendor="X.Org Foundation"
        compiled for 1.7.4, module version = 2.10.0
        Module class: X.Org Video Driver
        ABI class: X.Org Video Driver, version 6.0


on X.Org X Server 1.7.4 and after some time I get:
(WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Input/output
error
(EE) intel(0): Failed to submit batch buffer, expect rendering
corruption or even a frozen display: Input/output er
ror.
(WW) intel(0): i830_uxa_pixmap_swap_bo_with_image: bo map failed
(WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Input/output
error
(WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Input/output
error
(WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Input/output
error
(EE) intel(0): Failed to submit batch buffer, expect rendering
corruption or even a frozen display: Input/output er
ror.
(EE) intel(0): Failed to submit batch buffer, expect rendering
corruption or even a frozen display: Input/output er


and kernel says:
[drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU hung
render error detected, EIR: 0x00000000
[drm:i915_do_wait_request] *ERROR* i915_do_wait_request returns -5
(awaiting 153151 at 153150)
[drm:i915_gem_execbuffer] *ERROR* i915_gem_do_execbuffer returns -5


>From <debugfs>/dri/0/i915_wedged, the GPU is wedged.

regards,
-- 
js
