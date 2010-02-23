Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701Ab0BWHgr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 02:36:47 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:59465 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752240Ab0BWHgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 02:36:46 -0500
X-Sasl-enc: S6yz3tIf8osXQm/5+KjZBWF7X6dzsHXVXiZQOR3JCoYc 1266910605
Message-ID: <4B83858C.8010305@ladisch.de>
Date: Tue, 23 Feb 2010 08:36:44 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: ibm-acpi-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] thinkpad-acpi: fix return value of volume callbacks
References: <4B825228.8050405@ladisch.de> <20100223031220.GI30470@khazad-dum.debian.net>
In-Reply-To: <20100223031220.GI30470@khazad-dum.debian.net>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Henrique de Moraes Holschuh wrote:
> On Mon, 22 Feb 2010, Clemens Ladisch wrote:
> > Fix up the volume status setting functions to return a non-zero value if
> > the control value has changed, so that the ALSA framework can correctly
> > generate control change notifications.
> 
> Please explain...

ALSA sends notifications to all mixer application when the value of
any mixer control has changed.  To be able to avoid sending them for
controls that did not actually change, it uses the return value of the
.put callback: 0 means the control value did not change; 1 means it has
changed (or might have changed), and a notification is to be sent.
<http://www.alsa-project.org/~tiwai/writing-an-alsa-driver/ch06s05.html#control-interface-callbacks-put>


Regards,
Clemens
