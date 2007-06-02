Return-Path: <linux-kernel-owner+w=401wt.eu-S1760170AbXFBAC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760170AbXFBAC3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 20:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754859AbXFBACW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 20:02:22 -0400
Received: from pool-151-205-99-173.ny325.east.verizon.net ([151.205.99.173]:54813
	"HELO gatworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753968AbXFBACV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 20:02:21 -0400
Message-ID: <4660B38A.3040908@gatworks.com>
Date: Fri, 01 Jun 2007 20:02:18 -0400
From: Uncle George <netbeans@gatworks.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
CC: linux-kernel@vger.kernel.org
Subject: Re: SELECT() returns 1 But FIONREAD says (Input/output error)
References: <fa.qaWJQn9l1jDV+N9wFv9WqATf44U@ifi.uio.no> <fa.pq45zUHWQMSHoRGL/M4uTPfFWHg@ifi.uio.no> <465F891B.1080103@shaw.ca>
In-Reply-To: <465F891B.1080103@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:

> It's because you haven't done anything to handle the error which is 
> still persisting. Likely the only thing sane you can do in this case is 
> close the fd and try to reopen it later.
> 
This seems to be true, but not for what you might think.

It appears that if u plug the USB/serial device back into the usb-hub, 
the code creates a /dev/ttyUSB1 ( if you have not yet closed the 
disconnected /dev/ttyUSB0. ) When you do close /dev/ttyUSB0, then the 
device is erased from the /dev directory.

Now /dev/ttyUSB1 is the device. And /dev/ttyUSB0 disappeared. This does 
not seem proper. As now the program has no idea or capability to re-open 
the GPS device.

I have been informed that this was an approved kernel feature. Is this 
suppose to happen? Or was it an unintended consequence?
