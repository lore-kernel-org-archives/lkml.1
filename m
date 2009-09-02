Return-Path: <linux-kernel-owner+w=401wt.eu-S1753780AbZIBWne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780AbZIBWne (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 18:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753734AbZIBWnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 18:43:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:37390 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753673AbZIBWnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 18:43:32 -0400
Message-ID: <4A9EF510.9080902@kernel.org>
Date: Thu, 03 Sep 2009 07:43:28 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Grant Grundler <grundler@parisc-linux.org>
CC: Greg KH <greg@kroah.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, Shane Huang <Shane.Huang@amd.com>
Subject: Re: [PATCH] pci: separate out pci_add_dynid()
References: <4A9E38FA.3000506@kernel.org> <20090902161048.GA5405@lackof.org> <4A9EF402.7090800@kernel.org>
In-Reply-To: <4A9EF402.7090800@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 02 Sep 2009 22:43:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ummm... another thought.

Tejun Heo wrote:
> It's one of the gripes I've had with the driver core interface.
> Returning the object which had its reference bumped up is nice to do
> do_something(get_driver(driver)); but it should have been made clear
> that the return value always equals the input parameter.  IIRC, in the
> early days of the current driver model and kref, there were intentions
> to make kref somehow more capable and handle the last reference
> problem from within it so that if (get_driver(driver)) test is
> actually meaningful but that turned out to be not too feasible, so we
> ended up with unnecessary if () around driver model get functions.  I
> try to remove them whenever an affected piece of code is being
> modified but there still are plenty left.  I'll update comment on
> driver core get functions.

Greg, I think I suggested this before.  What do you think about just
making those get functions return void?  The current interface
combined with widespread if() around them is quite misleading.  Most
device/driver structures are inherited and extended when actually in
use, so the driver or its subsystem code usually can't do much with
the return value other than checking for bogus error condition anyway.

Thanks.

-- 
tejun
