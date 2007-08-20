Return-Path: <linux-kernel-owner+w=401wt.eu-S1758536AbXHTJ2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758536AbXHTJ2U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 05:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754416AbXHTJ2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 05:28:11 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:23995 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374AbXHTJ2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 05:28:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=ZySQ2pZatWbB33vsVz8hk6AM0N0H0qyIQKLX8aaqmxjjxuqt8A1emmRpeY/0llIwSlhGwSLAiKSYx17SCxSCU81iW85m4bJmWXtxlIK+g8Fcz8QqvMMYsCFP4cutxBnrz88RQwGfzVzz5MHTTO/xV+c5dng/6iIQIU5RgNF0WM0=
Message-ID: <84144f020708200228v1af5248cx6f6da4a7a35400f3@mail.gmail.com>
Date: Mon, 20 Aug 2007 12:28:09 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 04/10] mm: slub: add knowledge of reserve pages
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       "David Miller" <davem@davemloft.net>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Daniel Phillips" <phillips@google.com>,
       "Christoph Lameter" <clameter@sgi.com>,
       "Matt Mackall" <mpm@selenic.com>,
       "Lee Schermerhorn" <Lee.Schermerhorn@hp.com>,
       "Steve Dickson" <SteveD@redhat.com>
In-Reply-To: <1187601455.6114.189.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070806102922.907530000@chello.nl>
	 <20070806103658.603735000@chello.nl> <1187595513.6114.176.camel@twins>
	 <Pine.LNX.4.64.0708201211240.20591@sbz-30.cs.Helsinki.FI>
	 <1187601455.6114.189.camel@twins>
X-Google-Sender-Auth: 76457bd780eea76b
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Mon, 2007-08-20 at 12:12 +0300, Pekka J Enberg wrote:
> > Any reason why the callers that are actually interested in this don't do
> > page->reserve on their own?

On 8/20/07, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> because new_slab() destroys the content?

Right. So maybe we could move the initialization parts of new_slab()
to __new_slab() so that the callers that are actually interested in
'reserve' could do allocate_slab(), store page->reserve and do rest of
the initialization with it?

As for the __GFP_WAIT handling, I *think* we can move the interrupt
enable/disable to allocate_slab()... Christoph?

                                       Pekka
