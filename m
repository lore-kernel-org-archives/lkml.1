Return-Path: <linux-kernel-owner+w=401wt.eu-S1758773AbZCCQS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758773AbZCCQS1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 11:18:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755036AbZCCQSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 11:18:17 -0500
Received: from mtagate5.de.ibm.com ([195.212.29.154]:55317 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507AbZCCQSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 11:18:16 -0500
Message-ID: <49AD581F.2090903@free.fr>
Date: Tue, 03 Mar 2009 17:17:35 +0100
From: Cedric Le Goater <legoater@free.fr>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: "Serge E. Hallyn" <serue@us.ibm.com>, linux-api@vger.kernel.org,
       containers@lists.linux-foundation.org, mpm@selenic.com,
       linux-kernel@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>,
       linux-mm@kvack.org, tglx@linutronix.de, viro@zeniv.linux.org.uk,
       hpa@zytor.com, Ingo Molnar <mingo@elte.hu>,
       torvalds@linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>, xemul@openvz.org
Subject: Re: How much of a mess does OpenVZ make? ;) Was: What can OpenVZ
 do?
References: <1234467035.3243.538.camel@calx>	<20090212114207.e1c2de82.akpm@linux-foundation.org>	<1234475483.30155.194.camel@nimitz>	<20090212141014.2cd3d54d.akpm@linux-foundation.org>	<1234479845.30155.220.camel@nimitz>	<20090226162755.GB1456@x200.localdomain>	<20090226173302.GB29439@elte.hu>	<20090226223112.GA2939@x200.localdomain>	<20090301013304.GA2428@x200.localdomain>	<20090301200231.GA25276@us.ibm.com> <20090301205659.GA7276@x200.localdomain>
In-Reply-To: <20090301205659.GA7276@x200.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> 1. cap_sys_admin check is unfortunate.  In discussions about Oren's
>> patchset we've agreed that not having that check from the outset forces
>> us to consider security with each new patch and feature, which is a good
>> thing.
> 
> Removing CAP_SYS_ADMIN on restore?

we've kept the capabilities in our patchset but the user tools doing checkpoint
and restart are setcap'ed appropriately to be able to do different things like : 
	
	clone() the namespaces
	mount /dev/mqueue
	interact with net_ns
	etc.

at restart, the task are restarted through execve() so they loose their 
capabilities automatically.

but I think we could drop the CAP_SYS_ADMIN tests for some namespaces,
uts and ipc are good candidates. I guess network should require some 
privilege.  

C.  
