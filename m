Return-Path: <linux-kernel-owner+w=401wt.eu-S1760135AbZA3Adv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760135AbZA3Adv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 19:33:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754201AbZA3Adn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 19:33:43 -0500
Received: from aun.it.uu.se ([130.238.12.36]:63088 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754054AbZA3Adm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 19:33:42 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18818.19160.962399.20413@harpo.it.uu.se>
Date: Fri, 30 Jan 2009 01:33:28 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: Re: RFC: running out of x86 boot loader IDs
In-Reply-To: <49823683.6060201@zytor.com>
References: <49823683.6060201@zytor.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin writes:
 > The 4-bit values used to hold x86 boot loader IDs are near exhaustion. 
 > As a result, I'm proposing an extension protocol and will implement it 
 > in time for the next merge window unless there are objections.
 > 
 > The proposal will be as follows:
 > 
 > - The boot loader IDs (type_of_loader >> 4) E and F will be reserved:
 > 
 > 	E - extended IDs
 > 	F - special uses
 > 
 >    F is consistent with the current use of FF for "unknown".
 > 
 > - If the boot loader ID is E, the current pad1 field at 0x226 is 
 > repurposed as an extended loader ID.  The reason to use the pad1 field 
 > is that it is present in all headers since version 2.02.  The boot 
 > loader ID will simply be: ((extended ID + 0x10) << 4) + (version), where 
 > (version) as before is (type_of_loader & 15).  This is the value which 
 > will be reported in /proc/sys/kernel/bootloader_type.
 > 
 > The biggest question is probably: is there a need/desire for an extended 
 > version field, or is four bits enough for existing bootloader needs?

Why do we need a boot loader id at all? The purpose of a boot loader,
whatever it may be, is to load the kernel according to certain protocols.
Once that's done, why would the kernel care who/what loaded it?
