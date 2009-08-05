Return-Path: <linux-kernel-owner+w=401wt.eu-S933957AbZHEJdE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933957AbZHEJdE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 05:33:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933925AbZHEJdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 05:33:03 -0400
Received: from pmx1.sophos.com ([213.31.172.16]:59048 "EHLO pmx1.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933678AbZHEJdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 05:33:01 -0400
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: John Stoffel <john@stoffel.org>
Subject: Re: fanotify - overall design before I start sending patches
Date: Wed, 5 Aug 2009 10:32:59 +0100
User-Agent: KMail/1.9.10
Cc: "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
       Eric Paris <eparis@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "malware-list@dmesg.printk.net" <malware-list@dmesg.printk.net>,
       "greg@kroah.com" <greg@kroah.com>, "jcm@redhat.com" <jcm@redhat.com>,
       Douglas Leeder <douglas.leeder@sophos.com>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "arjan@infradead.org" <arjan@infradead.org>,
       "david@lang.hm" <david@lang.hm>,
       "jengelh@medozas.de" <jengelh@medozas.de>,
       "aviro@redhat.com" <aviro@redhat.com>,
       "mrkafk@gmail.com" <mrkafk@gmail.com>,
       "alexl@redhat.com" <alexl@redhat.com>, "jack@suse.cz" <jack@suse.cz>,
       "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
       "hch@infradead.org" <hch@infradead.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
       "mmorley@hcl.in" <mmorley@hcl.in>, "pavel@suse.cz" <pavel@suse.cz>
References: <1248466429.3567.82.camel@localhost> <19585.1249406551@turing-police.cc.vt.edu> <19064.31705.491774.122207@stoffel.org>
In-Reply-To: <19064.31705.491774.122207@stoffel.org>
MIME-Version: 1.0
Message-Id: <200908051032.59866.tvrtko.ursulin@sophos.com>
X-MIMETrack: Itemize by SMTP Server on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 05/08/2009 10:33:00,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 05/08/2009 10:33:00,
	Serialize complete at 05/08/2009 10:33:00
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 August 2009 19:20:09 John Stoffel wrote:
> >>>>> "Valdis" == Valdis Kletnieks <Valdis.Kletnieks@vt.edu> writes:
>
> Valdis> On Tue, 04 Aug 2009 12:27:48 EDT, Eric Paris said:
> >> On Tue, 2009-08-04 at 17:09 +0100, Tvrtko Ursulin wrote:
> >> > Would it make more sense to deny on timeouts and then evict? I am
> >> > thinking it would be more secure with no significant drawbacks. Also
> >> > for usages like HSM allowing it without data being in place might
> >> > present wrong content to the user.
> >>
> >> I'd be willing to go that route as long as noone else complains.
>
> Valdis> Yes, in my world, "deny on timeout and evict" is the better
> Valdis> design decision.  For an HSM, you'd rather have a
> Valdis> quick-and-ugly death on a failed file open than an app
> Valdis> accidentally reading the HSM's stub data thinking it's the
> Valdis> original data.
>
> Speaking as somone who is working slowly to deploy an HSM service, one
> thing to note is that when you *do* see the stub file contents, you
> know that your HSM is busted somehow.
>
> How will fanotify deal with this issue?  Sorry, I haven't paid enough
> attention to this thread though I know I should since it's up my $WORK
> alley.

Would it make sense to allow the listener to pass in (on registration, maybe 
also on response) the error code which will be received by userspace? In that 
way HSM could set it to -ENODATA (or something), malware scanning to -EACCESS 
etc. which would give userspace a clearer indication of what went wrong.

Tvrtko
