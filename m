Return-Path: <linux-kernel-owner+w=401wt.eu-S1756824AbZETTSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824AbZETTSc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 15:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755445AbZETTSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 15:18:25 -0400
Received: from exprod6og110.obsmtp.com ([64.18.1.25]:54237 "HELO
	exprod6og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754839AbZETTSY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 15:18:24 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH] mm/slub.c: Use print_hex_dump and remove unnecessary cast
Date: Wed, 20 May 2009 15:18:22 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE1909017FEF96@mi8nycmail19.Mi8.com>
In-Reply-To: <1242844966.22786.52.camel@Joe-Laptop.home>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] mm/slub.c: Use print_hex_dump and remove unnecessary cast
Thread-Index: AcnZet0mdtk4MGyxT1W4I8Q4e54vmgABCDkg
References: <1242840314-25635-1-git-send-email-joe@perches.com> <alpine.DEB.1.10.0905201420050.17511@qirst.com> <1242844966.22786.52.camel@Joe-Laptop.home>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "Joe Perches" <joe@perches.com>,
       "Christoph Lameter" <cl@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
       "Matt Mackall" <mpm@selenic.com>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>, "Ingo Molnar" <mingo@elte.hu>,
       "David Rientjes" <rientjes@google.com>,
       "Eduard - Gabriel Munteanu" <eduard.munteanu@linux360.ro>
X-OriginalArrivalTime: 20 May 2009 19:18:24.0139 (UTC) FILETIME=[BEC475B0:01C9D97F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 20, 2009 11:43 AM, Joe Perches wrote:
> On Wed, 2009-05-20 at 14:23 -0400, Christoph Lameter wrote:
>> This was discussed before.
>> http://lkml.indiana.edu/hypermail/linux/kernel/0705.3/2671.html
>
> You've got a good memory.
>
>> Was hexdump changed?
>
> It seems not.
>
>> How does the output look after this change?
>>
>> From reading the code, the last column is unaligned.
>
> I did submit a patch to fix hexdump once.
> http://lkml.org/lkml/2007/12/6/304

>From what I can tell the current code does properly align the
ascii output.

I just chopped the necessary functions out of the kernel and
created a test program.  If I pass the string:

"This is a sample buffer"

I get the following output:

prefix_type = DUMP_PREFIX_NONE

<7>buffer: 54 68 69 73 20 69 73 20 61 20 73 61 6d 70 6c 65  This is a sample
<7>buffer: 20 62 75 66 66 65 72                              buffer

prefix_type = DUMP_PREFIX_ADDRESS

<7>buffer: 0x804a008: 54 68 69 73 20 69 73 20 61 20 73 61 6d 70 6c 65  This is a sample
<7>buffer: 0x804a018: 20 62 75 66 66 65 72                              buffer

prefix_type = DUMP_PREFIX_OFFSET

<7>buffer: 00000000: 54 68 69 73 20 69 73 20 61 20 73 61 6d 70 6c 65  This is a sample
<7>buffer: 00000010: 20 62 75 66 66 65 72                              buffer

Regards,
Hartley
