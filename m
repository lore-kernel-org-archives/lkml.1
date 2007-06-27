Return-Path: <linux-kernel-owner+w=401wt.eu-S1761434AbXF0URT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761434AbXF0URT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 16:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753968AbXF0URL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 16:17:11 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:28799 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718AbXF0URL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 16:17:11 -0400
Date: Wed, 27 Jun 2007 22:17:09 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Chuck Ebbert <cebbert@redhat.com>
cc: corentincj@iksaif.net, sziwan@users.sourceforge.net,
       acpi4asus-user@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Oops on rmmod asus_acpi
In-Reply-To: <4682C557.8010207@redhat.com>
Message-ID: <Pine.LNX.4.64.0706272216300.11120@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0706272113120.11120@fbirervta.pbzchgretzou.qr>
 <4682C557.8010207@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 27 2007 16:15, Chuck Ebbert wrote:
>The device's klist_node is not on any list (n->n_klist == NULL)
>in klist_del:
>
>void klist_del(struct klist_node * n)
>{
>        struct klist * k = n->n_klist;
>===>    void (*put)(struct klist_node *) = k->put;
>
>So the driver gets totally screwed up if it loads, finds no compatible
>hardware and then you try to unload it.

Then it should probably not load at all (return with -ENODEV).


	Jan
-- 
