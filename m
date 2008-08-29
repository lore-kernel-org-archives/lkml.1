Return-Path: <linux-kernel-owner+w=401wt.eu-S1757880AbYH2NgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757880AbYH2NgB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 09:36:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbYH2Nfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 09:35:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:33573 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753113AbYH2Nfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 09:35:51 -0400
Message-ID: <48B7FAEC.80206@kernel.org>
Date: Fri, 29 Aug 2008 15:34:36 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Greg KH <greg@kroah.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Zeuthen <david@fubar.dk>
Subject: Re: [PATCH 2/2] uevent: handle duplicate uevent_var keys properly
References: <48B6D28E.10006@kernel.org> <48B6D2C6.4010703@kernel.org>	 <20080828164924.GB17475@kroah.com> <48B6D9B7.2050406@kernel.org>	 <3ae72650808290048v1a5d7e51pc68270b2a8d6faa@mail.gmail.com>	 <48B7AD11.2070906@kernel.org> <1220016439.24737.18.camel@lgn.site>
In-Reply-To: <1220016439.24737.18.camel@lgn.site>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 29 Aug 2008 13:35:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Kay Sievers wrote:
>> For OSS emulation, it didn't really matter.  For cases where it matters,
>> I think easier path to take would be let the userland emulation set up a
>> directory containing pseudo files and just override DEVPATH to it.
>> Would that work?
> 
> No, I don't think so, it's a too bad hack. the SUBSYSTEM key, the entry
> in the class/bus directory, and the target of the symlink in the device
> directory _must_ match. Everything else asks for serious trouble, by the
> inconsistency it creates.

I'm afraid trying to do that from kernel side would require more scary
hack as CUSE will need to push in random device under unsuspecting
parent / class.  Maybe we can add a variable to indicate an emulated
device or to tell udev/hal whatever to use alt root for sys hierarchy or
just consider sysfs is not available?  I think this problem can be
settled between userland programs.

Thanks.

-- 
tejun
