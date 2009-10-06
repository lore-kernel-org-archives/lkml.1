Return-Path: <linux-kernel-owner+w=401wt.eu-S1755818AbZJFBQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818AbZJFBQQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 21:16:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754895AbZJFBQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 21:16:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:50240 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754446AbZJFBQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 21:16:15 -0400
Message-ID: <4ACA9A20.4050809@kernel.org>
Date: Tue, 06 Oct 2009 10:15:12 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Colin Guthrie <cguthrie@mandriva.org>, Kay Sievers <kay.sievers@vrfy.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: get_device_parent() race bug
References: <4ABC7DB5.9010402@kernel.org> <4AC7EDD7.3080906@kernel.org> <20091005142201.GA21891@kroah.com>
In-Reply-To: <20091005142201.GA21891@kroah.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 06 Oct 2009 01:15:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
>>>  BUG: unable to handle kernel NULL pointer dereference at 0000000000000038
>> Ping.  This one needs to be fixed in -stable.  It can be triggered by
>> other char devices too.
>
> Sorry, been slowly catching up...
> 
> This can be triggered by char devices?  Huh?  How?  I don't see the
> failure path that is happening here.

Oooh, s/char/virtual/.  The bug is in the path which creates a
directory under the phony parent.

> And char devices shouldn't really be using the kobject at all, except
> for a very basic reference count.
> 
> I keep threatening to rip kobject out of a char device and just use a
> kref, as that is all that is really needed.  Well, that and the kmap
> stuff, but again, it's not a "real" kobject being used there...
> 
> Perhaps now is the time to do this.

Yay!

-- 
tejun
