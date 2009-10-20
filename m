Return-Path: <linux-kernel-owner+w=401wt.eu-S1751760AbZJTVJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751760AbZJTVJx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 17:09:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751389AbZJTVJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 17:09:52 -0400
Received: from smtp-out.google.com ([216.239.45.13]:55188 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbZJTVJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 17:09:51 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=wgYRw3KI1bU3fhTjObXlWC2yfq8Hepe42OOm75NZOR4UxKnScABpvUXUpjQTHo9hA
	nF4tyriyx7oiHKO9PZjEQ==
Date: Tue, 20 Oct 2009 14:09:45 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Alex Chiang <achiang@hp.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] mm: add numa node symlink for cpu devices in sysfs
In-Reply-To: <20091020204136.GB23675@ldl.fc.hp.com>
Message-ID: <alpine.DEB.1.00.0910201407190.27248@chino.kir.corp.google.com>
References: <20091019212740.32729.7171.stgit@bob.kio> <20091019213430.32729.78995.stgit@bob.kio> <alpine.DEB.1.00.0910192016010.25264@chino.kir.corp.google.com> <20091020204136.GB23675@ldl.fc.hp.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Oct 2009, Alex Chiang wrote:

> * David Rientjes <rientjes@google.com>:
> > On Mon, 19 Oct 2009, Alex Chiang wrote:
> > 
> > > You can discover which CPUs belong to a NUMA node by examining
> > > /sys/devices/system/node/$node/
> > > 
> > 
> > You mean /sys/devices/system/node/node# ?
> 
> Hm, in PCI land, I've been using $foo to indicate a variable in
> documentation I've written, but I can certainly use foo# if
> that's the preferred style.
> 

I'm referring to the directories in /sys/devices/system/node/ being 
'node13' for example, and not '13' as your changelog indicates.

> > > However, it's not convenient to go in the other direction, when looking at
> > > /sys/devices/system/cpu/$cpu/
> > > 
> > 
> > .../cpu/cpu# ?
> > 

Same here.

> > The return values of register_cpu_under_node() and 
> > unregister_cpu_under_node() are always ignored, so it would probably be 
> > best to convert these to be void functions.  That doesn't mean you can 
> > simply ignore the result of the first sysfs_create_link(), though: the 
> > second should probably be suppressed if the first returns an error.
> > 
> 
> I didn't want to change too much in the patch. Changing the
> function signature seems a bit overeager, but if you have strong
> feelings, I can do so.
> 

It's entirely up to you if you want to change them to be void.  I thought 
it would be cleaner if the first patch in the series would convert them to 
void on the basis that the return value is never actually used and then 
the following patches simply return on error conditions.
