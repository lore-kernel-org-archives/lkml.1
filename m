Return-Path: <linux-kernel-owner+w=401wt.eu-S1755372AbXHBOHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372AbXHBOHA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 10:07:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752788AbXHBOGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 10:06:52 -0400
Received: from ns.firmix.at ([62.141.48.66]:39376 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752782AbXHBOGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 10:06:51 -0400
Subject: Re: [PATCH] type safe allocator
From: Bernd Petrovitsch <bernd@firmix.at>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, torvalds@linux-foundation.org
In-Reply-To: <1186062476.12034.115.camel@twins>
References: <E1IGAAI-0006K6-00@dorka.pomaz.szeredi.hu>
	 <E1IGYuK-0001Jj-00@dorka.pomaz.szeredi.hu>
	 <b6fcc0a0708020504j7588061fq7e70a50499dcbdfe@mail.gmail.com>
	 <1186062476.12034.115.camel@twins>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Thu, 02 Aug 2007 16:06:45 +0200
Message-Id: <1186063605.8085.82.camel@tara.firmix.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -2.332 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Spam-Status: No, hits=-2.332 required=5
X-Spam-Score: -2.332 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-02 at 15:47 +0200, Peter Zijlstra wrote:
> On Thu, 2007-08-02 at 16:04 +0400, Alexey Dobriyan wrote:
> > On 8/2/07, Miklos Szeredi <miklos@szeredi.hu> wrote:
> > > The linux kernel doesn't have a type safe object allocator a-la new()
> > > in C++ or g_new() in glib.
> > >
> > > Introduce two helpers for this purpose:
> > >
> > >    alloc_struct(type, gfp_flags);
> > >
> > >    zalloc_struct(type, gfp_flags);
> > 
> > ick.
> > 
> > > These macros take a type name (usually a 'struct foo') as first
> > > argument
> > 
> > So one has to type struct twice.
> 
> thrice in some cases like alloc_struct(struct task_struct, GFP_KERNEL)

Save the explicit "struct" and put it into the macro (and force people
to not use typedefs).

#define alloc_struct(type, flags) ((type *)kmalloc(sizeof(struct type), (flags)))

Obious drawback: We may need alloc_union().

SCNR ...
	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services


