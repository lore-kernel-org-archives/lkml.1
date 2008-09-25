Return-Path: <linux-kernel-owner+w=401wt.eu-S1755435AbYIYNAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbYIYNAs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 09:00:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753927AbYIYNAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 09:00:37 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:60255 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755357AbYIYNAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 09:00:35 -0400
Message-ID: <48DB8AE6.2080607@fr.ibm.com>
Date: Thu, 25 Sep 2008 14:58:14 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: Oren Laadan <orenl@cs.columbia.edu>, dave@linux.vnet.ibm.com,
       containers@lists.linux-foundation.org, jeremy@goop.org,
       linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [RFC v5][PATCH 0/9] Kernel based checkpoint/restart
References: <1221347167-9956-1-git-send-email-orenl@cs.columbia.edu> <20080924214242.GA27875@us.ibm.com>
In-Reply-To: <20080924214242.GA27875@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn wrote:
> Quoting Oren Laadan (orenl@cs.columbia.edu):
>> These patches implement basic checkpoint-restart [CR]. This version (v5)
>> supports basic tasks with simple private memory, and open files (regular
>> files and directories only). The main changes include rework of memory
>> restart code and response to feedback. See original announcements below.
>>
>> Oren.
> 
> Playing around a bit, all seems to work as advertised.
> 
> Has anyone playing with this run into any oopses with the latest
> version?
> 
> Cedric, could you send out your patch (or a pointer to them) to make
> ckpt/restart on another task work, so we can pound the core code a bit
> harder with liblxc?

sure. the user tools are in CVS for the moment :

	http://lxc.cvs.sourceforge.net/lxc/

but Daniel will probably release something soon. the lxc-checkpoint and 
lxc-restart tools are a bit too optimistic on the availability of the 
checkpoint and restart syscalls, a cleanup might be needed.

the patchset is here :

	http://legoater.free.fr/patches/2.6.27/2.6.27-rc7-lxc2/

it's based on top of current mainline and includes :

	. sysfs patches for net namespace
	. freezer subsystem
	. oren's V5 checkpoint and restart patches
	. a personal hack to do external checkpoint and restart using
	  the lxc-checkpoint and lxc-restart tools
	. some fixes
	
and also

	an old mq namespace implementation (being reworked currently)

restart is still bogus because some state is not well captured at
checkpoint time. 

I'm working on it right now !

Thanks,

C.
