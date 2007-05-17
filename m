Return-Path: <linux-kernel-owner+w=401wt.eu-S1760061AbXEQSYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760061AbXEQSYY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 14:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756047AbXEQSYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 14:24:17 -0400
Received: from neopsis.com ([213.239.204.14]:39428 "EHLO
	matterhorn.dbservice.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754439AbXEQSYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 14:24:17 -0400
Message-ID: <464CA34F.8090509@dbservice.com>
Date: Thu, 17 May 2007 20:47:43 +0200
From: Tomas Carnecky <tom@dbservice.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070420)
MIME-Version: 1.0
To: Jiri Kosina <jikos@jikos.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: SideWinder GameVoice driver
References: <464C5FAC.8060609@dbservice.com> <Pine.LNX.4.64.0705171623280.27422@twin.jikos.cz> <464C708C.6090808@dbservice.com>
In-Reply-To: <464C708C.6090808@dbservice.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Neopsis-MailScanner-Information: Neopsis MailScanner using ClamAV and Spaassassin
X-Neopsis-MailScanner: Found to be clean
X-Neopsis-MailScanner-SpamCheck: not spam, SpamAssassin (score=-2.367,
	required 5, autolearn=spam, AWL 0.23, BAYES_00 -2.60)
X-MailScanner-From: tom@dbservice.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Additional info: HID device has two collections (whatever those are, I
have _no_ idea):

collection 00: type: 1, usage: 000b0005, level: 00000000
collection 01: type: 2, usage: 0008003a, level: 00000001

The usage of the first one means 'Telephony/Headset', the second one
'LEDs/Usage Selected Indicator' (IDs taken from [1]).

The culprit is the IS_INPUT_APPLICATION() macro, which only accepts
certain 'usage' types. Should it also accept this particular one, too,
or even the whole 'Telephony' group? Or maybe add a (configurable)
'quirk' to enable the GameVoice device?

tom

[1] http://www.freebsddiary.org/APC/usb_hid_usages.php
