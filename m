Return-Path: <linux-kernel-owner+w=401wt.eu-S1755505AbYHMJOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505AbYHMJOn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 05:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752560AbYHMJOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 05:14:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40073 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752412AbYHMJOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 05:14:34 -0400
Date: Wed, 13 Aug 2008 11:14:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [patch]fastboot: remove duplicate unpack_to_rootfs()
Message-ID: <20080813091417.GH23417@elte.hu>
References: <1218607669.3463.9.camel@sli10-desk.sh.intel.com> <20080813074503.GB398@elte.hu> <20080813075236.GA8052@elte.hu> <20080813010605.b4a55f9b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080813010605.b4a55f9b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 13 Aug 2008 09:52:36 +0200 Ingo Molnar <mingo@elte.hu> wrote:
> 
> > no-newline-before-return:
> > 
> >          kfree(header_buf);
> >          return message;
> >  }
> 
> I accidentally delete those newlines when nobody is looking.  They 
> don't seem worth the space they consume.

yeah - for me it's case-dependent. My benchmark for it is absolutely 
objective and easy to describe: i add a newline when it looks nicer and 
more maintainable that way ;-)

> (what do we do with a function which has multiple `return's?)

i really didnt want to make a full scale style discussion out of this. 
Lets ignore my suggestion. The valid case when i use a newline is for 
example when the return obscures what happens:

	if (something) {
		do_one();
		repeat_this();
		return;
	}

as visually it's easy to miss the return - especially if the lines above 
it look similar. So i use:

	if (something) {
		do_one();
		repeat_this();

		return;
	}

because way too often do i miss a stray return somewhere and 
misunderstand the code flow of a function if it does not stand out, even 
with syntax highlighting.

Another case is when there's a long linear block of cleanup statements 
followed by a return:

        q->mode = mode;
        strcpy(q->name, name);
        q->next = NULL;
        *p = q;
        return NULL;
}

i usually add a newline:

        q->mode = mode;
        strcpy(q->name, name);
        q->next = NULL;
        *p = q;

        return NULL;
}

as the 'return NULL' is a separate concept from the preceding 
activities.

So in this case it is not really because the return is specialy, this is 
because i like to separate groups of statements per type of activity. So 
i'd do the same if there were two groups of statements, i'd turn this:

        q->mode = mode;
        strcpy(q->name, name);
        q->next = NULL;
        *p = q;
	other_stuff = 2;
	some_other_stuff(other_stuff)

into this:

        q->mode = mode;
        strcpy(q->name, name);
        q->next = NULL;
        *p = q;

	other_stuff = 2;
	some_other_stuff(other_stuff)

to make sure the two groups of statements stand out. (Sometimes a pure 
newline does a better job at inserting the right kind of visual 
structure than a comment line.)

but again ... these are nuances where reasonable people might disagree, 
and i only made them because this topic lives, is developed and tested 
in tip/fastboot at the moment.

	Ingo
