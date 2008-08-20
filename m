Return-Path: <linux-kernel-owner+w=401wt.eu-S1756415AbYHTBm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756415AbYHTBm0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 21:42:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752468AbYHTBmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 21:42:17 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:34668 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbYHTBmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 21:42:16 -0400
Date: Wed, 20 Aug 2008 02:42:11 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Andrew Morton <akpm@linux-foundation.org>, corentincj@iksaif.net,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Awkward rfkill corner cases
Message-ID: <20080820014211.GA7592@srcf.ucam.org>
References: <20080804170833.GA9513@srcf.ucam.org> <20080806092352.GA17801@srcf.ucam.org> <20080806092523.GB17801@srcf.ucam.org> <20080819025815.b5ec1a4c.akpm@linux-foundation.org> <20080819111320.GA19223@srcf.ucam.org> <20080819230950.GC29336@khazad-dum.debian.net> <20080819232411.GA5421@srcf.ucam.org> <20080820011828.GD29336@khazad-dum.debian.net> <20080820012846.GA7467@srcf.ucam.org> <20080820013214.GF29336@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080820013214.GF29336@khazad-dum.debian.net>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2008 at 10:32:14PM -0300, Henrique de Moraes Holschuh wrote:

> Then, I have no futher comments.  Looks good to me.

Excellent, glad I've got that right.

One completely unrelated question. In the following situation (relevant 
to Dells, not the Eee)

* The system has a key (not a switch) that in firmware disables the 
hardware (HARD_BLOCKED)
* That key generates an event through the keyboard controller, but not 
through any other obviously detectable means
* The radio control is also controllable through software (SOFT_BLOCKED)

Should pressing the key generate a KEY_WLAN event?

I note that rfkill-input will, if the device is in HARD_BLOCKED state, 
attempt to set it to UNBLOCKED. This sounds like generating the keycode 
is the wrong thing to do, since it'll cause rfkill-input to try to undo 
the change that's just been made. However, if the key isn't mapped 
there's no obvious way for any of the stack to determine that a change 
has been made and propagate that to userspace. What should we be doing 
here?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
