Return-Path: <linux-kernel-owner+w=401wt.eu-S1753987AbYAXIsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987AbYAXIsL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 03:48:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753014AbYAXIr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 03:47:57 -0500
Received: from an-out-0708.google.com ([209.85.132.248]:7926 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752878AbYAXIr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 03:47:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=jNWMX/iVsT635UEIkZ1rPdxo9y7C1MuNPM013ZFKrKPd0xgNh90QVG1HgU16bmsR8jr4mjlv2sMlEaiZTvUTc0RjzlLADL9BhEgTM0V9m4EHMrRjZJcsZVgCeNPcTZTQapsE6xn7VRzjm212Eg6HC+AnM0sJYPaFEWxbmavnRHI=
Message-ID: <28c262360801240047h2a2d31b5o477d7537224df7f2@mail.gmail.com>
Date: Thu, 24 Jan 2008 17:47:53 +0900
From: "minchan kim" <minchan.kim@gmail.com>
To: catalin.marinas@arm.com
Subject: strex instrucion question in v6_early_abort
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi catalin,

Now I am trying to understand your patch in linux kernel.

  .align  5
ENTRY(v6_early_abort)
#ifdef CONFIG_CPU_32v6K
  clrex
#else
  strex r0, r1, [sp]      @ Clear the exclusive monitor
<====================== This
#endif
  mrc p15, 0, r1, c5, c0, 0   @ get FSR
  mrc p15, 0, r0, c6, c0, 0   @ get FAR

I think that you insert just ""dummy strex"" for preventing
unpredicatable state of exclusive monitor. Is right?
If it is right, Why do you use r1, [sp] in all of registers ? Is there
any issue ?


-- 
Kinds regards,
barrios
