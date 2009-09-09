Return-Path: <linux-kernel-owner+w=401wt.eu-S1753642AbZIITea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642AbZIITea (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 15:34:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753134AbZIITea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 15:34:30 -0400
Received: from smtp-out.google.com ([216.239.33.17]:26487 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770AbZIITe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 15:34:29 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=wSQwXKnXOZ/7wkQA/Y9fjo/D0fDv2MnJVluvndF5QJbyKHu59kxjq+CXhY8Vh5xm6
	63/zvsd30UX5HquimZfug==
Date: Wed, 9 Sep 2009 12:34:27 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Hansen <dave@linux.vnet.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/4 -mm] flex_array: poison free elements
In-Reply-To: <1252524157.14385.37942.camel@nimitz>
Message-ID: <alpine.DEB.1.00.0909091229300.32267@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0908211619270.28611@chino.kir.corp.google.com> <alpine.DEB.2.00.0908211620580.28611@chino.kir.corp.google.com> <1251129384.22398.7166.camel@nimitz> <alpine.DEB.2.00.0908241330361.5574@chino.kir.corp.google.com>
 <1251150156.22398.8289.camel@nimitz> <alpine.DEB.2.00.0908241540480.12448@chino.kir.corp.google.com> <alpine.DEB.1.00.0909081511590.26432@chino.kir.corp.google.com> <1252510129.14385.37045.camel@nimitz> <alpine.DEB.1.00.0909091217570.32267@chino.kir.corp.google.com>
 <1252524157.14385.37942.camel@nimitz>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Sep 2009, Dave Hansen wrote:

> It shouldn't be too hard to do that, though.  Although a bit silly to
> have make a copy_to_user() call for each ->parts[] page, it would be
> pretty easy to implement.  
> 

Right, but the event buffer becomes slower as a whole because of the 
multiple copy_to_user() on read, indirection into each flex_array_part, 
and add_event_entry() would now require a memcpy.
