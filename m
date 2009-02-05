Return-Path: <linux-kernel-owner+w=401wt.eu-S1756643AbZBEDR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643AbZBEDR3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 22:17:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752801AbZBEDRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 22:17:17 -0500
Received: from casper.infradead.org ([85.118.1.10]:57101 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735AbZBEDRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 22:17:16 -0500
Date: Wed, 4 Feb 2009 19:15:40 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [patch 0/2] Make the touchpad on the MSI Wind netbook work
Message-ID: <20090204191540.2d6abd87@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

A MSI Wind (100) netbook landed on my desk with the comment "touchpad
doesn't work in Linux but works in XP". 

It turns out that there are a 2 separate issues with this netbook that
needed fixing 

1) The touchpad requires the equivalent of "i8042.reset", which resets
the controller before probing. (This is done via a DMI quirk in patch
2/2)

2) About half the time, the reset will fail the first time. In the
current code, this is fatal and then also disables the keyboard in
addition to the touchpad. Ungood. Patch 1 makes the kernel retry the
reset upto five times before giving up (it seems the 2nd or 3rd time
succeed for me), and also adds an option to not make such a failure
fatal to the keyboard.

I don't think this is a regression, but it is pretty nasty behavior
(the machine is useless without) so it could be a 2.6.29 candidate...


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
