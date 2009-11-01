Return-Path: <linux-kernel-owner+w=401wt.eu-S1751858AbZKAJ3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858AbZKAJ3f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 04:29:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751762AbZKAJ3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 04:29:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47398 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739AbZKAJ3c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 04:29:32 -0500
Message-ID: <4AED54D1.6070706@redhat.com>
Date: Sun, 01 Nov 2009 11:28:49 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       kurt.hackel@oracle.com, Glauber Costa <glommer@redhat.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>, zach.brown@oracle.com,
       Ingo Molnar <mingo@redhat.com>, chris.mason@oracle.com
Subject: Re: [Xen-devel] Re: [PATCH 3/5] x86/pvclock: add vsyscall implementation
References: <f14ec444-c388-4275-8f9d-e873d1e6ea40@default>
In-Reply-To: <f14ec444-c388-4275-8f9d-e873d1e6ea40@default>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2009 06:15 PM, Dan Magenheimer wrote:
> On a related note, though some topic drift, many of
> the problems that occur in virtualization due to migration
> could be better addressed if Linux had an architected
> interface to allow it to be signaled if a migration
> occurred, and if Linux could signal applications of
> the same.  I don't have any cycles (pun intended) to
> think about this right now, but if anyone else starts
> looking at it, I'd love to be cc'ed.
>    

IMO that's not a good direction.  The hypervisor should not depend on 
the guest for migration (the guest may be broken, or malicious, or being 
debugged, or slow).  So the notification must be asynchronous, which 
means that it will only be delivered to applications after migration has 
completed.

Instead of a "migration has occured, run for the hills" signal we're 
better of finding out why applications want to know about this event and 
addressing specific needs.

-- 
error compiling committee.c: too many arguments to function

