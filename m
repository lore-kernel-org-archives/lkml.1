Return-Path: <linux-kernel-owner+w=401wt.eu-S1755472AbYH0XMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472AbYH0XMi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 19:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751688AbYH0XMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 19:12:30 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:51654 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753773AbYH0XM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 19:12:29 -0400
X-Sasl-enc: jadal5D3mUA8Sk5j8ehLf9V+CRjRxjIvdp0bNtyh01nx 1219878748
Date: Wed, 27 Aug 2008 20:12:23 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: /proc/acpi/ibm/wan stopped appearing
Message-ID: <20080827231223.GB18081@khazad-dum.debian.net>
References: <48B5D11E.5090209@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B5D11E.5090209@goop.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Aug 2008, Jeremy Fitzhardinge wrote:
> /proc/acpi/ibm/wan stopped appearing for me at some point recently
> (bluetooth is still there).  I guess this has something to do with the
> RFKILL changes, but I haven't looked at them in detail.  I guess my
> question is: is this expected, and what's the "proper" way to control
> the WWAN radio now?

1. It is not expected, I have not removed /proc interface support for
anything.  Look at the thinkpad-acpi documentation, it is always (and I do
mean ALWAYS) up-to-date.

The /proc interface for thinkpad-acpi is not going away for a while yet,
unless ACPI itself decides that /proc/acpi must die.

2. The proper way to control ANY radio's rfkill functions is through the
rfkill sysfs interface.  That includes thinkpad-acpi's  bluetooth and WWAN.

IOW, we may have a regression here.  Please compile thinkpad-acpi with debug
mode enabled, load it with the "debug=0xffff" and "experimental=1"
parameters (as far as I remember, WWAN requires "experimental=1" to work,
without that it will NOT load, and you will NOT get /proc/acpi/ibm/wan or
anything else WWAN related from thinkpad-acpi), and send me the resulting
log output from thinkpad-acpi.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
