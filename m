Return-Path: <linux-kernel-owner+w=401wt.eu-S1762699AbXJRRFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762699AbXJRRFw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 13:05:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756724AbXJRRFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 13:05:45 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:59037 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756480AbXJRRFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 13:05:44 -0400
Date: Thu, 18 Oct 2007 19:05:40 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: wait_for_completion_interruptible() changes
Message-ID: <Pine.LNX.4.62.0710181850370.22736@pademelon.sonytel.be>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584337861-669942268-1192726456=:22736"
Content-ID: <Pine.LNX.4.62.0710181904450.22736@pademelon.sonytel.be>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584337861-669942268-1192726456=:22736
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <Pine.LNX.4.62.0710181904451.22736@pademelon.sonytel.be>

	Hi Andi, Ingo,

Recently the return value of wait_for_completion_interruptible() in case of
succesful completion has changed:
  - in 2.6.23, it returns 0 on completion,
  - in current linux-2.6.git, it returns -1 on completion.

I.e. this breaks all code that checks for a non-zero return value instead
of explicitly comparing with -ERESTARTSYS.

I suspect this is caused by the recent completion refactoring?

With kind regards,
 
Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium
 
Phone:    +32 (0)2 700 8453	
Fax:      +32 (0)2 700 8622	
E-mail:   Geert.Uytterhoeven@sonycom.com	
Internet: http://www.sony-europe.com/
 	
Sony Network and Software Technology Center Europe	
A division of Sony Service Centre (Europe) N.V.	
Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium	
VAT BE 0413.825.160 · RPR Brussels	
Fortis Bank Zaventem · Swift GEBABEBB08A · IBAN BE39001382358619
---584337861-669942268-1192726456=:22736--
