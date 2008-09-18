Return-Path: <linux-kernel-owner+w=401wt.eu-S1755578AbYIROqJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578AbYIROqJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 10:46:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754024AbYIROp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 10:45:59 -0400
Received: from mail-in-12.arcor-online.net ([151.189.21.52]:56066 "EHLO
	mail-in-12.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753066AbYIROp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 10:45:58 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: New IOCTLs
To: Louis.Rilling@kerlabs.com, Chris Snook <csnook@redhat.com>,
       linux-kernel@vger.kernel.org,
       Singaravelan Nallasellan <singaravelann@gmail.com>
Reply-To: 7eggert@gmx.de
Date: Thu, 18 Sep 2008 16:54:47 +0200
References: <bd8Hz-6QR-17@gated-at.bofh.it> <bdbFu-2cb-23@gated-at.bofh.it> <bdjjC-3tt-7@gated-at.bofh.it> <bdnQd-13j-17@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1KgKu7-0003nd-E6@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Louis Rilling <Louis.Rilling@kerlabs.com> wrote:
> On Thu, Sep 18, 2008 at 09:53:51AM +0530, Singaravelan Nallasellan wrote:

>> Thank you for your response.
>> 
>> The driver needs to assign an id for each open and create a sysfs
>> entry based on that id and expose some properties.

> What about using configfs? A user could create an id using mkdir in the
> driver's configfs subsystem, and this would make the driver create the
> matching sysfs entry.
> 
> # mkdir /sys/kernel/config/<driver_subsys>/2
> -> reserve id 2 for the caller, and create /sys/class/xxx/<drivername>/2
> 
> You could even put whatever configuration items inside configfs instead of
> sysfs.

Sounds like simulating file descriptors, with more overhead and less
functionality, just for having non-atomic access to name->value pairs.

Besides that, we don't yet know the purpose of the IOCTL, and even less about
the driver. Maybe the user will need to read or write, too, or pass the fd
to other processes.

