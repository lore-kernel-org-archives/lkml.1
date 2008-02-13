Return-Path: <linux-kernel-owner+w=401wt.eu-S1755058AbYBMLAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058AbYBMLAr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 06:00:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755594AbYBMLAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 06:00:37 -0500
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:42077 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755260AbYBMLAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 06:00:36 -0500
Message-ID: <47B2CDD1.1070406@tiscali.nl>
Date: Wed, 13 Feb 2008 12:00:33 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: thomas@winischhofer.net, lkml <linux-kernel@vger.kernel.org>
Subject: [drivers/video/sis/init301.c] SiS_Pr->ChipType >= SIS_661 not evaluated
 twice
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure whether this is important, but in drivers/video/sis/init301.c:1557:

  if((SiS_Pr->ChipType >= SIS_661) || (SiS_Pr->SiS_ROMNew)) {
     SiS_Pr->SiS_LCDTypeInfo = (SiS_GetReg(SiS_Pr->SiS_P3d4,0x39) & 0x7c) >> 2;
  } else if((SiS_Pr->ChipType < SIS_315H) || (SiS_Pr->ChipType >= SIS_661)) {
     SiS_Pr->SiS_LCDTypeInfo = temp >> 4;

note the duplicate test for 'SiS_Pr->ChipType >= SIS_661'
if it was true in the first test, the second test won't be evaluated.
