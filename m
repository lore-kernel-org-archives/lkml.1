Return-Path: <linux-kernel-owner+w=401wt.eu-S1755047AbZIOQTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047AbZIOQTh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 12:19:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754116AbZIOQTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 12:19:33 -0400
Received: from mail.cs.nmsu.edu ([128.123.64.3]:38342 "EHLO mail.cs.nmsu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753390AbZIOQTc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 12:19:32 -0400
Message-ID: <aac07123ee2b14a0ac25d1652dbe0780.squirrel@intranet.cs.nmsu.edu>
Date: Tue, 15 Sep 2009 10:19:35 -0600
Subject: Using EV_MSC or extending KEY_*
From: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
To: "Linux USB" <linux-usb@vger.kernel.org>,
       "LKML" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.19
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On the Logitech G13 there are a set of 10 special keys at the top of the
device.

I've written the driver so that it maintains a map from the general keys
(G1-G22) to Linux' input subsystem keys.

The map can be changed on the fly, allowing multiple keymaps to be loaded.

As a side note I haven't provided for this functionality (multiple
keymaps) in the driver since this can be maintained from userspace, but it
does need to know about the currently loaded keymap so that when the raw
HID events are parsed the appropriate EV_KEY events can be input.

I could set it up so that the special keys also map to a KEY_* code.
However, I'd prefer to set things up so that any G1-G22 key can be mapped
to any input subsystem KEY_* code and not reserve a set of 10 from the
current KEY_* codes for the 10 special keys.

One way I was thinking of approaching this was to generate EV_MSC type
events (with a MSC_RAW code) using the value to indicate the state
(pressed/released) and special key.

Another way to approach this would be to extend the KEY_* #defines with a
special set of 10 codes for the 10 special keys.

Any suggestions on the better approach?

Thanks,

Rick


