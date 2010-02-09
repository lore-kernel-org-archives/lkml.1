Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366Ab0BIAhM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 19:37:12 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:38885 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751281Ab0BIAhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 19:37:09 -0500
X-Sasl-enc: +HIq5GZNzbLC1Z844N7szlcl7FHTw4RZCJpb8uBUsvKm 1265675829
Date: Mon, 8 Feb 2010 22:37:06 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: linux-acpi@vger.kernel.org,
       Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
       ibm-acpi-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] thinkpad-acpi: setup hotkey polling after changing
 hotkey_driver_mask
Message-ID: <20100209003706.GC21680@khazad-dum.debian.net>
References: <1265567528-1180-1-git-send-email-cascardo@holoscopio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265567528-1180-1-git-send-email-cascardo@holoscopio.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 07 Feb 2010, Thadeu Lima de Souza Cascardo wrote:
> Brightness notification does not work until the user writes to
> hotkey_mask attribute. That's because the polling thread will only run

Hmm, maybe this has something to do with it...
http://bugzilla.kernel.org/show_bug.cgi?id=15118

> if hotkey_user_mask is set and someone is reading the input device or if
> hotkey_driver_mask is set. In this second case, this condition is not
> tested after the mask is changed, because the brightness and volume
> drivers are started after the hotkey drivers.
> 
> This fix test for the polling condition that ends up starting the
> polling thread after hotkey_driver_mask is set in brightness and volume
> init functions.

tpacpi_hotkey_driver_mask_set() has to do whatever is required to get the
events to work.

I am looking into this problem now.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
