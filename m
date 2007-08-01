Return-Path: <linux-kernel-owner+w=401wt.eu-S1758135AbXHAQY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758135AbXHAQY4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 12:24:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750955AbXHAQYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 12:24:49 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:58253 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751486AbXHAQYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 12:24:47 -0400
X-Sasl-enc: E921xGYp/YtF+omTFYenqydpeM/v7Dbp0B5yBbXjHzuq 1185985486
Date: Wed, 1 Aug 2007 13:24:42 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
Cc: Hugh Dickins <hugh@veritas.com>, Len Brown <len.brown@intel.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org, ibm-acpi-devel@lists.sourceforge.net,
       Richard Hughes <hughsient@gmail.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: THINKPAD_ACPI_INPUT_ENABLED seems regressive
Message-ID: <20070801162442.GO23111@khazad-dum.debian.net>
References: <Pine.LNX.4.64.0708011327200.4615@blonde.wat.veritas.com> <20070801153602.GJ23111@khazad-dum.debian.net> <20070801160805.GB11758@mellanox.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070801160805.GB11758@mellanox.co.il>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 01 Aug 2007, Michael S. Tsirkin wrote:
> Forcing the selection at compile-time isn't such a great idea IMHO.
> Isn't there a way to support both old and new userspace?

It only afects the *defaults* of various driver knobs that can be freely
modified at runtime:

without THINKPAD_ACPI_INPUT_ENABLED:
	hotkey_enable = 0
	hotkey_mask unchanged from whatever is already set

	hot keys from ibm-acpi 0.14 are mapped to KEY_UNKNOWN, and thus will
	generate ACPI events if hotkey_enabled is set to 1.

with THINKPAD_ACPI_INPUT_ENABLED:
	hotkey_enable = 1
	hotkey_mask = hotkey_recommended_mask

	most hot keys are mapped to something other than KEY_UNKNOWN, and
	thus will not generate ACPI events but rather input layer events.

You should select whichever works better with your userspace.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
