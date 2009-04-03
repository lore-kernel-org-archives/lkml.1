Return-Path: <linux-kernel-owner+w=401wt.eu-S936056AbZDCVnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936056AbZDCVnx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 17:43:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758293AbZDCVnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 17:43:43 -0400
Received: from smtp-out.google.com ([216.239.33.17]:18961 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757631AbZDCVnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 17:43:42 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=CRy5TeE1z7lbk9pSMllv9/IgOi42Uzlfweo+ScTS6c8jS8d7DL8WmjE/wnLgWa7lz
	ybi3lIKQhS2KBOIRqOeMA==
Date: Fri, 3 Apr 2009 14:43:32 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andi Kleen <andi@firstfloor.org>
cc: Chris Worley <worleys@gmail.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Off topic: Numactl "distance" wrong
In-Reply-To: <87vdpljuqi.fsf@basil.nowhere.org>
Message-ID: <alpine.DEB.2.00.0904031438540.3646@chino.kir.corp.google.com>
References: <f3177b9e0904031302p8aef826u1874a8b9d9af0840@mail.gmail.com> <87vdpljuqi.fsf@basil.nowhere.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Apr 2009, Andi Kleen wrote:

> > Who would be the right person (or list) to talk about this?
> 
> Your BIOS vendor whose code reported the wrong values. Not that it matters
> really on small systems.
> 

The numactl --hardware values are coming directly from the sysfs per-node 
distance interface, so this may not be a result of erroneous BIOS data but 
rather the lack of a SLIT to describe the physical topology better.  When 
we lack a SLIT, nodes are simply given these remote distances of 20 
because their ids differ.

Yinghai, can you elaborate on exactly what type of interface you can 
imagine for modifying the distance for nodes through sysfs?  It seems like 
you'd have to report the entire physical topology in one write, for which 
we currently don't have an interface for beyond pxms, instead of per-node 
distances to remote nodes.
