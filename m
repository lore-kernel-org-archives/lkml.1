Return-Path: <linux-kernel-owner+w=401wt.eu-S1763037AbZFQEVO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763037AbZFQEVO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 00:21:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751253AbZFQEVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 00:21:00 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:41783 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbZFQEU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 00:20:59 -0400
Message-ID: <4A386E1E.7080808@cs.helsinki.fi>
Date: Wed, 17 Jun 2009 07:16:30 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: linux-next: ext4 tree build failure
References: <20090616144413.50e975f9.sfr@canb.auug.org.au> <20090616203034.GB14788@mit.edu>
In-Reply-To: <20090616203034.GB14788@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ted,

Theodore Tso wrote:
> On Tue, Jun 16, 2009 at 02:44:13PM +1000, Stephen Rothwell wrote:
>> Hi Ted,
>>
>> Today's linux-next build (powerpc ppc64_defconfig) failed like this after
>> the slab tree was merged:
>>
>> In file included from fs/jbd2/checkpoint.c:26:
>> include/trace/events/jbd2.h:11: error: expected ')' before '(' token
>> include/trace/events/jbd2.h:31: error: expected ')' before '(' token
> 
> Hmm... I wonder why the slab tree would be messing with tracing
> include files.
> 
> Which slab tree is it?  Is it Pekka's?
> 
>       git://git.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6.git

Yup, that's it. I looked at this yesterday but didn't see anything 
suspicious. I don't think I have any patches that mess with any tracing 
include files. The only major change there should be the new default 
SLQB allocator. Perhaps ext4 is simply missing some includes that are 
pulled by SLUB but not SLQB?

			Pekka
