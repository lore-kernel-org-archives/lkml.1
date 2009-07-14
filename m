Return-Path: <linux-kernel-owner+w=401wt.eu-S1755126AbZGNPb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126AbZGNPb3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 11:31:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755105AbZGNPb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 11:31:28 -0400
Received: from d1.icnet.pl ([212.160.220.21]:44666 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755099AbZGNPb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 11:31:27 -0400
Message-ID: <4A5CA4CB.8070500@tis.icnet.pl>
Date: Tue, 14 Jul 2009 17:31:23 +0200
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System
User-Agent: IceDove 1.5.0.14pre (X11/20080304)
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
       "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Subject: [RFC] tty (or char) bus?
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In my attempt to add support for contols to a voice modem codec sound 
device driver, I found that in order to talk to the modem, it would be 
convenient if I can get access to a tty device from inside the kernel in 
a way similiar to that available form userspace. AFAICS, even if tty 
lowlevel write() could be used unmodified, a convenient way of reading 
characters from a tty is missing and should be implemented in a line 
discipline. Please correct me if I am wrong.

OTOH, I found that some kind of abstraction layer for acccessing devices 
over a tty could be convenient. Instead of allocating a new line 
discipline for each specific device, sometimes found on a specific board 
only, why not just create a new bus type?

Implemented as a line discipline, activated (hot-plugged) from userspace 
with ldattach, that new bus adapter would give kernel level access to an 
arbitrary device hanging off a tty. As the bus can be assumed 
point-to-point, a single generic device could be registered 
automatically in order to trigger that bus registerd drivers' probes 
(vendor/model id queries, for example). If not enough, an ioctl and a 
ldattach replacement could be provided for setting up a device id that 
would match a driver id (something like inputattach does for N_MOUSE).

Once detected by a voice modem codec driver tty bus probe(), a codec 
subdevice could then be registered with a sound card.

Please let me know if you like the idea. If not, please push me in a 
better direction.

Many of the new code could be probably based on currently existing 
drivers and line discplines. As I'm not familiar enough with the linux 
kernel code, unlike most of you, so please give me some hints on what 
specific drivers should I look at to get examples best matching my idea.

Thanks,
Janusz
