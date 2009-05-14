Return-Path: <linux-kernel-owner+w=401wt.eu-S1754030AbZENP6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030AbZENP6t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 11:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752510AbZENP6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 11:58:40 -0400
Received: from exprod6og107.obsmtp.com ([64.18.1.208]:42647 "HELO
	exprod6og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751719AbZENP6j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 11:58:39 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH] net/sunrpc/svc.c: fix sparse warning
Date: Thu, 14 May 2009 11:58:37 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090179A55B@mi8nycmail19.Mi8.com>
In-Reply-To: <20090511230541.GL793@fieldses.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] net/sunrpc/svc.c: fix sparse warning
Thread-Index: AcnSjQN3ZpnRbpd7Rw+CjIEYO5mrZwCH0mMg
References: <BD79186B4FD85F4B8E60E381CAEE1909015F8D20@mi8nycmail19.Mi8.com> <20090416190601.GA1145@fieldses.org> <BD79186B4FD85F4B8E60E381CAEE1909015F8F97@mi8nycmail19.Mi8.com> <20090511230541.GL793@fieldses.org>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 14 May 2009 15:58:39.0676 (UTC) FILETIME=[D8FE07C0:01C9D4AC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 11, 2009 4:06 PM, J. Bruce Fields wrote:
> On Thu, Apr 16, 2009 at 03:15:17PM -0400, H Hartley Sweeten wrote:
>> On Thursday, April 16, 2009 12:06 PM, J. Bruce Fields wrote:
>>> On Wed, Apr 15, 2009 at 03:46:13PM -0400, H Hartley Sweeten wrote:
>>>> Fix sparse warning in net/sunrpc/svc.c.
>>>> 
>>>> 	warning: symbol 'node' shadows an earlier one
>>>
>>> What's the other symbol?
>>
>> Sorry. Left that out...
>> 
>> include/linux/nodemask.h
>> 
>> #define any_online_node(mask)			\
>> ({						\
>> 	int node;				\
>> 	for_each_node_mask(node, (mask))	\
>> 		if (node_online(node))		\
>> 			break;			\
>> 	node;					\
>> })
>> 
>> arch/powerpc/mm/numa.c is the only other user of that macro. In that
>> file the local variable is called nid, hence the name change in this
>> patch.
>
> Stupid question (and sorry for the delay): any reason that macro
> couldn't just be a static inline function?
>
> I'm sort of resistant to the idea that the caller should have to care
> what local variable names the implementation uses.

That would probably be cleaner and it would prevent the same warning
from possibly occurring in the future.  I just assumed it was originally
made a macro for a good reason.

Should I submit an updated patch changing the macro into an static
inline function?

Thanks,
Hartley
