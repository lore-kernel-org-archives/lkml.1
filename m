Return-Path: <linux-kernel-owner+w=401wt.eu-S1760781AbZJNBYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760781AbZJNBYp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 21:24:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753248AbZJNBYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 21:24:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35067 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbZJNBYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 21:24:44 -0400
Message-ID: <4AD525B3.2070906@zytor.com>
Date: Tue, 13 Oct 2009 18:13:23 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Oren Laadan <orenl@cs.columbia.edu>,
       serue@us.ibm.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       torvalds@linux-foundation.org, mikew@google.com, mingo@elte.hu,
       Nathan Lynch <nathanl@austin.ibm.com>, arnd@arndb.de,
       peterz@infradead.org, Louis.Rilling@kerlabs.com,
       kosaki.motohiro@jp.fujitsu.com, randy.dunlap@oracle.com,
       linux-api@vger.kernel.org,
       Containers <containers@lists.linux-foundation.org>, sukadev@us.ibm.com
Subject: Re: [RFC][v8][PATCH 0/10] Implement clone3() system call
References: <20091013044925.GA28181@us.ibm.com>	<20091013205015.1ED524F7@magilla.sf.frob.com>	<20091013232736.GA24392@us.ibm.com> <20091013235320.E90022746@magilla.sf.frob.com>
In-Reply-To: <20091013235320.E90022746@magilla.sf.frob.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2009 04:53 PM, Roland McGrath wrote:
>> My only concern is the support of 64-bit clone flags on 32-bit architectures.
> 
> Oy.  I didn't realize there was serious consideration of having more than
> 32 flags.  IMHO it would be a bad choice, since they could only be used via
> clone3.  Having high-bit flags work in clone on 64-bit machines but not on
> 32-bit machines just seems like a wrongly confusing way for things to be.
> If any high-bits flags are constrained even on 64-bit machines to uses in
> clone3 calls for sanity purposes, then it seems questionable IMHO to have
> them be more flags in the same u64 at all.
> 
> Since all new features will be via this struct, various new kinds of things
> could potentially be done by other new struct fields independent of flags.
> But that would of course require putting enough reserved fields in now and
> requiring that they be zero-filled now in anticipation of such future uses,
> which is not very pleasant either.
> 
> In short, I guess I really am saying that "clone_flags_high" (or
> "more_flags" or something) does seem better to me than any of the
> possibilities for having more than 32 CLONE_* in the current flags word.
> 

Overall it seems sane to:

a) make it an actual 3-argument call;
b) make the existing flags a u32 forever, and make it a separate
   argument;
c) any new expansion can be via the struct, which may want to have
   an "c3_flags" field first in the structure.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

