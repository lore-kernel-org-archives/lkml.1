Return-Path: <linux-kernel-owner+w=401wt.eu-S1753306Ab0AaMQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306Ab0AaMQy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 07:16:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752655Ab0AaMQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Jan 2010 07:16:53 -0500
Received: from blu0-omc4-s9.blu0.hotmail.com ([65.55.111.148]:62460 "EHLO
	blu0-omc4-s9.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752612Ab0AaMQw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 07:16:52 -0500
Message-ID: <BLU108-W14539E61D58BF455B82CA59C590@phx.gbl>
X-Originating-IP: [87.81.120.187]
From: d binderman <dcb314@hotmail.com>
To: <tony@atomide.com>
CC: <linux-kernel@vger.kernel.org>
Subject: arch/arm/mach-omap2/mux.c: Off by one error
Date: Sun, 31 Jan 2010 12:16:52 +0000
Importance: Normal
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 31 Jan 2010 12:16:51.0532 (UTC) FILETIME=[44F2E8C0:01CAA26F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Hello there,

I just ran the sourceforge tool cppcheck over the source code of the
new Linux kernel 2.6.33-rc6

It said

[./arm/mach-omap2/mux.c:492]: (error) Buffer access out-of-bounds

The source code is

        char mode[14];
        int i = -1;

        sprintf(mode, "OMAP_MUX_MODE%d", val & 0x7);

13 characters + 1 digit + 1 zero byte is more than 14 characters.

Suggest new code

        char mode[15];
        int i = -1;

        sprintf(mode, "OMAP_MUX_MODE%d", val & 0x7);


Regards

David Binderman


 		 	   		  
_________________________________________________________________
Tell us your greatest, weirdest and funniest Hotmail stories
http://clk.atdmt.com/UKM/go/195013117/direct/01/