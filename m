Return-Path: <linux-kernel-owner+w=401wt.eu-S1756931AbYH0PVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931AbYH0PVy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 11:21:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753914AbYH0PVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 11:21:44 -0400
Received: from cluster-d.mailcontrol.com ([217.69.20.190]:44105 "EHLO
	cluster-d.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594AbYH0PVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 11:21:43 -0400
Message-ID: <48B570D6.7070301@csr.com>
Date: Wed, 27 Aug 2008 16:20:54 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Roland Dreier <rdreier@cisco.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       linux-usb <linux-usb@vger.kernel.org>, torvalds@linux-foundation.org
Subject: Re: [patch] Add helper macros for little-endian bitfields
References: <48AD6AF0.3050504@csr.com> <48AD6B93.7020702@csr.com> <adaprnxnac8.fsf@cisco.com> <20080825014311.GS28946@ZenIV.linux.org.uk>
In-Reply-To: <20080825014311.GS28946@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Aug 2008 15:20:54.0402 (UTC) FILETIME=[7F61A620:01C90858]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> On Sun, Aug 24, 2008 at 06:37:43PM -0700, Roland Dreier wrote:
>>  > + * NOTE: When using multibyte bitfields, you need to convert the data
>>  > + *       from Little Endian to CPU before you can access the bitfield
>>  > + *       (to make it simpler):
> 
> NOTE: When tempted to use multibyte bitfields on fixed-layout data, you
> need to look in the mirror, ask yourself "what will they do to me during
> code review for that?", shudder and decide that some temptations are
> just not worth the pain.

But why is this worthy of a crispy flaming?  I've not seen anything
definite beyond a somewhat vague 'some compilers don't optimize
bitfields very well'.

The structure definition and the DECL_BF_LEx() macros might be ugly but
the code using the structures is clearer.  For example,

    get_random_bytes(&tiebreaker, sizeof(unsigned));
    drp_ie->tiebreaker = tiebreaker & 1;

versus

    get_random_bytes(&tiebreaker, sizeof(unsigned));
    drp_ie->drp_control |= (tiebreaker & 1)
            ? UWB_DRP_IE_DRP_CTRL_TIEBREAKER : 0;

David
-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/
