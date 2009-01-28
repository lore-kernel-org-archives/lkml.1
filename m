Return-Path: <linux-kernel-owner+w=401wt.eu-S1754464AbZA1I6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464AbZA1I6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 03:58:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752273AbZA1I6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 03:58:08 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:1469 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbZA1I6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 03:58:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ZddScWTt/BdV4VQjetyQn/Z5Y0Wm7VzS7NoI8AvcC6zqlU2xjj1FWA4Ph5qC3TR6/9
         KE+sBNXkdAvJftfmEw71qZRXDeZlVCq/QcMzUN6K3u4gBUoN2BXdKxbxGEPbaNyllpSR
         HxpgIxqG4LWARjfgBq5IowLQef2hJL6cqSkr0=
MIME-Version: 1.0
In-Reply-To: <1233132733.16201.0.camel@penberg-laptop>
References: <alpine.DEB.2.00.0901271859010.17612@chino.kir.corp.google.com>
	 <1233132733.16201.0.camel@penberg-laptop>
Date: Wed, 28 Jan 2009 10:58:03 +0200
X-Google-Sender-Auth: 298dfac111fe5112
Message-ID: <84144f020901280058h36fedf37j600185c255db5e2a@mail.gmail.com>
Subject: Re: [patch] slub: fix per cpu kmem_cache_cpu array memory leak
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-27 at 18:59 -0800, David Rientjes wrote:
>> The per cpu array of kmem_cache_cpu structures accomodates
>> NR_KMEM_CACHE_CPU such structs.
>>
>> When this array overflows and a struct is allocated by kmalloc(), it may
>> have an address at the upper bound of this array.  If this happens, it
>> does not get freed and the per cpu kmem_cache_cpu_free pointer will be out
>> of bounds after kmem_cache_destroy() or cpu offlining.
>>
>> Cc: Christoph Lameter <cl@linux-foundation.org>
>> Signed-off-by: David Rientjes <rientjes@google.com>

On Wed, Jan 28, 2009 at 10:52 AM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> Applied, thanks!

Btw, did you hit this bug during testing or did you just spot it
during review? That is, do we need to get this to -stable?
