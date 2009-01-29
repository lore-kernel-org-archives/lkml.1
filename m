Return-Path: <linux-kernel-owner+w=401wt.eu-S1759569AbZA2XG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759569AbZA2XG6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 18:06:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754017AbZA2XGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 18:06:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49455 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767AbZA2XGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 18:06:48 -0500
Message-ID: <49823683.6060201@zytor.com>
Date: Thu, 29 Jan 2009 15:06:43 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: x86@kernel.org
Subject: RFC: running out of x86 boot loader IDs
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 4-bit values used to hold x86 boot loader IDs are near exhaustion. 
As a result, I'm proposing an extension protocol and will implement it 
in time for the next merge window unless there are objections.

The proposal will be as follows:

- The boot loader IDs (type_of_loader >> 4) E and F will be reserved:

	E - extended IDs
	F - special uses

   F is consistent with the current use of FF for "unknown".

- If the boot loader ID is E, the current pad1 field at 0x226 is 
repurposed as an extended loader ID.  The reason to use the pad1 field 
is that it is present in all headers since version 2.02.  The boot 
loader ID will simply be: ((extended ID + 0x10) << 4) + (version), where 
(version) as before is (type_of_loader & 15).  This is the value which 
will be reported in /proc/sys/kernel/bootloader_type.

The biggest question is probably: is there a need/desire for an extended 
version field, or is four bits enough for existing bootloader needs?

	-hpa

