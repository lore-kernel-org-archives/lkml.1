Return-Path: <linux-kernel-owner+w=401wt.eu-S1754996AbYLJAnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996AbYLJAnU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 19:43:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752098AbYLJAnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 19:43:10 -0500
Received: from rn-out-0910.google.com ([64.233.170.187]:54845 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbYLJAnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 19:43:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=LOUpg5BEH6hMBI6zPSR5JJwenQGkM1XAuVMt/RwRhANm4x3HAtDiWBUgrx3sLaNhLZ
         oalVoGhH6ujlhD3NH/V6PKvtbxySQKV/j5siy2PmDOO0S8TEplsrGeXZIOvL/0bU0MDT
         XeCOQtzuyrAEWcaTKR+lUpdqeXeUWTZJz2LU4=
Message-ID: <21d7e9970812091643n7e3e4fe5g8e44030adfbababa@mail.gmail.com>
Date: Wed, 10 Dec 2008 10:43:07 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [patch 021/104] lib/idr.c: fix rcu related race with idr_find
Cc: "Greg KH" <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       stable@kernel.org, "Justin Forbes" <jmforbes@linuxtx.org>,
       "Zwane Mwaikambo" <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, "Randy Dunlap" <rdunlap@xenotime.net>,
       "Dave Jones" <davej@redhat.com>,
       "Chuck Wolber" <chuckw@quantumlinux.com>,
       "Chris Wedgwood" <reviews@ml.cw.f00f.org>,
       "Michael Krufky" <mkrufky@linuxtv.org>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       "Domenico Andreoli" <cavokz@gmail.com>, "Willy Tarreau" <w@1wt.eu>,
       "Rodrigo Rubira Branco" <rbranco@la.checkpoint.com>,
       "Jake Edge" <jake@lwn.net>, "Eugene Teo" <eteo@redhat.com>,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Manfred Spraul" <manfred@colorfullife.com>,
       "Clement Calmels" <cboulte@gmail.com>,
       "Nadia Derbey" <Nadia.Derbey@bull.net>,
       "Pierre Peiffer" <peifferp@gmail.com>
In-Reply-To: <alpine.LFD.2.00.0812091447230.3340@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081203193901.715896543@mini.kroah.org>
	 <20081203194725.GA8950@kroah.com> <20081203194906.GV8950@kroah.com>
	 <21d7e9970812091340p5121e8f8l1e2411035331e8d0@mail.gmail.com>
	 <alpine.LFD.2.00.0812091447230.3340@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2008 at 8:47 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Wed, 10 Dec 2008, Dave Airlie wrote:
>>
>> On Thu, Dec 4, 2008 at 5:49 AM, Greg KH <gregkh@suse.de> wrote:
>> > 2.6.27-stable review patch.  If anyone has any objections, please let us know.
>> >
>> Revert.
>>
>> This caused problems in the F10 kernel with idr, the drm device alloc
>> went all wierd,
>> it might be a drm bug but changing this code triggers it and so it
>> isn't really "stable"
>
> Well, maybe it should be reverted in mainlne too, then?

It appears idr_replace is broken at least in stable with this patch.

I'm trying to track down where the problem is (idr_replace doesn't look like
idr_find in a lot of places and I wonder if this has ever been tested.)

Dave.
