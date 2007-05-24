Return-Path: <linux-kernel-owner+w=401wt.eu-S1759995AbXEXBRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759995AbXEXBRr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 21:17:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757384AbXEXBRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 21:17:40 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:43752 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757306AbXEXBRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 21:17:39 -0400
Date: Wed, 23 May 2007 18:21:45 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc2-mm1
Message-Id: <20070523182145.7d7f1f7e.randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.64.0705231635370.23144@schroedinger.engr.sgi.com>
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org>
	<46540DB2.5000605@googlemail.com>
	<Pine.LNX.4.64.0705231016330.20031@schroedinger.engr.sgi.com>
	<4654AC94.6080601@googlemail.com>
	<20070523150122.f9946f37.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0705231526350.22666@schroedinger.engr.sgi.com>
	<20070523153730.e0e9e91d.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0705231635370.23144@schroedinger.engr.sgi.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2007 16:36:07 -0700 (PDT) Christoph Lameter wrote:

> On Wed, 23 May 2007, Andrew Morton wrote:
> 
> > A few words in slub.txt, perhaps?

Thanks for the update.  A few nits below.

> SLUB: More documentation
> 
> Update documentation to describe how to read a SLUB error report.
> Add slub parameters to Documentation/kernel-parameters.
> 
> Signed-off-by: Christoph Lameter <clameter@sgi.com>
> 
> ---
>  Documentation/kernel-parameters.txt |   37 +++++++++-
>  Documentation/vm/slub.txt           |  133 +++++++++++++++++++++++++++++++++---
>  2 files changed, 157 insertions(+), 13 deletions(-)
> 
> Index: slub/Documentation/kernel-parameters.txt
> ===================================================================
> --- slub.orig/Documentation/kernel-parameters.txt	2007-05-23 15:41:58.000000000 -0700
> +++ slub/Documentation/kernel-parameters.txt	2007-05-23 15:57:07.000000000 -0700
> @@ -1610,6 +1610,37 @@ and is between 256 and 4096 characters. 
>  
>  	slram=		[HW,MTD]
>  
> +	slub_debug	[MM, SLUB]
> +			Enabling slub_debug will allow to determine the culprit

			s/will allow/allows/
	then
			allows _____ (the verb needs an object)
			e.g., someone | us | you (clameter@sgi.com :)

> +			if slab objects become corrupted. Enabling slub_debug
> +			creates guard zones around objects and poisons objects
> +			when not in use. Also tracks the last alloc / free.
> +			For more information see Documentation/vm/slub.txt.
> +
> +	slub_max_order= [MM, SLUB]
> +			Determines the maximum allowed order for slabs. Setting
> +			this too high may cause fragmentation.
> +			For more information see Documentation/vm/slub.txt.
> +
> +	slub_min_objects=	[M, SLUB]

				MM

> +			The minimum objects per slab. SLUB will increase the
> +			slab order up to slub_max_order to generate a
> +			sufficiently big slab to satisfy the number of objects.
> +			The higher the number of objects the smaller the overhead
> +			of tracking slabs.
> +			For more information see Documentation/vm/slub.txt.
> +

> Index: slub/Documentation/vm/slub.txt
> ===================================================================
> --- slub.orig/Documentation/vm/slub.txt	2007-05-23 15:59:05.000000000 -0700
> +++ slub/Documentation/vm/slub.txt	2007-05-23 16:34:20.000000000 -0700
> @@ -1,13 +1,9 @@
>  Short users guide for SLUB
>  --------------------------
>  
> -First of all slub should transparently replace SLAB. If you enable
> -SLUB then everything should work the same (Note the word "should".
> -There is likely not much value in that word at this point).
> -
>  The basic philosophy of SLUB is very different from SLAB. SLAB
>  requires rebuilding the kernel to activate debug options for all
> -SLABS. SLUB always includes full debugging but its off by default.
> +slab caches. SLUB always includes full debugging but its off by default.

                                                        it is

>  SLUB can enable debugging only for selected slabs in order to avoid
>  an impact on overall system performance which may make a bug more
>  difficult to find.
> @@ -76,13 +72,28 @@ of objects.
>  Careful with tracing: It may spew out lots of information and never stop if
>  used on the wrong slab.
>  
> -SLAB Merging
> +Slab merging
>  ------------
>  
> -If no debugging is specified then SLUB may merge similar slabs together
> +If no debug options are specified then SLUB may merge similar slabs together
>  in order to reduce overhead and increase cache hotness of objects.
>  slabinfo -a displays which slabs were merged together.
>  
> +Slab validation
> +---------------
> +
> +SLUB can validate all object if the kernel was booted with slub_debug. In
> +order to do so you must have the slabinfo tool. Then you can do
> +
> +slabinfo -v
> +
> +which will test all objects. Output will be generated to the syslog.
> +
> +This also works in a more limited way if boot was without slab debug.
> +In that case slabinfo -v will simply tests all reachable objects. Usually

                      drop: will

> +these are in the cpu slabs and the partial slabs. Full slabs are not

                    CPU

> +tracked by SLUB in a non debug situation.
> +
>  Getting more performance
>  ------------------------
>  
> @@ -91,9 +102,9 @@ list_lock once in a while to deal with p
>  governed by the order of the allocation for each slab. The allocations
>  can be influenced by kernel parameters:
>  
> -slub_min_objects=x		(default 8)
> +slub_min_objects=x		(default 4)
>  slub_min_order=x		(default 0)
> -slub_max_order=x		(default 4)
> +slub_max_order=x		(default 1)
>  
>  slub_min_objects allows to specify how many objects must at least fit
>  into one slab in order for the allocation order to be acceptable.
> @@ -109,5 +120,107 @@ longer be checked. This is useful to avo
>  super large order pages to fit slub_min_objects of a slab cache with
>  large object sizes into one high order page.
>  
> +SLUB Debug output
> +-----------------
> +
> +Here is a sample of slub debug output:
> +
> +@@@ SLUB kmalloc-8: Restoring redzone (0xcc) from 0xc90f6d28-0xc90f6d2b
> +
...
> +
> +If SLUB encounters a corrupted object then it will perform the following
> +actions

   actions:

> +
> +1. Isolation and report of the issue
> +
> +This will be a message in the system log starting with
> +
> +*** SLUB <slab cache affected>: <What went wrong>@<object address>
> +offset=<offset of object into slab> flags=<slabflags>
> +inuse=<objects in use in this slab> freelist=<first free object in slab>
> +
> +2. Report on how the problem was dealt with in order to ensure the continued
> +operation of the system.
> +
> +These are messages in the system log beginning with
> +
> +@@@ SLUB <slab cache affected>: <corrective action taken>
> +
> +
> +In the above sample SLUB found that the Redzone of an active object has
> +been overwritten. Here a string of 8 characters was written into a slab that
> +has the length of 8 characters. However, a 8 character string needs a
> +terminating 0. That zero has overwritten the first byte of the Redzone field.
> +After reporting the details of the issue encountered the @@@ SLUB message
> +tell us that SLUB has restored the redzone to its proper value and then
> +system operations continue.
> +
> +Various types of lines can follow the @@@ SLUB line:
> +
> +Bytes b4 <address> : <bytes>
> +	Show a few bytes before the object where the problem was detected.
> +	Can be useful if the corruption does not stop with the start of the
> +	object.
> +
> +Object <address> : <bytes>
> +	The bytes of the object. If the object is inactive then the bytes
> +	typically contain poisoning values. Any non poison value shows a

                                                non-poison

> +	corruption by a write after free.
> +
> +Redzone <address> : <bytes>
> +	The redzone following the object. The redzone is used to detect
> +	writes after the object. All bytes should always have the same
> +	value. If there is any deviation then it is due to a write after
> +	the object boundary.
> +
> +Freepointer
> +	The pointer to the next free object in the slab. May become
> +	corrupted if overwriting continues after the red zone.
> +
> +Last alloc:
> +Last free:
> +	Shows the address from which the object was allocated/freed last.
> +	We note the pid, the time and the cpu that did so. This is usually

                                          CPU

> +	the most useful information to figure out where things went wrong.
> +	Here get_modalias did an kmalloc(8) instead of a kmalloc(9).
> +
> +Filler <address> : <bytes>
> +	Unused data to fill up the space in order to get the next object
> +	properly aligned. In the debug case we make sure that there are
> +	at least 4 bytes of filler. This allow for the detection of writes
> +	before the object.
> +
> +Following the filler will be a stackdump. That stackdump describes the
> +location where the error was detected. The cause of the corruption is more
> +likely to be found by looking at the information about the last alloc / free.



How large is the RedZone?  Is it a fixed size or does it vary?

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
