Return-Path: <linux-kernel-owner+w=401wt.eu-S1755901AbZGURZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901AbZGURZp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 13:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755862AbZGURZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 13:25:37 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:41080 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755856AbZGURZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 13:25:36 -0400
Subject: Re: [RFC][PATCH] flexible array implementation
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       bblum@google.com, linux-kernel@vger.kernel.org, menage@google.com
In-Reply-To: <1158166a0907210957p6fb73ed7pc7f5bb9f9ad6eac2@mail.gmail.com>
References: <20090721160333.96AA4D3D@kernel>
	 <1158166a0907210957p6fb73ed7pc7f5bb9f9ad6eac2@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 21 Jul 2009 10:25:30 -0700
Message-Id: <1248197130.13249.5520.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-21 at 18:57 +0200, Denys Vlasenko wrote:
> On Tue, Jul 21, 2009 at 6:03 PM, Dave Hansen<dave@linux.vnet.ibm.com> wrote:
> > +static inline struct flex_array_part *
> > +__fa_get_part(struct flex_array *fa, int part_nr, gfp_t flags)
> > +{
> > +       struct flex_array_part *part = NULL;
> > +       if (part_nr > __nr_part_ptrs())
> > +               return NULL;
> > +       part = fa->parts[part_nr];
> > +       if (!part) {
> > +               part = kmalloc(FLEX_ARRAY_PART_SIZE, flags);
> > +               if (!part)
> > +                       return NULL;
> > +               fa->parts[part_nr] = part;
> > +       }
> > +       return part;
> > +}
> 
> This is far too big to be an inline.

Yeah, I guess I should just leave it to the compiler to inline it since
it's only used in one place.

-- Dave

