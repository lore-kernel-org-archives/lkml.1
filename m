Return-Path: <linux-kernel-owner+w=401wt.eu-S1764386AbXHCWKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764386AbXHCWKb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 18:10:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762903AbXHCWKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 18:10:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54921 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762210AbXHCWKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 18:10:23 -0400
Message-ID: <46B3A7BB.9000102@redhat.com>
Date: Fri, 03 Aug 2007 18:10:03 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Muli Ben-Yehuda <muli@il.ibm.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>, riku.seppala@kymp.net
Subject: Oops in 2.6.23-rc1-git9, arch/x86_64/pci/k8-bus.c::fill_mp_bus_to_cpumask()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=250859

at line 74:

muli@62829: 
muli@62829: 					sd = bus->sysdata;
muli@62829: 					sd->node = node;   <=====

bus->sysdata is NULL.

Last changed by this hunk of
"x86-64: introduce struct pci_sysdata to facilitate sharing of ->sysdata":

@@ -67,7 +69,9 @@ fill_mp_bus_to_cpumask(void)
 						continue;
 					if (!node_online(node))
 						node = 0;
-					bus->sysdata = (void *)node;
+
+					sd = bus->sysdata;
+					sd->node = node;
 				}		
 			}
 		}

