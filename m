Return-Path: <linux-kernel-owner+w=401wt.eu-S1757483AbYFHVnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483AbYFHVnm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 17:43:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756036AbYFHVnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 17:43:32 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:61476 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436AbYFHVnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 17:43:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Z+7ipNEDssdOHtGt8mLvntXKIh/wtpQs0/tmkuFR6n7cl6ydhLv4nrA1nVDkMS7ThI
         AQdffJYuC7ncVJJdi6/cyUN2dByqoY7FQ9Lg9OpNidAhMC8ELi9I1PMRbDDMh1Oapkaj
         L/1kUMZD45J89p19p3OAE8n1Z01K3sHErDM9w=
Message-ID: <2c0942db0806081443o346619caj261edf7f13d05b75@mail.gmail.com>
Date: Sun, 8 Jun 2008 14:43:31 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Rik van Riel" <riel@redhat.com>
Subject: Re: [PATCH -mm 13/25] Noreclaim LRU Infrastructure
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       lee.schermerhorn@hp.com, kosaki.motohiro@jp.fujitsu.com,
       linux-mm@kvack.org, eric.whitney@hp.com
In-Reply-To: <20080608173244.0ac4ad9b@bree.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080606202838.390050172@redhat.com>
	 <20080606202859.291472052@redhat.com>
	 <20080606180506.081f686a.akpm@linux-foundation.org>
	 <20080608163413.08d46427@bree.surriel.com>
	 <20080608135704.a4b0dbe1.akpm@linux-foundation.org>
	 <20080608173244.0ac4ad9b@bree.surriel.com>
X-Google-Sender-Auth: f862e5dfcfd952b4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 8, 2008 at 2:32 PM, Rik van Riel <riel@redhat.com> wrote:
> On Sun, 8 Jun 2008 13:57:04 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
>
>> > > > From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
>> >
>> > > > The noreclaim infrastructure is enabled by a new mm Kconfig option
>> > > > [CONFIG_]NORECLAIM_LRU.
>> > >
>> > > Having a config option for this really sucks, and needs extra-special
>> > > justification, rather than none.
>> >
>> > I believe the justification is that it uses a page flag.
>> >
>> > PG_noreclaim would be the 20th page flag used, meaning there are
>> > 4 more free if 8 bits are used for zone and node info, which would
>> > give 6 bits for NODE_SHIFT or 64 NUMA nodes - probably overkill
>> > for 32 bit x86.
>> >
>> > If you want I'll get rid of CONFIG_NORECLAIM_LRU and make everything
>> > just compile in always.
>>
>> Seems unlikely to be useful?  The only way in which this would be an
>> advantage if if we hae some other feature which also needs a page flag
>> but which will never be concurrently enabled with this one.
>>
>> > Please let me know what your preference is.
>>
>> Don't use another page flag?
>
> I don't see how that would work.  We need a way to identify
> the status of the page.
>
>> > > > +#ifdef CONFIG_NORECLAIM_LRU
>> > > > +       PG_noreclaim,           /* Page is "non-reclaimable"  */
>> > > > +#endif
>> > >
>> > > I fear that we're messing up the terminology here.
>> > >
>> > > Go into your 2.6.25 tree and do `grep -i reclaimable */*.c'.  The term
>> > > already means a few different things, but in the vmscan context,
>> > > "reclaimable" means that the page is unreferenced, clean and can be
>> > > stolen.  "reclaimable" also means a lot of other things, and we just
>> > > made that worse.
>> > >
>> > > Can we think of a new term which uniquely describes this new concept
>> > > and use that, rather than flogging the old horse?
>> >
>> > Want to reuse the BSD term "pinned" instead?
>>
>> mm, "pinned" in Linuxland means "someone took a ref on it to prevent it
>> from being reclaimed".
>>
>> As a starting point: what, in your english-language-paragraph-length
>> words, does this flag mean?
>
> "Cannot be reclaimed because someone has it locked in memory
> through mlock, or the page belongs to something that cannot
> be evicted like ramfs."

"Unevictable"
