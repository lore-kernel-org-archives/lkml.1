Return-Path: <linux-kernel-owner+w=401wt.eu-S1753063AbZJQSXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063AbZJQSXa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 14:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751984AbZJQSX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 14:23:29 -0400
Received: from ppsw-5.csi.cam.ac.uk ([131.111.8.135]:37553 "EHLO
	ppsw-5.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbZJQSX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 14:23:29 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4ADA0BC9.4010506@cam.ac.uk>
Date: Sat, 17 Oct 2009 19:24:09 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20091007)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Jean Delvare <khali@linux-fr.org>,
       Zhang Rui <rui.zhang@intel.com>
Subject: Best option for handling dependencies between sysfs params.
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear All,

The tsl2561 ambient light sensor has separate controls for integration
time and for gain.

Now, discussions about the tsl2550 driver suggested that range be handled
by an illuminance0_max_range parameter.  In that particular device things
are simple as there is one internal variable effecting the range.

So to try and match interfaces, I'm intending to have the
same illuminance0_max_range and also an integration time parameter.
(avoiding for now the more complex manual option!)

My current approach is to use writes to illuminance0_max_range to store
a 'requested' max gain value.  Thus a later change to the integration time
parameter may well result in the internal gain parameter also changing
in order to meet this desired value.

Reading this parameter will always return the max range value for
the current configuration.

Do people think this is a valid approach?  More or less corresponds to 
'integration time priority' in the language of photography. In effect
it makes the internal gain an automatic parameter rather than integration
time. Could just as easily do the other way round though.

All comments welcome.

Jonathan
