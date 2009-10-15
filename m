Return-Path: <linux-kernel-owner+w=401wt.eu-S1762230AbZJOAXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762230AbZJOAXl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 20:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762205AbZJOAXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 20:23:41 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:48134 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761119AbZJOAXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 20:23:39 -0400
Date: Wed, 14 Oct 2009 17:24:22 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: linux-kernel@vger.kernel.org, Oren Laadan <orenl@cs.columbia.edu>,
       serue@us.ibm.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@osdl.org>,
       torvalds@linux-foundation.org, mikew@google.com, mingo@elte.hu,
       hpa@zytor.com, Nathan Lynch <nathanl@austin.ibm.com>, arnd@arndb.de,
       peterz@infradead.org, Louis.Rilling@kerlabs.com, roland@redhat.com,
       kosaki.motohiro@jp.fujitsu.com, randy.dunlap@oracle.com,
       linux-api@vger.kernel.org,
       Containers <containers@lists.linux-foundation.org>, sukadev@us.ibm.com
Subject: Re: [RFC][v8][PATCH 4/10]: Add target_pid parameter to
	alloc_pidmap()
Message-ID: <20091015002422.GD3515@us.ibm.com>
References: <20091013044925.GA28181@us.ibm.com> <20091013045104.GD28435@us.ibm.com> <4AD46977.5020303@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AD46977.5020303@openvz.org>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Emelyanov [xemul@openvz.org] wrote:
| Sukadev Bhattiprolu wrote:
| > 
| > Subject: [RFC][v8][PATCH 4/10]: Add target_pid parameter to alloc_pidmap()
| > 
| 
| [ snip ]
| 
| > @@ -146,16 +146,22 @@ static int alloc_pidmap_page(struct pidm
| >  	return 0;
| >  }
| >  
| > -static int alloc_pidmap(struct pid_namespace *pid_ns)
| > +static int alloc_pidmap(struct pid_namespace *pid_ns, int target_pid)
| 
| Please no! Better create another function, that will just
| atomic_test_and_set() the proper bit in the map. This one
| is heavy enough already.

I had a set_pidmap() function before:

	http://lkml.org/lkml/2009/8/7/24

but dropped it based on some comments and the current version evolved
from it. I could go back to that if it still makes sense.

Thanks,

Sukadev
