Return-Path: <linux-kernel-owner+w=401wt.eu-S1755989AbYICJl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989AbYICJl0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 05:41:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755903AbYICJky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 05:40:54 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:44842 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755899AbYICJkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 05:40:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=DdqaZBr2Z6H1K52N+Rx8st1/hv6rWYyzKV+AXa4/wpqsdtvjaVzt6zVOCC910Z3bD4
         yTyuHWNy/AuTO+zOKY6uomU2RgJVSn9cCVreiKA6YBSViQTl/YAJ/nCOjKNnWw9ZNr5F
         eAKfpRaIuetOmlHLWSXv31LYhGjjXtb2q2Syw=
Message-ID: <84144f020809030240l265891e8gad5a2a9fced6880f@mail.gmail.com>
Date: Wed, 3 Sep 2008 12:40:51 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Steve VanDeBogart" <vandebo-lkml@nerdbox.net>
Subject: Re: [uml-devel] [PATCH 5/6] slab: Annotate slab
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@us.ibm.com>, "Ingo Molnar" <mingo@elte.hu>,
       dkegel@google.com, jiayingz@google.com,
       "John Reiser" <jreiser@bitwagon.com>
In-Reply-To: <84144f020809030227jce7d3c2wab9e9c00b2fcdfe5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.DEB.1.00.0808281139420.15543@abydos.NerdBox.Net>
	 <alpine.DEB.1.00.0808291616560.15543@abydos.NerdBox.Net>
	 <84144f020808300350i7cb2d23aj6d1ffcbeceaf7e9c@mail.gmail.com>
	 <alpine.DEB.1.00.0809022036560.15543@abydos.NerdBox.Net>
	 <84144f020809030227jce7d3c2wab9e9c00b2fcdfe5@mail.gmail.com>
X-Google-Sender-Auth: 5070bebb57002279
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 3, 2008 at 12:27 PM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> On Wed, Sep 3, 2008 at 8:08 AM, Steve VanDeBogart
> <vandebo-lkml@nerdbox.net> wrote:
>> Ideally, we'd tell Valgrind that the bytes of a free'd slab object are
>> no longer accessible, but the initialized state should remain the same
>> until the object is made accessible again by the next allocation of
>> the object.  Unfortunately, the compression method for A & V bits in
>> Valgrind doesn't allow a region to be inaccessible and retain validness
>> bits.
>
> I don't see why you should mark them initialized all the time. Just
> mark them as uninitialized on kmem_cache_free() and again as
> initialized when they're about to be returned from kmem_cache_alloc()
> like we do in kmemcheck.

Btw, actually, we don't mark them as uninitialized at the moment, but
that's a bug in kmemcheck.
