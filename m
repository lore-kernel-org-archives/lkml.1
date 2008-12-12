Return-Path: <linux-kernel-owner+w=401wt.eu-S1758116AbYLLCbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758116AbYLLCbu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 21:31:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756779AbYLLCbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 21:31:42 -0500
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:33574 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756606AbYLLCbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 21:31:41 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=mmhPU4hbabXkyIoUhbd1FpgB2sc950JjSwrsHFodzv78HbckbA79sJZCzPBKFUS4IDEB1EIN0nCBCwmebK1vBGV1XKVZVd1bwGGweXyvQMdPtnZCiHIy67XH6QZ+5Lue0ks4Pg/kp3ml46sFZrf00VgUxY9RIz2bFHeVa0eOABw=  ;
X-YMail-OSG: X4hgdEYVM1nOhD0c2HvgCg6sEqElCuaaEsvZGFY9lBwl0zv8koFZS.3t_nBvUdJRRbvuBpkTpQLDfF_ylXek.Q78iUCzUM8Q.QX8vbaI0QWUPVjDBIr7Tcrt2BVX5mjHXw2ACPxKjsuaZeE8v0Z8zo7dDfpbui6bqFiG.4g5
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][v2] fork_init: fix division by zero
Date: Fri, 12 Dec 2008 12:31:33 +1000
User-Agent: KMail/1.9.5
Cc: Al Viro <viro@zeniv.linux.org.uk>, yur@emcraft.com,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Geert.Uytterhoeven@sonycom.com, dhowells@redhat.com, miltonm@bga.com,
       wd@denx.de, dzu@denx.de, yanok@emcraft.com
References: <200812101950.51958.yur@emcraft.com> <20081211202800.GQ28946@ZenIV.linux.org.uk> <20081211124330.ff9b7483.akpm@linux-foundation.org>
In-Reply-To: <20081211124330.ff9b7483.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812121331.34602.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 December 2008 07:43, Andrew Morton wrote:
> On Thu, 11 Dec 2008 20:28:00 +0000

> >  Do they actually cross the page boundaries?
>
> Some flavours of slab have at times done an order-1 allocation for
> objects which would fit into an order-0 page (etc) if it looks like
> that will be beneficial from a packing POV.  I'm unsure whether that
> still happens - I tried to get it stamped out for reliability reasons.

Hmph, SLUB uses order-3 allocations for 832 byte sized objects
by default here (mm struct).
