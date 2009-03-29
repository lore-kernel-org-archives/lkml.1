Return-Path: <linux-kernel-owner+w=401wt.eu-S1753487AbZC2PtE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487AbZC2PtE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 11:49:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751020AbZC2Psv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 11:48:51 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:30259 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbZC2Psv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 11:48:51 -0400
Date: Sun, 29 Mar 2009 17:48:36 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Michael E Brown <Michael_E_Brown@dell.com>
Subject: Class device namespaces
Message-ID: <20090329174836.6de797d6@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

I am a little confused by the directories created when one registers a
class device. When a class device is registered as the children of a
real device, a subdirectory by the class name is created, and the class
device is created there, effectively granting each class a separate
namespace. Example:

/sys/devices/pci0000:00/0000:00:1f.3/i2c-adapter/i2c-0

where 0000:00:1f.3 is the physical device, i2c-adapter the class name
and i2c-0 the class device.

OTOH, if I create a class device as the children of another class
device, the class device is created directly, without a directory
between the parent and the child. Example:

/sys/class/i2c-adapter/i2c-0/i2c-0

where the first i2c-0 is an i2c-adapter class device, and the second
i2c-0 is an i2c-dev class device. I would have expected:

/sys/class/i2c-adapter/i2c-0/i2c-dev/i2c-0

The current behavior seems inconsistent to me. Is it done so on purpose,
or is this accidental? If on purpose, what's the reason?

I am asking because this is causing trouble in practice. We have both
i2c-dev and firmware_class which try to create class devices by the
same name and this of course collides. While I would blame
firmware_class for coming up with an horrible naming scheme (or
actually, for not coming up with any naming scheme) it might still be a
good idea to prevent such collisions at the driver core level.

Thanks,
-- 
Jean Delvare
