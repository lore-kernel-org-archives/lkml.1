Return-Path: <linux-kernel-owner+w=401wt.eu-S1754616AbZGVWDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbZGVWDr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 18:03:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754658AbZGVWDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 18:03:45 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:51478 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754624AbZGVWDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 18:03:44 -0400
Subject: Re: [RFCv2][PATCH] flexible array implementation
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: vda.linux@googlemail.com, bblum@google.com, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, menage@google.com,
       akpm@linux-foundation.org
In-Reply-To: <20090722183018.GE5878@count0.beaverton.ibm.com>
References: <20090721220017.60A219D3@kernel>
	 <20090722183018.GE5878@count0.beaverton.ibm.com>
Content-Type: text/plain
Date: Wed, 22 Jul 2009 15:03:26 -0700
Message-Id: <1248300206.24021.347.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-22 at 11:30 -0700, Matt Helsley wrote:
> > +static int __check_part_and_nr(struct flex_array *fa,
> > +                            int part_nr, int element_nr)
> > +{
> > +     if (part_nr >= __nr_part_ptrs() ||
> > +         element_nr > fa->nr_elements) {
> > +             WARN(1, "bad flexible array element number: %d > %d\n",
> > +                     element_nr, fa->nr_elements);
> > +             return -EINVAL;
> > +     }
> > +     return 0;
> > +}
> 
> Should the above be inline? Does it make sense to optimize the "common"
> case and penalize inappropriate access by putting an unlikely() in
> there? Or is it too early for this stuff?

I think I'll leave it to the compiler for now.  Since we also don't have
a single user, I don't think we have an idea how hot of a path this
might get used in.

> I wonder how the *, /, and % ops will affect things that otherwise
> would have been reduced to shifts and masks -- especially on the
> "smaller" embedded archs.

I'm generally fine with rounding all these sizes to powers-of-two.  But,
I do think it's a wee bit premature at this point.

-- Dave

