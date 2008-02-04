Return-Path: <linux-kernel-owner+w=401wt.eu-S1756749AbYBDW0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749AbYBDW0S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 17:26:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754969AbYBDW0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 17:26:09 -0500
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:58567 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754875AbYBDW0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 17:26:08 -0500
X-Greylist: delayed 1600 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Feb 2008 17:26:08 EST
Message-ID: <47A78AB9.5020901@hotmail.com>
Date: Mon, 04 Feb 2008 22:59:21 +0100
From: Roel kluin <rjckluin@hotmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: ibm-acpi@hmh.eng.br, len.brown@intel.com
CC: linux-acpi@vger.kernel.org, ibm-acpi-devel@lists.sourceforge.net,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH][drivers/misc/thinkpad_acpi.c] duplicate test 'if (level &
 TP_EC_FAN_FULLSPEED)'
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

in drivers/misc/thinkpad_acpi.c, lines 4137-4142 it reads:

                /* safety net should the EC not support AUTO
                 * or FULLSPEED mode bits and just ignore them */
                if (level & TP_EC_FAN_FULLSPEED)
                        level |= 7;     /* safety min speed 7 */
                else if (level & TP_EC_FAN_FULLSPEED)
                        level |= 4;     /* safety min speed 4 */

note the nonsense duplicate test 'if (level & TP_EC_FAN_FULLSPEED)'.
should this be changed to:

                if (level & TP_EC_FAN_FULLSPEED)
                        level |= 7;     /* safety min speed 7 */
                else
                        level |= 4;     /* safety min speed 4 */

or maybe

                if (level & TP_EC_FAN_FULLSPEED)
                        level |= 7;     /* safety min speed 7 */
                if (level & TP_EC_FAN_FULLSPEED)
                        level |= 4;     /* safety min speed 4 */

?
