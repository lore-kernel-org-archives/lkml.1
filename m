Return-Path: <linux-kernel-owner+w=401wt.eu-S932983AbZHDQVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932983AbZHDQVk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 12:21:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932970AbZHDQVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 12:21:40 -0400
Received: from pmx1.sophos.com ([213.31.172.16]:59564 "EHLO pmx1.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932913AbZHDQVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 12:21:38 -0400
X-Greylist: delayed 706 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Aug 2009 12:21:38 EDT
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: Eric Paris <eparis@redhat.com>
Subject: Re: fanotify - overall design before I start sending patches
Date: Tue, 4 Aug 2009 17:09:50 +0100
User-Agent: KMail/1.9.10
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "malware-list@dmesg.printk.net" <malware-list@dmesg.printk.net>,
       "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
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
References: <1248466429.3567.82.camel@localhost>
In-Reply-To: <1248466429.3567.82.camel@localhost>
MIME-Version: 1.0
Message-Id: <200908041709.51659.tvrtko.ursulin@sophos.com>
X-MIMETrack: Itemize by SMTP Server on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 04/08/2009 17:09:52,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 04/08/2009 17:09:52,
	Serialize complete at 04/08/2009 17:09:52
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Eric, all,

On Friday 24 July 2009 21:13:49 Eric Paris wrote:
> If a FAN_ACCESS_PERM or FAN_OPEN_PERM event is received the listener
> must send a response before the 5 second timeout.  If no response is
> sent before the 5 second timeout the original operation is allowed.  If
> this happens too many times (10 in a row) the fanotify group is evicted
> from the kernel and will not get any new events.  Sending a response is

Would it make more sense to deny on timeouts and then evict? I am thinking it 
would be more secure with no significant drawbacks. Also for usages like HSM 
allowing it without data being in place might present wrong content to the 
user.

> The only other current interface is the ability to ignore events by
> superblock magic number.  This makes it easy to ignore all events
> in /proc which can be difficult to accomplish firing FANOTIFY_SET_MARK
> with ignored_masks over and over as processes are created and destroyed.

Just to double-check, that would also work for any other filesystem and is 
controllable from userspace?

Tvrtko
