Return-Path: <linux-kernel-owner+w=401wt.eu-S1762131AbZJNXD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762131AbZJNXD2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 19:03:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762105AbZJNXD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 19:03:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37703 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760624AbZJNXD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 19:03:26 -0400
Message-ID: <4AD6557D.3090501@zytor.com>
Date: Wed, 14 Oct 2009 15:49:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
CC: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       Oren Laadan <orenl@cs.columbia.edu>, serue@us.ibm.com,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       torvalds@linux-foundation.org, mikew@google.com, mingo@elte.hu,
       Nathan Lynch <nathanl@austin.ibm.com>, arnd@arndb.de,
       peterz@infradead.org, Louis.Rilling@kerlabs.com,
       kosaki.motohiro@jp.fujitsu.com, randy.dunlap@oracle.com,
       linux-api@vger.kernel.org,
       Containers <containers@lists.linux-foundation.org>, sukadev@us.ibm.com
Subject: Re: [RFC][v8][PATCH 0/10] Implement clone3() system call
References: <20091013044925.GA28181@us.ibm.com> <20091013205015.1ED524F7@magilla.sf.frob.com> <20091013232736.GA24392@us.ibm.com> <20091013235320.E90022746@magilla.sf.frob.com> <4AD525B3.2070906@zytor.com> <20091014223634.GB3515@us.ibm.com>
In-Reply-To: <20091014223634.GB3515@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2009 03:36 PM, Sukadev Bhattiprolu wrote:
> H. Peter Anvin [hpa@zytor.com] wrote:
> | 
> | Overall it seems sane to:
> | 
> | a) make it an actual 3-argument call;
> | b) make the existing flags a u32 forever, and make it a separate
> |    argument;
> | c) any new expansion can be via the struct, which may want to have
> |    an "c3_flags" field first in the structure.
> 
> Ok, So will this work ?
> 
> 	struct clone_args {
> 		u32 flags_high;		/* new clone flags (higher bits) */ 
> 		u32 reserved1;
> 		u32 nr_pids;
> 		u32 reserved2;
> 		u64 child_stack_base;
> 		u64 child_stack_size;
> 		u64 parent_tid_ptr;
> 		u64 child_tid_ptr;
> 		u64 reserved3;
> 	};
> 
> 	sys_clone3(u32 flags_low, struct clone_args *args, pid_t *pid_list)
> 
> Even on 64bit architectures the applications have to use sys_clone3() for
> the extended features.

Yes, although I'd just make flags_high a u64.  The other thing that
might be worthwhile is to have a length field on the structure; that way
we could add new fields at the end if ever necessary in the future.

	-hpa
