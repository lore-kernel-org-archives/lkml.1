Return-Path: <linux-kernel-owner+w=401wt.eu-S1752782AbYIYHH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbYIYHH5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 03:07:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753638AbYIYHHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 03:07:46 -0400
Received: from brak.cowlabs.com ([208.96.51.45]:43473 "EHLO brak.cowlabs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753634AbYIYHHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 03:07:45 -0400
Date: Thu, 25 Sep 2008 00:07:41 -0700
From: carbonated beverage <ramune@net-ronin.org>
To: linux-kernel@vger.kernel.org
Subject: CONFIG_ACPI_VIDEO on Thinkpad blanks display.
Message-ID: <20080925070741.GA22376@net-ronin.org>
References: <20080925060244.GA18945@net-ronin.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080925060244.GA18945@net-ronin.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2008 at 11:02:44PM -0700, carbonated beverage wrote:
> I just upgraded from 2.6.25.17 to 2.6.26.5 on my Thinkpad Z61t, and found
> the brightness keys will cause the X server to die.  When using the
> brightness up/down keys, the screen will go blank -- Control+Alt+F# will
> still switch to a different virtual console, but switching back will not
> restore the video state.

(Subject changed to match the observed cause)

Figured out what the change was -- in 2.6.25.x, the brightness keys worked
without setting CONFIG_ACPI_VIDEO.  However, in 2.6.26.x, the brightness keys
do not work on the console without that enabled.

If 2.6.25.x has that config option enabled, I still get the same blank screen
symptoms -- with the following in the X logs:

(II) PM Event received: Capability Changed
I830PMEvent: Capability change
(II) I810(0): Next ACPI _DGS [0] 0x80000100
(II) I810(0): ACPI Toggle devices 0x1
(II) I810(0): ACPI Toggle to 0x1
(II) I810(0): Hotkey switch to 0x800.
(II) I810(0): Attachable device 0x80000100.
(II) I810(0): Attachable device 0x80000240.
(II) I810(0): Attachable device 0x80000410.
(II) I810(0): Requested display devices 0x800.
(II) I810(0): Toggle (1) 0x1
(II) I810(0): Detected duplicate devices. Toggling (0x1)
(II) I810(0): Detected display change operation (0x0, 0x800, 0x1).
(II) I810(0): Clearing Clone mode
(II) I810(0): Primary pipe is now A.
(--) I810(0): A non-CRT device is attached to pipe A.
        No refresh rate overrides will be attempted.
(II) I810(0): Display plane A is enabled and connected to Pipe A.
(II) I810(0): Display plane B is disabled and connected to Pipe B.
(II) I810(0): Enabling plane A.
(II) I810(0): Display plane A is now enabled and connected to Pipe A.
(II) I810(0): Display plane B is now disabled and connected to Pipe B.
(II) I810(0): PIPEACONF is 0x80000000
(II) I810(0): PIPEBCONF is 0x00000000
(II) I810(0): Mode bandwidth is 58 Mpixel/s
(II) I810(0): maxBandwidth is 1152 Mbyte/s, pipe bandwidths are 48 Mbyte/s, 0 Mb
yte/s
(WW) I810(0): Changing XVideo pipe (1 to 0).

Without CONFIG_ACPI_VIDEO, the above message don't appear.  From this point,
any pointers on figuring out why the ACPI features makes the screen go blank?

-- DN
Daniel
