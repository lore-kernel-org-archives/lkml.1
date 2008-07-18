Return-Path: <linux-kernel-owner+w=401wt.eu-S1755677AbYGRIsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755677AbYGRIsd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 04:48:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754895AbYGRIsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 04:48:23 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:55919 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754848AbYGRIsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 04:48:20 -0400
Date: Fri, 18 Jul 2008 11:48:03 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
cc: cl@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>, Matt Mackall <mpm@selenic.com>
Subject: Re: [RFC PATCH 1/4] kmemtrace: Core implementation.
In-Reply-To: <20080717183206.GC5360@localhost>
Message-ID: <Pine.LNX.4.64.0807181140400.3739@sbz-30.cs.Helsinki.FI>
References: <cover.1216255034.git.eduard.munteanu@linux360.ro>
 <4472a3f883b0d9026bb2d8c490233b3eadf9b55e.1216255035.git.eduard.munteanu@linux360.ro>
 <84144f020807170101x25c9be11qd6e1996460bb24fc@mail.gmail.com>
 <20080717183206.GC5360@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eduard-Gabriel,

On Thu, 17 Jul 2008, Eduard - Gabriel Munteanu wrote:
> > > +struct kmemtrace_event {
> > 
> > So why don't we have the ABI version embedded here like blktrace has
> > so that user-space can check if the format matches its expectations?
> > That should be future-proof as well: as long as y ou keep the existing
> > fields where they're at now, you can always add new fields at the end
> > of the struct.
> 
> You can't add fields at the end, because the struct size will change and
> reads will be erroneous. Also, stamping every 'packet' with ABI version
> looks like a huge waste of space.

It's an ABI so you want to make it backwards compatible and extensible. 
Yes, it's just for debugging, so the rules are bit more relaxed here but 
that's not an excuse for not designing the ABI properly.

I really wish we would follow the example set by blktrace here. It uses a 
fixed-length header that knows the length of the rest of the packet.

		Pekka
