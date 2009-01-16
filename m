Return-Path: <linux-kernel-owner+w=401wt.eu-S932323AbZAPKQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932323AbZAPKQt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 05:16:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759359AbZAPKQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 05:16:36 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:39995 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759316AbZAPKQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 05:16:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=peyua+6/v9mRk+Hix/QYbbcWhnLqtNrNwpxAygP5arFZWmn/BX9Nittq355BjyI4fi
         aM3D25ni+k/aaTkbQ+1qj4iWOG4/Tbzn8salk5KWgummTyPgo/4LgH9TJe8Pw0TEQmpr
         mFXBZQdZ/SORub4DJTvhZHBkFegwdhHI8SS/0=
Message-ID: <84144f020901160216q17f1b558q955d5b8fb7c528c0@mail.gmail.com>
Date: Fri, 16 Jan 2009 12:16:31 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Matthew Wilcox" <matthew@wil.cx>
Subject: Re: Mainline kernel OLTP performance update
Cc: "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>, chinang.ma@intel.com,
       linux-kernel@vger.kernel.org, sharad.c.tripathi@intel.com,
       arjan@linux.intel.com, andi.kleen@intel.com, suresh.b.siddha@intel.com,
       harita.chilukuri@intel.com, douglas.w.styner@intel.com,
       peter.xihong.wang@intel.com, hubert.nueckel@intel.com,
       chris.mason@oracle.com, srostedt@redhat.com, linux-scsi@vger.kernel.org,
       "Andrew Vasquez" <andrew.vasquez@qlogic.com>,
       "Anirban Chakraborty" <anirban.chakraborty@qlogic.com>,
       "Christoph Lameter" <cl@linux-foundation.org>
In-Reply-To: <20090115135236.GB29283@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <BC02C49EEB98354DBA7F5DD76F2A9E800317003CB0@azsmsx501.amr.corp.intel.com>
	 <20090115012147.GW29283@parisc-linux.org>
	 <20090114180431.f4a96543.akpm@linux-foundation.org>
	 <200901151824.38658.nickpiggin@yahoo.com.au>
	 <84144f020901150146x72402ec4p7636d583cfd55b3e@mail.gmail.com>
	 <20090115135236.GB29283@parisc-linux.org>
X-Google-Sender-Auth: 7887fc88dcb6c9d1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2009 at 11:46:09AM +0200, Pekka Enberg wrote:
>> It would also be nice if someone could do the performance analysis on
>> the SLUB bug. I ran sysbench in oltp mode here and the results look
>> like this:
>>
>>   [ number of transactions per second from 10 runs. ]
>>
>>                    min      max      avg      sd
>>   2.6.29-rc1-slab  833.77   852.32   845.10   4.72
>>   2.6.29-rc1-slub  823.61   851.94   836.74   8.57
>>
>> And no, the numbers are not flipped, SLUB beats SLAB here. :(

On Thu, Jan 15, 2009 at 3:52 PM, Matthew Wilcox <matthew@wil.cx> wrote:
> Um.  More transactions per second is good.  Your numbers show SLAB
> beating SLUB (even on your dual-CPU system).  And SLAB shows a lower
> standard deviation, which is also good.

I had lockdep enabled in my config so I ran the tests again with
x86-64 defconfig and I'm back to square one:

  [ number of transactions per second from 10 runs, bigger is better ]

                   min      max      avg      sd
  2.6.29-rc1-slab  802.02   805.37   803.93   0.97
  2.6.29-rc1-slub  807.78   811.20   809.86   1.05

                        Pekka
