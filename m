Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356Ab0BINLO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 08:11:14 -0500
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:55417 "HELO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754225Ab0BINLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 08:11:11 -0500
From: Michael Poole <mdpoole@troilus.org>
To: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org
Cc: Marcel Holtmann <marcel@holtmann.org>, linux-bluetooth@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Provide a driver for the Apple Magic Mouse
References: <alpine.LNX.2.00.1001291515560.356@pobox.suse.cz>
	<dd18b0c31002082322m4238a4a6m73fc30752ba30447@mail.gmail.com>
	<1265710460.2383.5685.camel@localhost.localdomain>
	<201002090736.55576.edt@aei.ca>
	<alpine.LNX.2.00.1002091339190.30967@pobox.suse.cz>
Date: Tue, 09 Feb 2010 08:10:48 -0500
In-Reply-To: <alpine.LNX.2.00.1002091339190.30967@pobox.suse.cz> (Jiri
	Kosina's message of "Tue, 9 Feb 2010 13:40:58 +0100 (CET)")
Message-ID: <87y6j2eeqv.fsf_-_@troilus.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think this patch is ready for real review.  The Magic Mouse requires
that a driver send an unlock Report(Feature) command, similar to the
Wacom wireless tablet and Sixaxis controller quirks.  This turns on an
Input Report that isn't published in the input Report descriptor that
contains touch data (and usually overrides the normal motion and click
Report).

Because the mouse has only one switch and no scroll wheel, the driver
(under control of parameters) emulates a middle button and scroll wheel.
User space could also ignore and/or re-synthesize those events based on
the reported events.

The first patch exports hid_register_report() so the driver can turn on
the multitouch report.  The second patch adds the device ID and the
driver.  Some user-space tools to talk to the mouse directly (that is,
when it is not associated with the host's HIDP stack) are at
http://github.com/entrope/linux-magicmouse .
