Return-Path: <linux-kernel-owner+w=401wt.eu-S1751399Ab0A0LYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751399Ab0A0LYt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 06:24:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751123Ab0A0LYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 06:24:48 -0500
Received: from ivanoab2.miniserver.com ([89.200.136.192]:34847 "EHLO
	www.sigsegv.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846Ab0A0LYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 06:24:47 -0500
X-Greylist: delayed 1137 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Jan 2010 06:24:47 EST
Subject: CBQ broken in 2.6
From: Anton Ivanov <anton.ivanov@kot-begemot.co.uk>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Wed, 27 Jan 2010 11:05:47 +0000
Message-Id: <1264590347.29501.11.camel@tranquility.sigsegv.cx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list,

I have been looking at CBQ being broken in 2.6 (Debian BUG 534430).

The bug is very simple and it makes it unusable for all practical
purposes - BOUNDED classes always borrow from their parent. As a result
it impossible to:

1. Set and enforce a bandwidth limit to a class with a CBQ tree
2. Use CBQ to do QoS at any place but the actual link. For example - put
a linux box after behind a DSL modem and tell it to QoS at the bandwidth
at which the modem is configured.

I have now looked through the code of cbq_sched.c (in 2.6.33-rc5 and
2.6.26 as shipped by Debian).

In both pieces of code the variable in the class structure for CBQ
cl->borrow is used to signal if borrowing is allowed. If borrowing is
not allowed (BOUNDED class) it is set to NULL.

However the routine which parses the class options and defines the class
cbq_change_class() sets it to the parent class and never resets it to
NULL for bounded classes.

Am I missing something here? 

Please cc me as I am not subscribed to the list.

Best Regards,

-- 
   Understanding is a three-edged sword:
            your side, their side, and the truth. --Kosh Naranek

A. R. Ivanov
E-mail:  anton.ivanov@kot-begemot.co.uk
WWW:     http://www.kot-begemot.co.uk/


